//
//  EHMapHistoryTraceListView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"

typedef void(^historyTraceListDidSelectedBlock) (NSArray* dataList, NSUInteger index);

@interface EHMapHistoryTraceListView : KSView{
    KSTableViewController*          _tableViewCtl;
}

@property (nonatomic,strong) KSTableViewController* tableViewCtl;

@property (nonatomic, strong) NSArray*              positionArray;

@property (nonatomic,strong) NSDate*                selectDate;

@property (nonatomic,assign) BOOL                   tableViewShouldClicked;

@property (nonatomic,copy)   historyTraceListDidSelectedBlock historyTraceListDidSelectedBlock;

-(void)refreshDataRequestWithData:(NSDate*)date;

-(void)setupPositionArray:(NSArray*)positionArray;

@end
