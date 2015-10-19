//
//  EHAlarmCommentTableViewCell.h
//  eHome
//
//  Created by jinmiao on 15/9/28.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommentAddBlock)(NSString *);

@interface EHAlarmCommentTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString *comment;

@property (copy,nonatomic) CommentAddBlock commentAddBlock;

@end
