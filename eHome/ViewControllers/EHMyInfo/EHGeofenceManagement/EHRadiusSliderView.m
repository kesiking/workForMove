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

@end

@implementation EHRadiusSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _radius = 500;
        
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
    UISlider *slider = (UISlider *)sender;
    
    NSInteger value = (int)slider.value - ((int)slider.value % 100);
    [slider setValue:value animated:YES];
    
    self.radius = value;
    
    [self reSetRadiusLabel:slider];
    
    !self.radiusChangedBlock?:self.radiusChangedBlock(value);
}

- (void)sliderTap:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tap locationInView:self];
        float x = location.x - 20;
        float r = x/CGRectGetWidth(self.radiusSlider.frame);
        float value = (self.radiusSlider.maximumValue-self.radiusSlider.minimumValue) * r + self.radiusSlider.minimumValue;
        [self.radiusSlider setValue:value animated:NO];
        [self performSelector:@selector(sliderValueChange:) withObject:self.radiusSlider afterDelay:0];
    }
}

#pragma mark - Private Methods
- (void)reSetRadiusLabel:(UISlider *)slider {
    
    self.radiusLabel.text = [NSString stringWithFormat:@"%ldm",(NSInteger)slider.value];
    
    CGRect frame = self.radiusLabel.frame;
    frame.origin.x = (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue) * CGRectGetWidth(slider.frame) + 20 - 50;
    self.radiusLabel.textAlignment = NSTextAlignmentCenter;
    
    if (slider.value == slider.minimumValue) {
        frame.origin.x = 20;
        self.radiusLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (slider.value == slider.maximumValue) {
        frame.origin.x = CGRectGetWidth(slider.superview.frame)- 20 - CGRectGetWidth(self.radiusLabel.frame);
        self.radiusLabel.textAlignment = NSTextAlignmentRight;
    }
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
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
        _radiusSlider = [[UISlider alloc]initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.frame) - 40, 20)];
        
        [_radiusSlider setThumbImage:[UIImage imageNamed:@"radiusgauge_bbar_createfence_pointer"] forState:UIControlStateNormal];
        _radiusSlider.minimumTrackTintColor = RGB(90, 179, 59);
        _radiusSlider.maximumTrackTintColor = RGB(182, 182, 182);
        _radiusSlider.minimumValue = 300;
        _radiusSlider.maximumValue = 2000;
        _radiusSlider.value = _radius;
        [_radiusSlider setContinuous:NO];
        [_radiusSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _radiusSlider;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 19, 100, 10)];
        _leftLabel.font = EH_font8;
        _leftLabel.textColor = EH_cor3;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text = @"300m";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100 - 10, CGRectGetHeight(self.frame) - 19, 100, 10)];
        _rightLabel.font = EH_font8;
        _rightLabel.textColor = EH_cor3;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"2000m";
    }
    return _rightLabel;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        
        _radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100 - 20, 9 - 5, 100, 20)];
        _radiusLabel.font = EH_font8;
        _radiusLabel.textColor = EH_cor3;
        _radiusLabel.textAlignment = NSTextAlignmentCenter;
        _radiusLabel.text = [NSString stringWithFormat:@"%ldm",_radius];
        CGRect frame = self.radiusLabel.frame;
        frame.origin.x = (self.radiusSlider.value - self.radiusSlider.minimumValue) / (self.radiusSlider.maximumValue - self.radiusSlider.minimumValue) * CGRectGetWidth(self.radiusSlider.frame) + 20 - 50;
        _radiusLabel.frame = frame;
    }
    return _radiusLabel;
}

@end
