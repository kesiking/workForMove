//
//  EHExemptionDescriptionViewController.m
//  eHome
//
//  Created by xtq on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHExemptionDescriptionViewController.h"

@implementation EHExemptionDescriptionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"免责说明";
    //self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    
    [self.view addSubview:[self agreementWebview]];
}

//- (UILabel *)label{
//    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceX * 2, 60, CGRectGetWidth(self.view.frame) - kSpaceX * 4, 60)];
//    descriptionLabel.text = @"中移（杭州）信息技术有限公司是贯众爱家产品的服务提供商";
//    descriptionLabel.textColor = [UIColor blackColor];
//    descriptionLabel.font = [UIFont systemFontOfSize:18];
//    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    descriptionLabel.numberOfLines = 0;
//    descriptionLabel.textAlignment = NSTextAlignmentCenter;
//    return descriptionLabel;
//}

- (UIWebView*)agreementWebview
{
    UIWebView* webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];

    
    return webview;
}

@end
