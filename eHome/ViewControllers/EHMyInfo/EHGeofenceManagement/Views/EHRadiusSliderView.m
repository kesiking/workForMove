//
//  EHRadiusSliderView.m
//  eHome
//
//  Created by xtq on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHRadiusSliderView.h"

@interface EHRadiusSliderView ()

@property (nonatomic, strong) UISlider *radiusSlider;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *radiusLabel;

@property (nonatomic, assign) BOOL beginSliding;

@end

@implementation EHRadiusSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EHBgcor3;
        self.radius = 500;
        self.beginSliding = NO;
        [self addSubview:self.radiusSlider];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.radiusLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Events Response
- (void)sliderValueChange:(id)sender{
    if (!self.beginSliding) {
        for (UITapGestureRecognizer *tap in [self gestureRecognizers]) {
            [self removeGestureRecognizer:tap];
        }
    }
    self.beginSliding = YES;
    
    UISlider *slider = (UISlider *)sender;
    NSInteger value = (int)slider.value - ((int)slider.value % 100);
    if (value != self.radius) {
        self.radius = value;
    }
}

- (void)sliderTouchUpInside:(id)sender{
    self.beginSliding = NO;
    UISlider *slider = (UISlider *)sender;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
    [self addGestureRecognizer:tap];

    NSInteger value = (int)slider.value - ((int)slider.value % 100);
    self.radius = value;

    !self.radiusChangedBlock?:self.radiusChangedBlock(value);
}

- (void)sliderTap:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tap locationInView:self];
        float x = location.x - CGRectGetMinX(self.radiusSlider.frame);
        float r = x/CGRectGetWidth(self.radiusSlider.frame);
        float value = (self.radiusSlider.maximumValue-self.radiusSlider.minimumValue) * r + self.radiusSlider.minimumValue;
        value = MAX(value, self.radiusSlider.minimumValue);
        value = MIN(value, self.radiusSlider.maximumValue);
        [self.radiusSlider setValue:value animated:YES];
        
        NSInteger radius = (int)value - ((int)value % 100);
        self.radius = radius;
        
        !self.radiusChangedBlock?:self.radiusChangedBlock(radius);

    }
}

#pragma mark - Private Methods
- (void)reSetRadiusLabel:(UISlider *)slider {
    
    self.radiusLabel.text = [NSString stringWithFormat:@"%ld米",self.radius];
    
    CGRect frame = self.radiusLabel.frame;
    frame.origin.x = (self.radius - slider.minimumValue) / (slider.maximumValue - slider.minimumValue) * CGRectGetWidth(slider.frame) + CGRectGetMinX(self.radiusSlider.frame) - CGRectGetWidth(self.radiusLabel.frame)/2.0 + 11;
    self.radiusLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.radius == slider.minimumValue) {
        frame.origin.x = 0;
    }
    if (self.radius == slider.maximumValue) {
        frame.origin.x = CGRectGetWidth(slider.superview.frame) - CGRectGetWidth(self.radiusLabel.frame);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.radiusLabel.frame = frame;

    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Getters And Setters
- (void)setRadius:(NSInteger)radius {
    _radius = radius;
    self.radiusSlider.value = radius;
    [self reSetRadiusLabel:self.radiusSlider];
}

- (CGFloat)minimumValue {
    return self.radiusSlider.minimumValue;
}

- (CGFloat)maximumValue {
    return self.radiusSlider.maximumValue;
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    self.radiusSlider.minimumValue = minimumValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    self.radiusSlider.maximumValue = maximumValue;
}

- (UISlider *)radiusSlider {
    if (!_radiusSlider) {
        _radiusSlider = [[UISlider alloc]initWithFrame:CGRectMake(25, 20, CGRectGetWidth(self.frame) - 50, 20)];
        
        [_radiusSlider setThumbImage:[UIImage imageNamed:@"icon_drag"] forState:UIControlStateNormal];
        _radiusSlider.minimumTrackTintColor = EHCor6;
        _radiusSlider.maximumTrackTintColor = RGB(0x8e, 0x8e, 0x93);

        _radiusSlider.minimumValue = 300;
        _radiusSlider.maximumValue = 2000;
        _radiusSlider.value = self.radius;
        
        [_radiusSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];    //值发生改变
        [_radiusSlider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];   //值结束改变

    }
    return _radiusSlider;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 19, 100, 10)];
        _leftLabel.font = EH_font8;
        _leftLabel.textColor = EH_cor3;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text = @"300米";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100 - 10, CGRectGetHeight(self.frame) - 19, 100, 10)];
        _rightLabel.font = EH_font8;
        _rightLabel.textColor = EH_cor3;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"2000米";
    }
    return _rightLabel;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        
        _radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50 - 25, 0, 50, 20)];
        _radiusLabel.font = EH_font8;
        _radiusLabel.textColor = EH_cor3;
        _radiusLabel.textAlignment = NSTextAlignmentCenter;
        _radiusLabel.text = [NSString stringWithFormat:@"%ld米",_radius];
        CGRect frame = self.radiusLabel.frame;
        frame.origin.x = (self.radiusSlider.value - self.radiusSlider.minimumValue) / (self.radiusSlider.maximumValue - self.radiusSlider.minimumValue) * CGRectGetWidth(self.radiusSlider.frame) + 25 - 25;
        _radiusLabel.frame = frame;
    }
    return _radiusLabel;
}

@end
