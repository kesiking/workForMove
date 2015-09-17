//
//  EHSOSCustomView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@interface EHSOSCustomView : KSView

@property (nonatomic,strong) UILabel * sosMessageLabel;
@property (nonatomic,strong) UILabel * sosTitlelabel;
@property (nonatomic,strong) UIImageView * sosImageView;

-(void)setTitleText:(NSString*)titleText messageText:(NSString*)messageText;

@end
