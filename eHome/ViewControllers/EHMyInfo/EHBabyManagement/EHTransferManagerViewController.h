//
//  EHTransferManagerViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TransferManagerSuccess)(NSString* selectedManger);

@interface EHTransferManagerViewController : KSViewController
@property(nonatomic, copy)TransferManagerSuccess transferManagerSuccess;
@property(nonatomic, strong)NSNumber* babyId;
@property(nonatomic, strong)NSString* babyName;
@property(nonatomic, strong)NSString* currentManager;
@property( nonatomic, strong)NSArray* familyMemberList;
@end
