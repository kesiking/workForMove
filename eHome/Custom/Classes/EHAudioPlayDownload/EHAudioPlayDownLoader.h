//
//  EHAudioPlayDownLoader.h
//  eHome
//
//  Created by 孟希羲 on 15/9/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHAudioDataCache.h"

typedef void(^EHAudioDataDownloadCompletedBlock)(NSData *AudioData, EHAudioDataCacheType cacheType, BOOL finished, NSURL *url, NSError *error);


@interface EHAudioPlayDownLoader : NSObject

+ (EHAudioPlayDownLoader *)sharedManager;

-(void)loadAudioPlayDataWithUrl:(NSURL*)url completeBlock:(EHAudioDataDownloadCompletedBlock)completeBlock;

-(NSString*)getFilePathWithURL:(NSURL *)url;

@end
