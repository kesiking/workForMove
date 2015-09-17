//
//  EHGeofenceListTableViewCell.m
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceListTableViewCell.h"

@implementation EHGeofenceListTableViewCell
{
    UILabel *_nameLabel;
    UILabel *_addressLabel;
    CAShapeLayer *_lineLayer;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 10, 200, 20)];
        _nameLabel.font = EH_font3;
        _nameLabel.textColor = EH_cor3;
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 10 + 20 + 15, 200, 15)];
        _addressLabel.font = EH_font6;
        _addressLabel.textColor = EH_cor4;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.path = path.CGPath;
        _lineLayer.strokeColor = [UIColor clearColor].CGColor;
        _lineLayer.fillColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:_lineLayer];
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_addressLabel];
        [self.contentView addSubview:self.swit];
//        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)configWithGeofence:(EHGetGeofenceListRsp *)geofence{
    _nameLabel.text = geofence.geofence_name;
    _addressLabel.text = geofence.geofence_address;
    _swit.on = geofence.status_switch;
    if (_swit.on == YES) {
        _swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
    }
    else {
        _swit.knobColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:180/255.0 alpha:1];
    }
}

- (void)switchChanged:(id)sender{
    SevenSwitch *swit = (SevenSwitch *)sender;
    
    if (swit.on == YES) {
        swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
    }
    else {
        swit.knobColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:180/255.0 alpha:1];
    }
    !self.switchStatusChangeBlock?:self.switchStatusChangeBlock(swit.on);
}

- (void)layoutSubviews{
    _nameLabel.frame = CGRectMake(kSpaceX, 10, 200, 20);
    _addressLabel.frame = CGRectMake(kSpaceX, 10 + 20 + 15, 200, 15);
    _swit.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - 50, 22.5, 50, 25);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(kSpaceX, CGRectGetHeight(self.frame) - 0.2, CGRectGetWidth(self.frame) - kSpaceX, 0.2)];
    _lineLayer.path = path.CGPath;
}

- (SevenSwitch *)swit{
    if (!_swit) {
        _swit = [[SevenSwitch alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20 - 50, 25, 50, 20)];
        _swit.onColor = [UIColor colorWithRed:168/255.0 green:216/255.0 blue:152/255.0 alpha:1];
        _swit.knobColor = [UIColor colorWithRed:92/255.0 green:176/255.0 blue:65/255.0 alpha:1];
        _swit.inactiveColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:217/255.0 alpha:1];
        
        [_swit addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
