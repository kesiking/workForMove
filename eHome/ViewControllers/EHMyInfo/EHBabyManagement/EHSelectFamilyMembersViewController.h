//
//  EHSelectFamilyMembersViewController.h
//  eHome
//
//  Created by jss on 15/11/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelecteFamilyMemberBlock)();

@interface EHSelectFamilyMembersViewController : KSViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSNumber*babyId;
//@property (nonatomic,strong) NSString*phone_type;
@property (nonatomic,copy) SelecteFamilyMemberBlock selectFamilyMemberBlock;
@end
