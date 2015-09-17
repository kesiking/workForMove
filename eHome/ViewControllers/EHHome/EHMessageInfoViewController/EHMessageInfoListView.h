//
//  EHMessageInfoListView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"

@interface EHMessageInfoListView : KSView{
    KSTableViewController*          _tableViewCtl;
}

@property (nonatomic,assign) NSInteger message_type;
@property (nonatomic,strong) KSTableViewController* tableViewCtl;

//-(void)refreshDataRequestWithBabyId:(NSString*)babyId;
-(void)refreshDataRequestWithBabyId:(NSString*)babyId andMsgType:(NSInteger)type;
@end
