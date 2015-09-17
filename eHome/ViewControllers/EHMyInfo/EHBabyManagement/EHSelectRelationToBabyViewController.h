//
//  EHSelectRelationToBabyViewController.h
//  eHome
//
//  Created by louzhenhua on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EHSelectRelationProtocol <NSObject>

- (void)selectedRelation:(NSString*)selected;

@end

@interface EHSelectRelationToBabyViewController : KSViewController

@property (nonatomic, weak)id<EHSelectRelationProtocol>selectedRelationdelegate;
@property (nonatomic, strong)NSString* currentRelation;

@end
