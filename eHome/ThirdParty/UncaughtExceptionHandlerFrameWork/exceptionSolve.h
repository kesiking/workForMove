//
//  exceptionSolve.h
//  UncaughtExceptionHandlerFrameWork
//
//  Created by 慧博创测-刘晓威 on 15/3/31.
//  Copyright (c) 2015年 刘晓威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface exceptionSolve : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableDictionary *dic;
    NSMutableData *resultData;
}

@property(nonatomic,retain)NSString *log_type_id;     //日志类型，Crash为1
@property(nonatomic,retain)NSString *log_time;        //日志时间
@property(nonatomic,retain)NSArray  *log_summary;     //日志摘要
@property(nonatomic,retain)NSString *log_content;     //日志内容
@property(nonatomic,retain)NSString *log_flagline;    //日志标志行
@property(nonatomic,retain)NSString *dev_name;        //设备名称
@property(nonatomic,retain)NSString *osversion;       //OS SDK版本
@property(nonatomic,retain)NSString *sim_id;          //运营商编号
@property(nonatomic,retain)NSString *net_id;          //网络类型编号
@property(nonatomic,retain)NSString *sd_total_size;   //SD总大小
@property(nonatomic,retain)NSString *sd_rest_size;
@property(nonatomic,retain)NSString *bat_num;         //电池电量
@property(nonatomic,retain)NSString *bat_status;      //电池状态
@property(nonatomic,retain)NSString *bat_usage;       //电池使用情况
@property(nonatomic,retain)NSString *dev_root;        //终端是否ROOT
@property(nonatomic,retain)NSString *dev_longitude;   //位置信息－经度
@property(nonatomic,retain)NSString *dev_latitude;    //位置信息－纬度
@property(nonatomic,retain)NSString *app_key;         //APP标识
@property(nonatomic,retain)NSString *app_version;     //APP版本
@property(nonatomic,retain)NSString *app_pkg;         //APP包名
@property(nonatomic,retain)NSString *app_chanl_id;    //APP来源渠道
@property(nonatomic,retain)NSString *page_name;       //页面名称
@property(nonatomic,retain)NSString *app_user_name;   //APP用户名


-(void)clear;
-(void)sendMessage;
-(BOOL)observationMessage;
-(void)saveMessage:(NSDictionary *)dic;
-(void)appKey:(NSString *)appKey;

//获取手机基本信息
-(void)DeviceAction;
//出错后获取当前异常数据
+(void)DeviceInfo;
+ (exceptionSolve *)sharedManager;

@end
