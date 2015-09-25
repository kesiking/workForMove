//
//  EHAboutViewController.m
//  eHome
//
//  Created by xtq on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHAboutViewController.h"
#import "EHExemptionDescriptionViewController.h"
#import "UMSocial.h"
#import "EHSocializedSharedMacro.h"
#import "EHFeedbackViewController.h"

#define kHeaderViewHeight   340
#define kCellHeight         50

@interface EHAboutViewController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EHAboutViewController
{
    GroupedTableView *_tableView;
    UIView *_headView;
}

#pragma mark - Life Circle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"关于";
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self.view addSubview:[self headView]];
    [self initTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    NSArray *titleArray = @[@"免责说明",@"意见反馈"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EHExemptionDescriptionViewController *edVC = [[EHExemptionDescriptionViewController alloc]init];
        [self.navigationController pushViewController:edVC animated:YES];
    }
    else {
        EHFeedbackViewController *fvc = [[EHFeedbackViewController alloc]init];
        [self.navigationController pushViewController:fvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - Getters And Setters


- (void)initTableView{
    if (!_tableView) {
        _tableView = [[GroupedTableView alloc]initWithFrame:CGRectMake(10, kHeaderViewHeight, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame) - kHeaderViewHeight) style:UITableViewStylePlain];
        EHLogInfo(@"table height = %f",_tableView.frame.size.height);
        _tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        CGFloat height = CGRectGetHeight(_tableView.frame) / 2.0 < kCellHeight?CGRectGetHeight(_tableView.frame) / 2.0:kCellHeight;
        _tableView.rowHeight = height;
        _tableView.sectionHeaderHeight = 100;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [self.view addSubview:_tableView];
    }
    return;
}

- (UIView *)headView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderViewHeight)];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_about"]];
    logoImageView.frame = CGRectMake(CGRectGetWidth(_headView.frame) / 2.0 - 120 /2.0, 50, 120, 120);
    
    UILabel *descriptionLogoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 15, CGRectGetWidth(_headView.frame), 20)];
    descriptionLogoLabel.text = @"贯众·爱家";
    descriptionLogoLabel.font = EH_font1;
    descriptionLogoLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptionLogoLabel.frame) + 5, CGRectGetWidth(_headView.frame), 15)];
    versionLabel.textColor = EH_cor5;
    versionLabel.font = EH_font6;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [versionLabel sizeToFit];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // build
    NSString *build_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"v%@ (Build%@)",app_Version, build_Version];
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(CGRectGetWidth(_headView.frame) / 2.0, CGRectGetMaxY(descriptionLogoLabel.frame) + 5 + CGRectGetHeight(versionLabel.frame) / 2.0);
    
    UILabel *descriptionCmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX * 3, CGRectGetMaxY(versionLabel.frame) + 15, CGRectGetWidth(_headView.frame) - kSpaceX * 6, 40)];
    descriptionCmpLabel.text = @"中移（杭州）信息技术有限公司";
    descriptionCmpLabel.textColor = EH_cor5;
    descriptionCmpLabel.font = EH_font5;
    descriptionCmpLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionCmpLabel.numberOfLines = 0;
    descriptionCmpLabel.textAlignment = NSTextAlignmentCenter;
    [descriptionCmpLabel sizeToFit];
    descriptionCmpLabel.center = CGPointMake(CGRectGetWidth(_headView.frame) / 2.0, CGRectGetMaxY(versionLabel.frame) + 15 + CGRectGetHeight(descriptionCmpLabel.frame) / 2.0);

    [_headView addSubview:logoImageView];
    [_headView addSubview:descriptionLogoLabel];
    [_headView addSubview:versionLabel];
    [_headView addSubview:descriptionCmpLabel];
    return _headView;
}

@end
