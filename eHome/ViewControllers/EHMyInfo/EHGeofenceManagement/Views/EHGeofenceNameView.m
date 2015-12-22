//
//  EHGeofenceNameView.m
//  eHome
//
//  Created by xtq on 15/9/30.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceNameView.h"
#import "NSString+StringSize.h"

@interface EHGeofenceNameView ()<UITextFieldDelegate>

@end

@implementation EHGeofenceNameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EHBgcor3;
        
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        //self.delegate = self;
        self.font = EHFont2;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入围栏名称" attributes:@{NSForegroundColorAttributeName: EHCor3}];
        [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        NSString *labelText = @"围栏名称：";
        CGFloat leftViewWidth = [labelText sizeWithFontSize:EHSiz2 Width:MAXFLOAT].width;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, leftViewWidth, CGRectGetHeight(frame))];
        label.text = labelText;
        label.font = EHFont2;
        label.textColor = EHCor5;
        
        CALayer *topLineLayer = [CALayer layer];
        topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.5);
        topLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:topLineLayer];
        
        CALayer *bottomLineLayer = [CALayer layer];
        bottomLineLayer.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.5, CGRectGetWidth(frame), 0.5);
        bottomLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:bottomLineLayer];
        
        self.leftView = label;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 12;
    return iconRect;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super clearButtonRectForBounds:bounds];
    iconRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(iconRect) - 12;
    return iconRect;
}


#pragma mark - UITextFieldDelegate
- (void)textFieldValueChanged:(id)sender{
    UITextField *textField = (UITextField *)sender;
    if (textField.markedTextRange == nil && textField.text.length > 10) {
        NSString *substring = [textField.text substringToIndex:10];
        textField.text = substring;
    }
    !self.geofenceNameFieldChangedBlock?:self.geofenceNameFieldChangedBlock();
}

//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    [theTextField resignFirstResponder];
//    return YES;
//}

- (void)textFieldEditingDidEndOnExit:(id)sender{
    UITextField *textField = (UITextField *)sender;
    [textField resignFirstResponder];
}


#pragma mark - Getters And Setters
- (NSString *)geofenceName {
    return self.text;
}

- (void)setGeofenceName:(NSString *)geofenceName {
    self.text = geofenceName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
