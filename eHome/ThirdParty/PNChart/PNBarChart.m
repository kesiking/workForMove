//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "UIMacro.h"



@interface PNBarChart () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_yChartLabels;
}

//@property(strong,nonatomic)UILabel * yVlabel;

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation PNBarChart

double labelChangeheight = 0;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _barBackgroundColor  = PNLightGrey;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _xChartLabels        = [NSMutableArray array];
    _yChartLabels        = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _xLabelSkip          = 1;
    _yLabelSum           = 4;
    _labelMarginTop      = 0;
    _chartMargin         = 0;   //改为0上方就没有啦
    _barRadius           = 2.0;
    _showChartBorder     = NO;
    _yChartLabelWidth    = 18;
    _rotateForXAxisText  = false;
}

- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    //make the _yLabelSum value dependant of the distinct values of yValues to avoid duplicates on yAxis
    int yLabelsDifTotal = [NSSet setWithArray:yValues].count;
    _yLabelSum = yLabelsDifTotal % 2 == 0 ? yLabelsDifTotal : yLabelsDifTotal + 1;
    
    if (_yMaxValue) {
        _yValueMax = _yMaxValue;
    } else {
        [self getYValueMax:yValues];
    }
    
    if (_yChartLabels) {
        [self viewCleanupForCollection:_yChartLabels];
    }else{
        _yLabels = [NSMutableArray new];
    }
    
//    if (_showLabel) {
//        //Add y labels
//        
//        float yLabelSectionHeight = (self.frame.size.height - _chartMargin * 2 - kXLabelHeight) / _yLabelSum;
//        
//        
//        
//        
//        for (int index = 0; index < _yLabelSum; index++) {
//            
//            NSString *labelText = _yLabelFormatter((float)_yValueMax * ( (_yLabelSum - index) / (float)_yLabelSum ));
//            
//            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0,
//                                                                                  yLabelSectionHeight * index + _chartMargin - kYLabelHeight/2.0,
//                                                                                  _yChartLabelWidth,
//                                                                                  kYLabelHeight)];
//            label.font = _labelFont;
//            label.textColor = _labelTextColor;
//            [label setTextAlignment:NSTextAlignmentRight];
//            label.text = labelText;
//            
//            [_yChartLabels addObject:label];
//            //[self addSubview:label];
//            
//        }
//    }
}

-(void)updateChartData:(NSArray *)data{
    self.yValues = data;
    [self updateBar];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    int max = [[yLabels valueForKeyPath:@"@max.intValue"] intValue];
    
    //更改最大值，按要求往上取整
    int maxValue = max;
    //截断最大值，如果<500,取到500，如果<1000,取到1000(0的话怎么办??)
    if (maxValue <= 500) {
        maxValue = 500;
    }else if (maxValue <= 1000){
        maxValue = 1000;
    }else{
        int trail = maxValue%1000;
        if (trail < 500) {
            maxValue = (maxValue/1000) *1000 +500;
        }else{
            maxValue = (maxValue/1000) *1000 +1000;
        }
    }
    
    _yValueMax = maxValue;

    
    // 原本的代码有问题，改了一下
    //ensure max is even
    //    _yValueMax = max % 2 == 0 ? max : max + 1;
    
//    _yValueMax = max;
    
    if (_yValueMax == 0) {
        _yValueMax = _yMinValue;
    }
}



- (void)setXLabels:(NSArray *)xLabels andMargin:(double)barMargin andWidth:(double)barWidth
{
//    double barWidth = 20*SCREEN_SCALE;
//    double barMargin = ((SCREEN_WIDTH-44.5*SCREEN_SCALE)-10*SCREEN_SCALE-[xLabels count]*(20*SCREEN_SCALE))/(([xLabels count]-1)*1.0);
//    
    _xLabels = xLabels;
    
    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [xLabels count];
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = [_xLabels[index] description];
                
                
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
                label.textColor = EH_cor5;
                
                label.font = [UIFont systemFontOfSize:EH_siz7];
                
                
                
//                label.backgroundColor = [UIColor yellowColor];
                
                
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                //自适应
                [label sizeToFit];
                labelChangeheight = label.frame.size.height;
//                NSLog(@"kuandu------------%f",labelChangeheight);
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /1.5);
                }
                else{
                    
                    
                    labelXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth)+barWidth/2.0;
                }
                //                label.center = CGPointMake(labelXPosition,
                //                                           self.frame.size.height - kXLabelHeight - _chartMargin + label.frame.size.height /2.0 + _labelMarginTop);
                //设置x轴的坐标
                label.center = CGPointMake(labelXPosition,
                                           108*SCREEN_SCALE + label.frame.size.height /2.0 + _labelMarginTop+10*SCREEN_SCALE);
                
