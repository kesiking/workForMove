//
//  NewEHModifyRelationViewController.m
//  eHome
//
//  Created by 钱秀娟 on 15/11/16.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "NewEHModifyRelationViewController.h"
#import "EHUpdateBabyUserService.h"


@interface NewEHModifyRelationViewController ()

@property(nonatomic, strong)EHUpdateBabyUserService* updateBabyUserService;

@end

@implementation NewEHModifyRelationViewController


- (void)confirmClicked:(id)sender
{
    
    [self.customRelationTextFiled resignFirstResponder];
    NSString*customRelation;
    if ([EHUtils isEmptyString:self.finalSelectedRelation])
    {
        customRelation = @"家人";
    }
    else
    {
        customRelation = [EHUtils trimmingHeadAndTailSpaceInstring:self.finalSelectedRelation];
    }
    
    if ([customRelation length] > EHOtherNameLength) {
        [WeAppToast toast:(@"宝贝关系超过最大长度10!")];
        return;
    }
    
    if (![EHUtils isValidString:customRelation]) {
        [WeAppToast toast:(@"宝贝关系不支持特殊字符!")];
        return;
    }
    
    if (![EHUtils isEmptyString:customRelation]) {
        self.selectedRelation = customRelation;
    }
    
    
    
    WEAKSELF
    
    self.updateBabyUserService = [EHUpdateBabyUserService new];
    
    self.updateBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        //delegate传值
        if ([strongSelf.selectedRelationdelegate respondsToSelector:@selector(selectedRelation:)])
        {
            //传递偏移量
//            CGFloat offset = strongSelf.relationScrollView.contentOffset.x;
            
            
            [strongSelf.selectedRelationdelegate selectedRelation:strongSelf.selectedRelation];
        }
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    // service 返回失败 block
    self.updateBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHBabyUser* babyUser = [EHBabyUser new];
    babyUser.baby_id = self.babyId;
    babyUser.user_id = [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]];
    babyUser.relationship = self.selectedRelation;
    babyUser.authority = self.authority;
    [self.updateBabyUserService updateBabyUser:babyUser];
    
    
}


@end











