//
//  EHBabyLocationAnnotationView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyLocationAnnotationView.h"
#import "UIImage+ImageProcess.h"

@interface EHBabyLocationAnnotationView()

@property (nonatomic,assign) CGRect         calloutViewRect;

@property (nonatomic,strong) UIImage       *annotationCommontImage;

@property (nonatomic,strong) UIImage       *annotationSpeacilImage;

@end

@implementation EHBabyLocationAnnotationView

#pragma mark - Override

-(EHBabyLocationCalloutView *)calloutView{
    if (_calloutView == nil)
    {
        _calloutViewRect = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        _calloutView = [[EHBabyLocationCalloutView alloc] initWithFrame:self.calloutViewRect];
        _calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        _calloutView.backgroundColor = [UIColor clearColor];
    }
    return _calloutView;
}

-(void)setPosition:(EHUserDevicePosition *)position{
    _position = position;
    self.calloutView.position = position;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        if (!CGRectEqualToRect(self.calloutViewRect, self.calloutView.bounds)) {
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            self.calloutViewRect = self.calloutView.bounds;
        }
        self.selectImageView.hidden = NO;
        self.image = self.annotationSpeacilImage;
        if ([self needChangeAnnotationImageViewAnimation]) {
            _annotationImageView.alpha = 1;
            [self changeAnnotationImageViewAnimationWithSelected:selected completion:^(BOOL finished) {
                [self addSubview:self.calloutView];
                _annotationImageView.alpha = 0;
                [_selectImageView setFrame:CGRectMake((self.width - 20)/2, (self.height - 20)/2, 20, 20)];
            }];
        }else{
            _annotationImageView.alpha = 0;
            [self addSubview:self.calloutView];
        }
        [self bringSubviewToFront:self.selectImageView];
    }
    else
    {
        [self bringSubviewToFront:self.selectImageView];
        _annotationImageView.alpha = 1;
        if ([self needChangeAnnotationImageViewAnimation]) {
            [self changeAnnotationImageViewAnimationWithSelected:selected completion:^(BOOL finished) {
                self.selectImageView.hidden = YES;
                self.image = self.annotationCommontImage;
                [self.calloutView removeFromSuperview];
                _annotationImageView.alpha = 1;
            }];
        }else{
            self.selectImageView.hidden = YES;
            self.image = self.annotationCommontImage;
        }
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

-(BOOL)needChangeAnnotationImageViewAnimation{
    if (_position && [_position.locationType isEqualToString:current_LocationType]) {
        return YES;
    }
    return NO;
}

-(BOOL)isSOSAnnotationImageViewAnimation{
    if (_position && [_position.locationType isEqualToString:SOS_LocationType]) {
        return YES;
    }
    return NO;
}

-(void)changeAnnotationImageViewAnimationWithSelected:(BOOL)selected completion:(void (^)(BOOL finished))completion{
    if (selected) {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            CGRect rect = CGRectMake(self.calloutView.babyHeadImageView.frame.origin.x + self.calloutView.frame.origin.x, self.calloutView.babyHeadImageView.frame.origin.y + self.calloutView.frame.origin.y, self.calloutView.babyHeadImageView.width, self.calloutView.babyHeadImageView.height);
            [_annotationImageView setFrame:rect];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }else{
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            CGRect rect = CGRectMake((self.width - MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH)/2, (self.height - MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)/2, MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT);
            [_annotationImageView setFrame:rect];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
}

-(UIImageView *)selectImageView{
    if (_selectImageView == nil) {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 20)/2, (self.height - 20)/2, 20, 20)];
        _selectImageView.hidden = YES;
        [self addSubview:_selectImageView];
    }
    return _selectImageView;
}

-(UIImageView *)annotationImageView{
    if (_annotationImageView == nil) {
        _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH)/2, (self.height - MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)/2, MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)];
        _annotationImageView.userInteractionEnabled = NO;
        [self addSubview:_annotationImageView];
    }
    return _annotationImageView;
}

-(void)setAnnotationImage:(UIImage *)annotationImage{
    self.annotationCommontImage = annotationImage;
    self.annotationSpeacilImage = [annotationImage createImageWithColor:[UIColor clearColor]];
    [self setImage:annotationImage];
}

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    if ([self isSOSAnnotationImageViewAnimation]) {
        [_annotationImageView setFrame:CGRectMake((self.width - MAP_SOS_ANNOTATION_IMAGE_VIEW_WIDTH)/2, (self.height - MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)/2, MAP_SOS_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)];
        _annotationImageView.center = CGPointMake(_annotationImageView.center.x, _annotationImageView.center.y - _annotationImageView.height / 2 - self.height / 2);
    }else{
        [_annotationImageView setFrame:CGRectMake((self.width - MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH)/2, (self.height - MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)/2, MAP_HEADER_ANNOTATION_IMAGE_VIEW_WIDTH, MAP_HEADER_ANNOTATION_IMAGE_VIEW_HEIGHT)];
    }
}

// 重新此函数，用以实现点击calloutView判断为点击该annotationView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    if (!inside){
        inside = [self.annotationImageView pointInside:[self convertPoint:point toView:self.annotationImageView] withEvent:event];
    }
    
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
@end