//                NSLog(@"\n\nlabel.frame.size.heightlabel.frame.size.height\n\n\n%f",label.frame.size.height);
                labelAddCount = 0;
                
                [_xChartLabels addObject:label];
                [self addSubview:label];
                
                
            }
        }
    }
    
    
}


- (void)setDayXLabels:(NSArray *)xLabels andMargin:(double)barMargin andWidth:(double)barWidth
{
    
    _xLabels = xLabels;
    
    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [xLabels count];
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = [_xLabels[index] description];
                
                
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
                label.textColor = EH_cor5;
                
                label.font = [UIFont systemFontOfSize:EH_siz7];
                
                
                
                //                label.backgroundColor = [UIColor yellowColor];
                
                
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                //自适应
                [label sizeToFit];
                labelChangeheight = label.frame.size.height;
                //                NSLog(@"kuandu------------%f",labelChangeheight);
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /1.5);
                }
                else{
                    
                    
                    labelXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth)+barWidth/2.0;
                }
                //                label.center = CGPointMake(labelXPosition,
                //                                           self.frame.size.height - kXLabelHeight - _chartMargin + label.frame.size.height /2.0 + _labelMarginTop);
                if (index == 0 || index == (_xLabels.count-1)) {
                    label.center = CGPointMake(labelXPosition,
                                               108*SCREEN_SCALE + label.frame.size.height /2.0 + _labelMarginTop+10*SCREEN_SCALE);

                }else{
                    label.frame = CGRectMake(labelXPosition - barWidth/2.0, 108*SCREEN_SCALE + label.frame.size.height /2.0 + _labelMarginTop+10*SCREEN_SCALE - label.frame.size.height/2.0, label.frame.size.width, label.frame.size.height);
                }
                
               
                labelAddCount = 0;
                
                [_xChartLabels addObject:label];
                [self addSubview:label];
                
                
            }
        }
    }
    
    
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

//- (void)updateBar
//{
//
//    //Add bars
////    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 2 - kXLabelHeight;
//    CGFloat chartCavanHeight = 171;  //柱状图的高度171
//    NSInteger index = 0;
//
//    for (NSNumber *valueString in _yValues) {
//
//        PNBar *bar;
//
//        if (_bars.count == _yValues.count) {
//            bar = [_bars objectAtIndex:index];
//        }else{
//            CGFloat barWidth;
//            CGFloat barXPosition;
//
//            if (_barWidth) {
//                barWidth = _barWidth;
//                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
//            }else{
//                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
//                if (_showLabel) {
//                    barWidth = _xLabelWidth * 0.5;
//
//                }
//                else {
//                    barWidth = _xLabelWidth * 0.6;
//
//                }
//            }
////
////            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
////                                                          self.frame.size.height - chartCavanHeight - kXLabelHeight - _chartMargin, //Bar Y position
////                                                          barWidth, // Bar witdh
////                                                          chartCavanHeight)]; //Bar height
////
//
//            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition,                                                                       0,barWidth, chartCavanHeight)]; //Bar height
//
//
//
//            //Change Bar Radius
//            bar.barRadius = _barRadius;
//
//            //Change Bar Background color
//            bar.backgroundColor = _barBackgroundColor;
//
//            //Bar StrokColor First
//            if (self.strokeColor) {
//                bar.barColor = self.strokeColor;
//            }else{
//                bar.barColor = [self barColorAtIndex:index];
//            }
//            // Add gradient
//            bar.barColorGradientStart = _barColorGradientStart;
//
//            //For Click Index
//            bar.tag = index;
//
//            [_bars addObject:bar];
//            [self addSubview:bar];
//        }
//
//        //Height Of Bar
//        float value = [valueString floatValue];
//
//        float grade = (float)value / (float)_yValueMax;
//
//        if (isnan(grade)) {
//            grade = 0;
//        }
//        bar.grade = grade;
//
////        //新加的
////        int aa = [valueString intValue];
////        NSLog(@"value------%d,---max%d",aa,_yValueMax);
////        if (aa == _yValueMax) {
////            if (!self.yVlabel) {
////                //－－－－－－－新加的
////                self.yVlabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
////                self.yVlabel.font = _labelFont;
////                self.yVlabel.textColor = _labelTextColor;
////                [self.yVlabel setTextAlignment:NSTextAlignmentCenter];
////                [self addSubview:self.yVlabel];
////                NSLog(@"addLabel");
////            }
////
////            self.yVlabel.text = [NSString stringWithFormat:@"%d",aa];
////            CGFloat labelXPosition;
////            labelXPosition = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 );
////            self.yVlabel.center = CGPointMake(labelXPosition,kXLabelHeight/2.0);
////            //            NSLog(@"value------%d,---max%d",aa,_yValueMax);
//
////        }else{
////
////        }
//
//        index += 1;
//    }
//}



