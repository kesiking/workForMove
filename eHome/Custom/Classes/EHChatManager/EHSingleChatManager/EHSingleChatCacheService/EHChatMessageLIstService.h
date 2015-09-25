//
//  EHCHatMessageLIstService.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"
#import "EHChatMessagePageList.h"

@interface EHChatMessageLIstService : KSAdapterService

-(void)loadChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone;

-(BOOL)hasMoreData;

@end
