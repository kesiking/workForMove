//
//  EdgeInsetUILabel.m
//  eHome
//
//  Created by jss on 15/11/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EdgeInsetUILabel.h"

@implementation EdgeInsetUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)drawTextInRect:(CGRect)rect{
    CGRect newRect = CGRectMake(rect.origin.x + 15, rect.origin.y + 10, rect.size.width - 30, rect.size.height -20);
    [super drawTextInRect:newRect];

}

@end
