//
//  EHSOSCustomView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSOSCustomView.h"

#define KSOSImageWidth          (35)
#define KSOSImageHeight         (KSOSImageWidth)
#define KSOSImageMarginLeft     (20)
#define KSOSImageMarginTop      (20)

#define KSOSNamelabelWidth  (200)
#define KSOSNamelabelHeight (16)

@implementation EHSOSCustomView

-(void)setupView{
    [super setupView];
}

-(void)setTitleText:(NSString*)titleText messageText:(NSString*)messageText{
    [self.sosTitlelabel setText:titleText];
    [self.sosMessageLabel setText:messageText];
}

-(UILabel *)sosTitlelabel{
    if (!_sosTitlelabel) {
        _sosTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sosImageView.right + 5, self.sosImageView.top, KSOSNamelabelWidth, KSOSNamelabelHeight)];
        _sosTitlelabel.font = EH_font3;
        _sosTitlelabel.textColor = EH_cor7;
        _sosTitlelabel.numberOfLines = 1;
        _sosTitlelabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_sosTitlelabel];
    }
    return _sosTitlelabel;
}

-(UILabel *)sosMessageLabel{
    if (!_sosMessageLabel) {
        _sosMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sosTitlelabel.left , self.sosTitlelabel.bottom, self.sosTitlelabel.width, KSOSNamelabelHeight * 2)];
        _sosMessageLabel.font = EH_font6;
        _sosMessageLabel.textColor = EH_cor4;
        _sosMessageLabel.numberOfLines = 2;
        _sosMessageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_sosMessageLabel];
    }
    return _sosMessageLabel;
}

-(UIImageView *)sosImageView{
    if (!_sosImageView) {
        _sosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KSOSImageMarginLeft, KSOSImageMarginTop, KSOSImageWidth, KSOSImageHeight)];
        _sosImageView.image = [UIImage imageNamed:@"ico_SOS_70"];
        [self addSubview:_sosImageView];
    }
    return _sosImageView;
}

@end