- (void)updateBar
{
    
    //Add bars
    //    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 2 - kXLabelHeight;
    CGFloat chartCavanHeight = 108*SCREEN_SCALE;  //柱状图的高度171
    NSInteger index = 0;
    
    for (NSNumber *valueString in _yValues) {
        
        PNBar *bar;
        
        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barMargin;
            CGFloat barXPosition;
            
            if (_barWidth) {
                barWidth = _barWidth;
                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
            }else{
                
                barWidth = ((SCREEN_WIDTH-50-75*SCREEN_SCALE) -16*SCREEN_SCALE-(_yValues.count-1)*15*SCREEN_SCALE)/((_yValues.count)*1.0);
                barMargin = 15*SCREEN_SCALE;
                barXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth);
                
                //周视图，间距固定
//                barWidth = 20*SCREEN_SCALE;
//            
//                barMargin = ((SCREEN_WIDTH-50-75*SCREEN_SCALE) -15*SCREEN_SCALE-_yValues.count*20*SCREEN_SCALE)/((_yValues.count-1)*1.0);
//                barXPosition = 7.5*SCREEN_SCALE+index*(barMargin+barWidth);
                
                
                
                
                
                
                
            }
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition,                                                                       0,barWidth, chartCavanHeight)]; //Bar height
            
            
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Change Bar Background color
            //            bar.backgroundColor = _barBackgroundColor;
            bar.backgroundColor = [UIColor clearColor];
            
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            // Add gradient
            bar.barColorGradientStart = _barColorGradientStart;
            
            //For Click Index
            bar.tag = index;
            
            [_bars addObject:bar];
            [self addSubview:bar];
        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.grade = grade;
        index += 1;
    }
}

- (void)updateBarWeekWithMargin:(double)abarMargin andWidth:(double)abarWidth
{
    
    //Add bars
    //    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 2 - kXLabelHeight;
    CGFloat chartCavanHeight = 108*SCREEN_SCALE;  //柱状图的高度171
    NSInteger index = 0;
    
    for (NSNumber *valueString in _yValues) {
        
        PNBar *bar;
        
        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barMargin;
            CGFloat barXPosition;
            
            if (_barWidth) {
                barWidth = _barWidth;
                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
            }else{
                
                barWidth = abarWidth;
                barMargin = abarMargin;
                barXPosition = 5*SCREEN_SCALE+index*(barMargin+barWidth);
            }
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, 0,barWidth, chartCavanHeight)]; //Bar height
            
            
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Change Bar Background color
            //            bar.backgroundColor = _barBackgroundColor;
            bar.backgroundColor = [UIColor clearColor];
            
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            // Add gradient
            bar.barColorGradientStart = _barColorGradientStart;
            
            //For Click Index
            bar.tag = index;
            
            [_bars addObject:bar];
            [self addSubview:bar];
        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.grade = grade;
        index += 1;
    }
}







- (void)strokeChart
{
    //Add Labels
    
    [self viewCleanupForCollection:_bars];
    
    
    //Update Bar
    
    [self updateBar];
    
    //Add chart border lines
    
    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        //        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        
        
        _chartBottomLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartBottomLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartBottomLine];
        
        //Add left Chart Line
        
        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];
        
        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];
        
        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        
        
        _chartLeftLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
        
        _chartLeftLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLeftLine];
    }
}

- (void)strokeChartWeekWithMargin:(double)abarMargin andWidth:(double)abarWidth
{
    //Add Labels
    
    [self viewCleanupForCollection:_bars];
    
    
    //Update Bar
    
    [self updateBarWeekWithMargin:(double)abarMargin andWidth:(double)abarWidth];
    
    //Add chart border lines
    
    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        //        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        
        
        _chartBottomLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartBottomLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartBottomLine];
        
        //Add left Chart Line
        
        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];
        
        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - kXLabelHeight - _chartMargin)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];
        
        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        
        
        _chartLeftLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
        
        _chartLeftLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLeftLine];
    }
}

- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}


#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
    }
}


@end
