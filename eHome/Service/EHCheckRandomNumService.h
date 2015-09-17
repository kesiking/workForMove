//
//  EHCheckRandomNumService.h
//  eHome
//
//  Created by louzhenhua on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface EHCheckRandomNumService : KSAdapterService

-(void)checkRandomNum:(NSString*)randomNum withUserPhone:(NSString*)userPhone;

@end
