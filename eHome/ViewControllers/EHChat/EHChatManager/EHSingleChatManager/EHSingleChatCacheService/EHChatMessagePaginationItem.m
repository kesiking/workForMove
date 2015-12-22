//
//  EHChatMessagePaginationItem.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHChatMessagePaginationItem.h"

@implementation EHChatMessagePaginationItem

- (id)init {
    if (self = [super init]) {
        self.useTimesatmpAsReference = YES;
        self.paginationType = WeAppPaginationTypeTimeStamp;
        self.paginationTimestamp = WeAppPaginationTimestampAfter;
    }
    return self;
}

-(void)paginationPlus{
    self.reallyCurpage++;
    self.curPage = self.reallyCurpage;
}

-(void)addParams:(NSDictionary *)params withDict:(NSMutableDictionary *)dict{
    if (dict && [dict isKindOfClass:[NSMutableDictionary class]]) {
        
        NSString* timestampName = [NSString stringWithFormat:@"time_flag"];
        NSString* pageSizeName =  [NSString stringWithFormat:@"result_num"];
        NSString* directionName = [NSString stringWithFormat:@"direction"];
        
        if (self.beforTimestampStr) {
            [dict setObject:self.beforTimestampStr forKey:((NSString*)timestampName)];
        }else if(self.afterTimestampStr){
            [dict setObject:self.afterTimestampStr forKey:((NSString*)timestampName)];
        }else{
            [dict setObject:@"" forKey:((NSString*)timestampName)];
        }
        
        [dict setObject:@(self.pageSize) forKey:((NSString*)pageSizeName)];
        [dict setObject:[NSString stringWithFormat:@"%d", self.direction] forKey:((NSString*)directionName)];
    }
    
}

@end
