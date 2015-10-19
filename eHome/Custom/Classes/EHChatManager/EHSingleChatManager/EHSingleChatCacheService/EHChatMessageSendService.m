//
//  EHChatMessageSendService.m
//  eHome
//
//  Created by 孟希羲 on 15/9/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessageSendService.h"

#pragma mark - EHChatMessageVoiceDataResponseModel

@interface EHChatMessageVoiceDataResponseModel : WeAppComponentBaseItem

@property(nonatomic, strong)    NSString*          voiceCallUrl;

@property(nonatomic, strong)    NSString*          voiceCallName;

@property(nonatomic, strong)    NSString*          voiceCallDuration;

@end

@implementation EHChatMessageVoiceDataResponseModel

@end

@interface EHChatMessageVoiceDataUploadService : KSAdapterService

- (void)uploadVoiceDataWithData:(NSData *)voiceData userPhone:(NSString *)userPhone deviceCode:(NSString*)deviceCode;

@end

#pragma mark - EHChatMessageVoiceDataUploadService
@implementation EHChatMessageVoiceDataUploadService

- (void)uploadVoiceDataWithData:(NSData *)voiceData userPhone:(NSString *)userPhone deviceCode:(NSString*)deviceCode{
    if (voiceData == nil) {
        EHLogError(@"voiceData is nil");
        return;
    }
    if (userPhone == nil) {
        userPhone = [KSAuthenticationCenter userPhone];
    }
    if (userPhone == nil) {
        EHLogError(@"userPhone is nil");
        return;
    }
    if (deviceCode == nil) {
        return;
    }
    self.itemClass = [EHChatMessageVoiceDataResponseModel class];
    self.jsonTopKey = @"responseData";
    
    [self uploadFileWithAPIName:KEHUploadVoiceCallMsgMessageApiName withFileName:[self fileName] withFileContent:voiceData params:@{@"user_phone":userPhone,@"fileName":[self fileName],@"device_code":deviceCode} version:nil];
}

-(NSString *)fileName{
    NSString *fileName = [NSString stringWithFormat:@"%@.amr",[self uuid]];
    return fileName;
}

- (NSString*)uuid{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end

#pragma mark - EHChatMessageSendService

@interface EHChatMessageSendService()

@property(nonatomic, strong)    EHChatMessageVoiceDataUploadService*   chatMessageVoiceDataUploadService;

@end

@implementation EHChatMessageSendService

-(void)sendChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone context:(NSString*)context messageData:(NSData*)messageData contextType:(NSString*)context_type{
    if ([EHUtils isEmptyString:userPhone]) {
        return;
    }
    if (babyId == nil) {
        return;
    }
    if (context_type == nil || context_type.length == 0) {
        context_type = CONTEXT_TYPE_TEXT;
    }
    
    NSMutableDictionary* params = [@{@"baby_id":babyId,@"userPhone":userPhone,@"context_type":context_type,@"sender":SEND_MESSAGE_FROM_APP_USER} mutableCopy];
    
    self.jsonTopKey = @"responseData";
    self.itemClass = [EHChatMessageinfoModel class];
    
    
    if ([context_type isEqualToString:CONTEXT_TYPE_TEXT] && ![EHUtils isEmptyString:context]) {// 如果是文字直接发送
        [params setObject:context forKey:@"context"];
        [self loadItemWithAPIName:KEHSendChatMessageApiName params:params version:nil];
    }else if ([context_type isEqualToString:CONTEXT_TYPE_VOICE] && messageData){// 如果是语音则先上传语音获得URL后再发送
        WEAKSELF
        self.chatMessageVoiceDataUploadService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
           STRONGSELF
            if (service.item) {
                EHChatMessageVoiceDataResponseModel* chatMessageVoiceDataResponseModel = (EHChatMessageVoiceDataResponseModel*)service.item;
                if (chatMessageVoiceDataResponseModel.voiceCallDuration) {
                    [params setObject:chatMessageVoiceDataResponseModel.voiceCallDuration forKey:@"callDuration"];
                }
                if (chatMessageVoiceDataResponseModel.voiceCallUrl) {
                    [params setObject:chatMessageVoiceDataResponseModel.voiceCallUrl forKey:@"context"];
                    [strongSelf loadItemWithAPIName:KEHSendChatMessageApiName params:params version:nil];
                    return;
                }
            }
            NSError* error = [NSError errorWithDomain:@"返回数据中没有voiceUrl" code:400 userInfo:nil];
            [strongSelf model:strongSelf.requestModel didFailLoadWithError:error];
        };
        
        self.chatMessageVoiceDataUploadService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf model:strongSelf.requestModel didFailLoadWithError:error];
        };
        
        EHGetBabyListRsp* babyInfo = [[EHBabyListDataCenter sharedCenter] getBabyListRspWithBabyId:babyId];
        [self.chatMessageVoiceDataUploadService uploadVoiceDataWithData:messageData userPhone:userPhone deviceCode:babyInfo.device_code];
    }else{
        NSError* error = [NSError errorWithDomain:@"数据格式不正确" code:400 userInfo:nil];
        [self model:self.requestModel didFailLoadWithError:error];
    }
    
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    NSString* context_type = [model.params objectForKey:@"context_type"];
    if ([context_type isEqualToString:CONTEXT_TYPE_VOICE] && model.item && [model.item isKindOfClass:[EHChatMessageinfoModel class]]) {// 如果是文字直接发送
        NSString* voiceCallUrl = [model.params objectForKey:@"context"];
        NSString* voiceCallDuration = [model.params objectForKey:@"callDuration"];
        EHChatMessageinfoModel* chatMessageinfoModel = (EHChatMessageinfoModel*)model.item;
        chatMessageinfoModel.context = voiceCallUrl;
        if (voiceCallDuration) {
            chatMessageinfoModel.call_duration = [NSNumber numberWithInteger:[voiceCallDuration integerValue]];
        }
    }
    [super modelDidFinishLoad:model];
}

-(EHChatMessageVoiceDataUploadService *)chatMessageVoiceDataUploadService{
    if (_chatMessageVoiceDataUploadService == nil) {
        _chatMessageVoiceDataUploadService = [EHChatMessageVoiceDataUploadService new];
    }
    return _chatMessageVoiceDataUploadService;
}

@end




