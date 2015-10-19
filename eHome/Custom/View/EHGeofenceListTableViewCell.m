//
//  EHGeofenceListTableViewCell.m
//  eHome
//
//  Created by xtq on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHGeofenceListTableViewCell.h"
#import "NSString+StringSize.h"

@interface EHGeofenceListTableViewCell ()

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *radiusLabel;

@property (nonatomic, strong)UILabel *addressLabel;

@end

@implementation EHGeofenceListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.radiusLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.swit];
    }
    return self;
}

- (void)configWithGeofence:(EHGetGeofenceListRsp *)geofence{
    self.nameLabel.text = geofence.geofence_name;
    self.radiusLabel.text = [NSString stringWithFormat:@"%d米",geofence.geofence_radius];
    self.addressLabel.text = geofence.geofence_address;
    _swit.on = geofence.status_switch;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize radiusLabelSize = [self.radiusLabel.text sizeWithFontSize:EHSiz2 Width:MAXFLOAT];
    self.radiusLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 71.5 - radiusLabelSize.width, 17, radiusLabelSize.width, radiusLabelSize.height);
    
    self.swit.frame = CGRectMake(CGRectGetWidth(self.frame) - 12 - 39, (CGRectGetHeight(self.frame) - 22) / 2.0, 39, 22);
    
    _nameLabel.frame = CGRectMake(12, 14, CGRectGetMinX(self.radiusLabel.frame) - 12, CGRectGetHeight(self.radiusLabel.frame));
    
    _addressLabel.frame = CGRectMake(12, CGRectGetMaxY(self.nameLabel.frame) + 9.5, CGRectGetMinX(self.swit.frame) - 12 - 12, [self.addressLabel.text sizeWithFontSize:EHSiz5 Width:MAXFLOAT].height);
}

#pragma mark - Getters And Setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 10, 200, 20)];
        _nameLabel.font = EHFont2;
        _nameLabel.textColor = EHCor5;
    }
    return _nameLabel;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 10, 200, 20)];
        _radiusLabel.font = EHFont2;
        _radiusLabel.textColor = EHCor5;
    }
    return _radiusLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX, 10, 200, 20)];
        _addressLabel.font = EHFont5;
        _addressLabel.textColor = EHCor4;
    }
    return _addressLabel;
}

- (EHSwitch *)swit{
    if (!_swit) {
        _swit = [[EHSwitch alloc]initWithFrame:CGRectZero];
        WEAKSELF
        _swit.switchChangedBlock = ^(BOOL on){
            !weakSelf.switchChangedBlock?:weakSelf.switchChangedBlock(on);
        };
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
