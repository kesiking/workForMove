//
//  EHRightImageTableViewCell.h
//  eHome
//
//  Created by louzhenhua on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RightImageViewClickBlock)(UIImageView* imageView);

static NSString *kEHRightImageTableViewCellID = @"kEHRightImageTableViewCellID";

@interface EHRightImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (copy, nonatomic) RightImageViewClickBlock rightImageViewClickBlock;

@end
