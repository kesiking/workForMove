//
//  EHSetLocationModeService.h
//  eHome
//
//  Created by jss on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHSetLocationModeService : KSAdapterService
-(void)setLocationMode:(NSString*)babyId babyLocationMode:(NSString*)locationMode;
@end
