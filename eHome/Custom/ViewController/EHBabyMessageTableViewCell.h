//
//  EHBabyMessageTableViewCell.h
//  eHome
//
//  Created by 孟希羲 on 15/9/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "XHMessageTableViewCell.h"

@protocol EHMessageTableViewCellDelegate <XHMessageTableViewCellDelegate>

@optional

- (void)didSelectedReSendBtnOnChatMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath;

@end

@interface EHBabyMessageTableViewCell : XHMessageTableViewCell

@end
