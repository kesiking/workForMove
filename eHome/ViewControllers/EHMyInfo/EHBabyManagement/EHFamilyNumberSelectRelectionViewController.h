//
//  EHFamilyNumberSelectRelectionViewController.h
//  eHome
//
//  Created by jss on 15/11/20.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMModifyRelationCommonViewController.h"

typedef void(^SelectRelationBlock)(NSString *relationship);


@interface EHFamilyNumberSelectRelectionViewController : EMModifyRelationCommonViewController
@property (nonatomic,copy) SelectRelationBlock selectRelationBlock;

@end
