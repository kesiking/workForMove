//
//  EHCHatMessageLIstService.h
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHChatMessageLIstService : KSAdapterService

-(void)loadChatMessageListWithBabyId:(NSNumber*)babyId userPhone:(NSString*)userPhone context:(NSString*)context contextType:(NSString*)contextType;

@end
