//
//  EHChatMessageSendService.h
//  eHome
//
//  Created by 孟希羲 on 15/9/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHChatMessageinfoModel.h"

@interface EHChatMessageSendService : KSAdapterService

-(void)sendChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone context:(NSString*)context  messageData:(NSData*)messageData contextType:(NSString*)context_type;

@end
