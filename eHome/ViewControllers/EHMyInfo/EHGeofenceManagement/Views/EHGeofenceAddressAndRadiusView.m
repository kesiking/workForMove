//
//  EHGeofenceAddressAndRadiusView.m
//  eHome
//
//  Created by xtq on 15/9/30.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceAddressAndRadiusView.h"
#import "NSString+StringSize.h"

@interface EHGeofenceAddressAndRadiusView ()

@property (nonatomic, strong)UILabel *addressLabel;

@property (nonatomic, strong)UILabel *radiusLabel;

@end

@implementation EHGeofenceAddressAndRadiusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EHBgcor3;
        [self addSubview:self.addressLabel];
        [self addSubview:self.radiusLabel];
        
        CALayer *topLineLayer = [CALayer layer];
        topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.5);
        topLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:topLineLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat addressHeight = [@"text" sizeWithFontSize:EHSiz2 Width:MAXFLOAT].height;
    CGFloat radiusHeight = [@"text" sizeWithFontSize:EHSiz5 Width:MAXFLOAT].height;
    CGFloat spaceY = (CGRectGetHeight(self.frame) - addressHeight - radiusHeight - 8) / 2.0;
    CGRect frame = CGRectMake(12, spaceY, CGRectGetWidth(self.frame), addressHeight);
    self.addressLabel.frame = frame;
    frame.origin.y += addressHeight + 8;
    self.radiusLabel.frame = frame;
}

#pragma mark - Getters And Setters
-(NSString *)address {
    return self.addressLabel.text;
}

- (void)setAddress:(NSString *)address {
    self.addressLabel.text = address;
}

- (void)setRadius:(NSInteger)radius {
    _radius = radius;
    self.radiusLabel.text = [NSString stringWithFormat:@"%ld米",_radius];
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = EHFont2;
        _addressLabel.textColor = EHCor5;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc]init];
        _radiusLabel.font = EHFont5;
        _radiusLabel.textColor = EHCor5;
        _radiusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _radiusLabel;
}

@end
