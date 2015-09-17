//
//  EHSOSAlertView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSOSAlertView.h"

@implementation EHSOSAlertView

-(UIView *)getAleatCustomView{
    return self.sosCustomView;
}

-(EHSOSCustomView *)sosCustomView{
    if (_sosCustomView == nil) {
        _sosCustomView = [[EHSOSCustomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 * 2, 80)];
    }
    return _sosCustomView;
}

@end
