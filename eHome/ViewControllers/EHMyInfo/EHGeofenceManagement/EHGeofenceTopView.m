//
//  EHGeofenceTopView.m
//  eHome
//
//  Created by xtq on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceTopView.h"
#import "NSString+StringSize.h"

@interface EHGeofenceTopView ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *geofenceNameField;    //围栏名称视图

@property (nonatomic, strong)UILabel *addressLabel;             //围栏地址视图

@end

@implementation EHGeofenceTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - Events Response
- (void)searchBtnClick:(id)sender{
    !self.searchBtnClickBlock?:self.searchBtnClickBlock();
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark - Getters And Setters
- (void)configUI {
    CGFloat topViewWidth = CGRectGetWidth(self.frame);
    CGFloat topViewHeight = CGRectGetHeight(self.frame);

    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    CGFloat labelHeight = [@"text" sizeWithFontSize:EH_siz5 Width:MAXFLOAT].height;
    CGFloat upLabelY = ((topViewHeight / 2.0) - labelHeight) / 2.0;
    CGFloat bottomLabelY = ((topViewHeight / 2.0) - labelHeight) / 2.0 + (topViewHeight / 2.0);
    
    UILabel *geofenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, upLabelY, 75, labelHeight)];
    geofenceLabel.font = EH_font5;
    geofenceLabel.textColor = EH_cor3;
    geofenceLabel.textAlignment = NSTextAlignmentLeft;
    geofenceLabel.text = @"围栏名称：";
    
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, bottomLabelY, 75, labelHeight)];
    centerLabel.font = EH_font5;
    centerLabel.textColor = EH_cor3;
    centerLabel.textAlignment = NSTextAlignmentLeft;
    centerLabel.text = @"中心点：";
    
    CGFloat geofenceNameFieldWidth = topViewWidth - 95 - 20;
    self.geofenceNameField.frame = CGRectMake(95, upLabelY, geofenceNameFieldWidth, labelHeight);
    self.addressLabel.frame = CGRectMake(95, bottomLabelY, geofenceNameFieldWidth, labelHeight);
    
    CGFloat searchBtnY = ((topViewHeight / 2.0) - 20) / 2.0 + (topViewHeight / 2.0);
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(topViewWidth - 20 - 20, searchBtnY, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"ico_createfence_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBezierPath *bp = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectGetHeight(self.frame) / 2.0 - 0.5, topViewWidth, 0.5)];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = bp.CGPath;
    line.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2.0 - 0.5, topViewWidth, 0.5);
    line.strokeColor = [UIColor clearColor].CGColor;
    line.fillColor = EH_linecor1.CGColor;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) / 2.0 - 0.5, topViewWidth, 0.5)];
    lineView.backgroundColor = EH_linecor1;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, topViewWidth, 0.5)];
    lineView2.backgroundColor = EH_linecor1;
    
    [self addSubview:geofenceLabel];
    [self addSubview:centerLabel];
    [self addSubview:self.geofenceNameField];
    [self addSubview:self.addressLabel];
    [self addSubview:searchBtn];
    [self addSubview:lineView];
    [self addSubview:lineView2];
}

/**
 *  围栏名称视图
 */
- (UITextField *)geofenceNameField{
    if (!_geofenceNameField) {
        _geofenceNameField = [[UITextField alloc]initWithFrame:CGRectZero];
        _geofenceNameField.returnKeyType = UIReturnKeyDone;
        _geofenceNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _geofenceNameField.delegate = self;
        _geofenceNameField.font = EH_font5;
        _geofenceNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入围栏名称" attributes:@{NSForegroundColorAttributeName: EH_cor6}];
        [_geofenceNameField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _geofenceNameField;
}

/**
 *  围栏地址视图
 */
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressLabel.font = EH_font5;
        _addressLabel.textColor = EH_cor4;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (NSString *)geofenceName {
    return self.geofenceNameField.text;
}

- (void)setGeofenceName:(NSString *)geofenceName {
    self.geofenceNameField.text = geofenceName;
}

- (NSString *)address {
    return self.addressLabel.text;
}

- (void)setAddress:(NSString *)address {
    self.addressLabel.text = address;
}

@end
