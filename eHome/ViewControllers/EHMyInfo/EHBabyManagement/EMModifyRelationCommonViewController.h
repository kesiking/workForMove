//
//  EMModifyRelationCommonViewController.h
//  eHome
//
//  Created by 钱秀娟 on 15/11/17.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "KSViewController.h"
#import "KSInsetsTextField.h"
@protocol EHSelectRelationProtocol <NSObject>

- (void)selectedRelation:(NSString*)selected;

@end

@interface EMModifyRelationCommonViewController : KSViewController
@property (nonatomic, strong)NSString* currentRelationShip;
@property (nonatomic, strong)KSInsetsTextField *customRelationTextFiled;
@property (nonatomic, strong)NSString *finalSelectedRelation;
@property(nonatomic, strong)NSString* selectedRelation;

@property(nonatomic, strong)UIScrollView *relationScrollView;

@property (nonatomic, weak)id<EHSelectRelationProtocol>selectedRelationdelegate;


@end
