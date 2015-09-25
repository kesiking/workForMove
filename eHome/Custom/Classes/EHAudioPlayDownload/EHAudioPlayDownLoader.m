//
//  EHAudioPlayDownLoader.m
//  eHome
//
//  Created by 孟希羲 on 15/9/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAudioPlayDownLoader.h"
#import "AFHTTPRequestOperationManager.h"
#import "EHAudioPlayResponseSerializer.h"
#import "XHVoiceRecordHelper.h"

@interface EHAudioPlayDownLoader ()

@property (strong, nonatomic) EHAudioDataCache     *audioDataCache;
@property (strong, nonatomic) NSMutableDictionary  *runningOperations;

@end

@implementation EHAudioPlayDownLoader

+ (EHAudioPlayDownLoader *)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _audioDataCache = [self createCache];
        _runningOperations = [NSMutableDictionary new];
    }
    return self;
}

- (EHAudioDataCache *)createCache {
    return [EHAudioDataCache sharedAudioDataCache];
}

-(void)loadAudioPlayDataWithUrl:(NSURL*)url completeBlock:(EHAudioDataDownloadCompletedBlock)completeBlock{
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    
    NSString *key = [self cacheKeyForURL:url];
    
    if ([self.runningOperations objectForKey:key]) {
        EHLogInfo(@"-----> EHAudioPlayDownLoader is downloading the url : %@",key);
        return;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations setObject:@(true) forKey:key];
    }
    
    [self.audioDataCache queryDiskCacheForKey:key done:^(NSData *AudioData, EHAudioDataCacheType cacheType) {
        if (AudioData) {
            dispatch_main_sync_safe(^{
                if (completeBlock) {
                    completeBlock(AudioData,cacheType, YES, url, nil);
                }
                EHLogInfo(@"-----> EHAudioPlayDownLoader load audio data from disc with url : %@",key);
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObjectForKey:key];
            }
        }else {
            WEAKSELF
            AFHTTPRequestOperationManager *httpRequestOM = [[AFHTTPRequestOperationManager alloc] init];
            [httpRequestOM setResponseSerializer:[EHAudioPlayResponseSerializer new]];
            [httpRequestOM POST:url.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                STRONGSELF
                if (responseObject) {
                    // amr转wav 然后存储在缓存中
                    NSData* audioData = nil;
                    NSString* amrPath = [XHVoiceRecordHelper getRecorderPathofType:@"amr"];
                    if (![responseObject writeToFile:amrPath atomically:YES]) {
                        return;
                    }
                    
                    NSString* convertedPath = [XHVoiceRecordHelper getRecorderPathofType:@"wav"];
                    if ([VoiceConverter ConvertAmrToWav:amrPath wavSavePath:convertedPath]){
                        audioData = [NSData dataWithContentsOfFile:convertedPath];
                        if (audioData) {
                            [strongSelf.audioDataCache storeAudioData:audioData forKey:key];
                            dispatch_main_sync_safe(^{
                                EHLogInfo(@"-----> EHAudioPlayDownLoader load audio data successfully from network with url : %@",key);
                                if (completeBlock) {
                                    completeBlock(audioData,EHAudioDataCacheTypeNone, YES, url, nil);
                                }
                            });
                        }else{
                            EHLogInfo(@"wav读取失败");
                            NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: @"wav读取失败"}];
                            if (completeBlock) {
                                completeBlock(nil,EHAudioDataCacheTypeNone, YES, url, error);
                            }
                        }
                    }else{
                        EHLogInfo(@"amr转wav失败");
                        NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: @"amr转wav失败"}];
                        if (completeBlock) {
                            completeBlock(nil,EHAudioDataCacheTypeNone, YES, url, error);
                        }
                    }

                }else{
                    EHLogInfo(@"数据获取失败");
                    NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: @"数据获取失败"}];
                    if (completeBlock) {
                        completeBlock(nil,EHAudioDataCacheTypeNone, YES, url, error);
                    }
                }
                
                @synchronized (self.runningOperations) {
                    [self.runningOperations removeObjectForKey:key];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                dispatch_main_sync_safe(^{
                    if (completeBlock) {
                        completeBlock(nil,EHAudioDataCacheTypeNone, YES, url, error);
                    }
                });
                @synchronized (self.runningOperations) {
                    [self.runningOperations removeObjectForKey:key];
                }
                EHLogInfo(@"-----> EHAudioPlayDownLoader load audio data failed from network with url : %@",key);

            }];
        }
    }];
}

-(NSString*)getFilePathWithURL:(NSURL *)url{
    NSString* key = [self cacheKeyForURL:url];
    return [self.audioDataCache defaultCachePathForKey:key];
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    return [url absoluteString];
}

@end
