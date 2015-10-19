//
//  EHGeofenceAddressView.m
//  eHome
//
//  Created by xtq on 15/9/30.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceAddressView.h"
#import "NSString+StringSize.h"

@interface EHGeofenceAddressView ()

@property (nonatomic, strong)UIImageView *iconImv;

@property (nonatomic, strong)UILabel *addressLabel;

@property (nonatomic, strong)UIButton *searchBtn;

@end

@implementation EHGeofenceAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EHBgcor3;
        [self addSubview:self.iconImv];
        [self addSubview:self.addressLabel];
        [self addSubview:self.searchBtn];
        
        CALayer *topLineLayer = [CALayer layer];
        topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.5);
        topLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:topLineLayer];
        
        CALayer *bottomLineLayer = [CALayer layer];
        bottomLineLayer.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.5, CGRectGetWidth(frame), 0.5);
        bottomLineLayer.backgroundColor = EHLinecor1.CGColor;
        [self.layer addSublayer:bottomLineLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImv.frame = CGRectMake(16, 10.5, 17, 22);
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImv.frame) + 10, 0, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.iconImv.frame) + 10 + 10 + 17 + 12), CGRectGetHeight(self.frame));
    self.searchBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 12 - 15, 10.5, 17, 22);
}

#pragma mark - Events Response
- (void)searchBtnClick:(id)sender {
    !self.searchBtnClickBlock?:self.searchBtnClickBlock();
}

#pragma mark - Getters And Setters
- (NSString *)address {
    return self.addressLabel.text;
}

- (void)setAddress:(NSString *)address {
    self.addressLabel.text = address;
}

- (UIImageView *)iconImv {
    if (!_iconImv) {
        _iconImv = [[UIImageView alloc]init];
        _iconImv.image = [UIImage imageNamed:@"icon_location"];
    }
    return _iconImv;
}

-(UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = EHFont2;
        _addressLabel.textColor = EHCor5;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]init];
        [_searchBtn setImage:[UIImage imageNamed:@"ico_createfence_search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

@end
