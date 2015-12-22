//
//  exceptionSolve.m
//  UncaughtExceptionHandlerFrameWork
//
//  Created by 慧博创测-刘晓威 on 15/3/31.
//  Copyright (c) 2015年 刘晓威. All rights reserved.
//
#include <sys/param.h>
#include <sys/mount.h>
#import "exceptionSolve.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import  <CoreTelephony/CTCarrier.h>
#import "CDVReachability.h"
//#import "NSDictionary+JSONSerialize.h"

//是否越狱
#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

@implementation exceptionSolve

//单例
+ (exceptionSolve *)sharedManager{
    static exceptionSolve *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//是否越狱
+ (BOOL)isJailBreak{
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

//存异常数据
-(void)saveMessage:(NSArray *)array{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"UncaughtException"];
}

////数据清楚
//-(void)clear{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:@"UncaughtException"];
//}

//解析数据
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || [jsonString isEqualToString:@""]) {
        return nil;
    }
    // 解析数据 去除验证数据
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dicData;
}

//将数组 字典转JSON
- (NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

//数据发送
-(void)sendMessage
{
    if ([self observationMessage]) {
    NSURL *url = [NSURL URLWithString:@"http://112.54.207.8:8080/android/upload/create"];
    NSString *dataString = [self getFileData];                              //获取异常数据
    NSDictionary *dataDic = [self dictionaryWithJsonString:dataString];     //将数据转成字典
    NSDictionary* toserverDic = [dataDic objectForKey:@"crash"];            //取出数据中的字段
    
    NSString *appkey = [NSString stringWithFormat:@"%@",[toserverDic objectForKey:@"app_key"]];
    NSString *page_name = [NSString stringWithFormat:@"%@",[toserverDic objectForKey:@"page_name"]];
        NSDictionary *toserverDic1 = [[NSDictionary alloc]initWithObjectsAndKeys:
                                      appkey,@"app_key",
                                      [toserverDic objectForKey:@"net_id"] ,@"net_id" ,
                                      [toserverDic objectForKey:@"app_version"],@"app_version",[toserverDic objectForKey:@"log_content"],@"log_summary",
                                      [toserverDic objectForKey:@"log_summary"],@"log_content",[toserverDic objectForKey:@"log_flagline"],@"log_flagline",[toserverDic objectForKey:@"log_time"],@"log_time",
                                      [toserverDic objectForKey:@"dev_name"],@"dev_name",
                                      [toserverDic objectForKey:@"app_user_name"],@"app_user_name",
//                                      @"123",@"page_name",
                                      [toserverDic objectForKey:@"app_chanl_id"],@"app_chanl_id",
                                      [toserverDic objectForKey:@"app_pkg"],@"app_pkg",
                                      [toserverDic objectForKey:@"dev_latitude"],@"dev_latitude",
                                      [toserverDic objectForKey:@"dev_longitude"],@"dev_longitude",
                                      [toserverDic objectForKey:@"dev_root"],@"dev_root",
                                      [toserverDic objectForKey:@"log_type_id"],@"log_type_id",
                                      nil];


        
    NSArray * arr = [[NSArray alloc]initWithObjects:toserverDic1, nil];
    NSString * app = [self toJSONData:arr];
    NSDictionary *datadic = [[NSDictionary alloc]initWithObjectsAndKeys:app,@"crash", nil];
    EHLogError(@"######### crash call stack info:\n%@", dataDic);
        
#ifdef DEBUG
        [self clear];
#else
    NSMutableURLRequest *request =[self HTTPPOSTNormalRequestForURL:url parameters:datadic];
    //第三步，连接服务器
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    [[NSURLConnection alloc]initWithRequest:request delegate:self]
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
  //  NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //将NSString 转化成字典
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:received options:NSJSONReadingAllowFragments
                         error:&error];
        
        NSArray *deserializedArray = (NSArray *)jsonObject;
        if (deserializedArray.count>0) {
            for (int i= 0; i<deserializedArray.count; i++) {
                NSDictionary *dic_data = [deserializedArray objectAtIndex:i];
                NSString *code = [NSString stringWithFormat:@"%@",[dic_data objectForKey:@"flag"]];
                if ([code isEqualToString:@"1"]) {
                    [self clear];
                    break;
                }
                else
                {
                    NSLog(@"继续遍历 数据上传失败");
                }
            }
        }
#endif
    }
}

//接受到服务器的回应调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [resultData setLength:0 ];
    
}
//数据传输中一直调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [resultData appendData:data];
    
}
//数据传输完才会调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * str = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSDictionary *dicdata = [self dictionaryWithJsonString:str];
    if ([[dicdata objectForKey:@"flag"] isEqualToString:@"1"]) {
        
    }
    NSLog(@"返回值===>%@",dicdata);
}

//这是请求出错是调用，错误处理不可忽视
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (error.code == NSURLErrorTimedOut) {
        NSLog(@"请求超时");
    }
    NSLog(@"%@",[error localizedDescription]);
}

- (NSMutableURLRequest *)HTTPPOSTNormalRequestForURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSString *HTTPBodyString = [self HTTPBodyWithParameters:parameters];
    [URLRequest setHTTPBody:[HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [URLRequest setHTTPMethod:@"POST"];
    return URLRequest;
}

- (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
    }
    return [parametersArray componentsJoinedByString:@"&"];
}

//观察数据是否存在
-(BOOL)observationMessage{
    if ([self getFileData].length >0) {
        return YES;
    }
    else{
        return NO;
    }
}

//获取平台APP_key
-(void)appKey:(NSString *)appKey{
    if ([appKey isEqualToString:@""] || appKey == nil)
    {
        [self alertAction:@"缺少AppKey，请到http://192.168.5.199/api/b10/app/myApp/create注册"];
    }
    _app_key = appKey;
}

//获取日志类型
-(NSString *)crashType:(NSString *)type{
    return @"1";
}

//写入文件数据
-(void)writeFiled:(NSString *)str{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"appid_token.txt"];
    
    //如果没有就创建文件
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //读取.txt文件
//    NSString* deviceId = [NSString stringWithContentsOfFile:filePath
//                                                   encoding:NSUTF8StringEncoding
//                                                      error:NULL];
//    NSLog(@"deviceId:%@",deviceId);
    //NSDictionary *dicData = [self dictionaryWithJsonString:deviceId];
}

//取出数据
-(NSString *)getFileData{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"appid_token.txt"];
    //读取.txt文件
    NSString* deviceId = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    return deviceId;
}

-(void)clear
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"appid_token.txt"];
    //对于错误信息
    NSError *error;
    if ([fileManager removeItemAtPath:filePath error:&error] != YES)
    {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"＝＝＝＝>数据清理成功");
    }
}

-(NSString*)ArrayToString:(NSArray*)array
{
    NSMutableString *jsonString = [NSMutableString stringWithString:@"{"];
    
    for (int i=0; i<array.count; i++) {
        NSString *itemStr = [array objectAtIndex:i];
        if (itemStr == nil) {
            itemStr = @" ";
            continue;
        }
        [jsonString appendString:itemStr];
        if (i < array.count - 1) {
            [jsonString appendFormat:@","];
        }
    }
    [jsonString appendString:@"}"];
    return jsonString;
}

//获取手机基本数据
-(void)DeviceAction{
    _log_type_id = @"1";                                      //日志类型，Crash为1
    _log_time = [self curDataTime];                           //当前时间
    _sd_rest_size = [exceptionSolve freeDiskSpaceInBytes];
    BOOL make = [exceptionSolve isJailBreak];                 //是否越狱
    if(make){
        _dev_root = @"0";
    }else{
        _dev_root = @"1";
    }
    float total_size = [exceptionSolve getFreeDiskspace];      //内存大小
    _sd_total_size = [NSString stringWithFormat:@"%f",total_size];
    _dev_name =[[UIDevice currentDevice] systemName]; // 操作系统
    _osversion =[[UIDevice currentDevice]systemVersion]; // 操作系统版本
    _sim_id = [self getCarrier];
    
    _net_id = [self networkingStatesFromStatebar];      //获取网络
    if (_net_id == nil || [_net_id isEqualToString:@""]) {
        _net_id = [self netWorking];
    }
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float batteryLevel = [UIDevice currentDevice].batteryLevel;// 电量查询
    float n = batteryLevel *100;
    _bat_num = [NSString stringWithFormat:@"%d％",(int)n];
    _bat_status = [self batState];
    if ((n-50)>0) {
        _bat_usage = @"状态好";
    }else{
        _bat_usage = @"状态不理想";
    }
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    _app_user_name = [[NSBundle mainBundle] bundleIdentifier];
    if (_app_user_name == nil || [_app_key isEqualToString:@""]) {
        _app_user_name = @"";
    }
    _app_version =[infoDict objectForKey:@"CFBundleVersion"];
    if (_app_version == nil || [_app_version isEqualToString:@""]) {
        _app_version = @"";
    }
    _app_pkg =[infoDict objectForKey:@"CFBundleDisplayName"];
    if (_app_pkg == nil || [_app_pkg isEqualToString:@""]) {
        _app_pkg = @"";
    }
    _app_chanl_id = @"7";  //苹果商店
    _app_version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    if (_app_version == nil || [_app_version isEqualToString:@""]) {
        _app_version = @"";
    }
    
    //获取APP的key到http://192.168.5.199/andriod/upload/create 注册
    //_app_user_name  = @"20150402006";
    
    // 经纬度
    _dev_longitude = @" ";
    _dev_latitude = @" ";
    
    dic = [NSMutableDictionary dictionary];
    [dic setValue:_log_type_id forKey:@"log_type_id"];
    [dic setValue:_log_time forKey:@"log_time"];
    //异常数据存储
    _log_flagline = [_log_summary objectAtIndex:1];
    NSString *log_summaryStr = [self  ArrayToString:_log_summary];
    NSString *log_summary = [NSString stringWithFormat:@"%@",log_summaryStr];
    [dic setObject:log_summary forKey:@"log_summary"];
    [dic setObject:_log_content forKey:@"log_content"];
    [dic setObject:_log_flagline forKey:@"log_flagline"];
    [dic setObject:_page_name forKey:@"page_name"];
    [dic setObject:_dev_name forKey:@"dev_name"];
    [dic setObject:_osversion forKey:@"osversion"];
    [dic setObject:_sim_id forKey:@"sim_id"];
    [dic setObject:_net_id forKey:@"net_id"];
    [dic setObject:_sd_total_size forKey:@"sd_total_size"];
    [dic setObject:_sd_rest_size forKey:@"sd_rest_size"];
    [dic setObject:_bat_num forKey:@"bat_num"];
    [dic setObject:_bat_status forKey:@"bat_status"];
    [dic setObject:_bat_usage forKey:@"bat_usage"];
    [dic setObject:_dev_root forKey:@"dev_root"];
    [dic setObject:_dev_longitude forKey:@"dev_longitude"];
    [dic setObject:_dev_latitude forKey:@"dev_latitude"];
    [dic setObject:_app_key forKey:@"app_key"];
    [dic setObject:_app_version forKey:@"app_version"];
    [dic setObject:_app_pkg forKey:@"app_pkg"];
    [dic setObject:_app_chanl_id forKey:@"app_chanl_id"];
    [dic setObject:_app_user_name forKey:@"app_user_name"];
    
    NSDictionary *dic1 =  [dic copy];
    

    //NSArray *data_array = [NSArray arrayWithObjects:dic1, nil];
    NSDictionary *dic_dic = [[NSDictionary alloc]initWithObjectsAndKeys:dic1,@"crash", nil];
    NSString *conntent = [self toJSONData:dic_dic];
    //写入文本
    [self writeFiled:conntent];
    
    [self sendMessage];
}

// 检测电池状态
-(NSString *)batState{
    UIDeviceBatteryState batteryState = [[UIDevice currentDevice]batteryState];
    // 有如下几个状态
    // UIDeviceBatteryStateUnknown 0 未识别 0
    // UIDeviceBatteryStateUnplugged, 充电中 1
    // UIDeviceBatteryStateCharging, 少于100% 2
    // UIDeviceBatteryStateFull, 充满了 3
    NSString * type;
    switch (batteryState) {
        case UIDeviceBatteryStateUnknown:
        {
              type=@"未识别";
        }
            break;
        case UIDeviceBatteryStateUnplugged:
        {
            type=@"充电中";
        }
            break;
        case UIDeviceBatteryStateCharging:
        {
            type=@"少于100";
        }
            break;
        case UIDeviceBatteryStateFull:
        {
            type=@"满电";
        }
            break;

        default:
            break;
    }
    return type;
}

//获取出错后的基本信息
-(void)DeviceInfo{
    _log_time = [self curDataTime];
}

//获取当前时间
-(NSString *)curDataTime{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    NSString *  locationString=[formatter stringFromDate:date];
    NSLog(@"当前时间：%@",locationString);
    NSString * time = [NSString stringWithFormat:@"%@",locationString];
    return time;
}

//获取内存
 +(float)getFreeDiskspace{
    float totalSpace;
    float totalFreeSpace=0.f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
    } else {
    }
    return totalFreeSpace;
}

//获取表示符
+(NSString*) uuid {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

//剩余空间
+ (NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"手机剩余存储空间为：%qi MB" ,freespace/1024/1024];
}

//网络状态
- (NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSString *stateString = @"wifi";
    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
    return stateString;
}

//网络状态
-(NSString *)netWorking{
//    CDVReachability *a = [[CDVReachability alloc]init];
    CDVReachability *hostReach = [CDVReachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    //获取网络状态
    NSString *netType;
    CDVReachability *r = [CDVReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case ReachableVia2G:
            // 使用2G网络
            netType = @"2G";
            break;
        case ReachableVia3G:
            // 使用3G网络
            netType = @"3G";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            netType = @"WIFI";
            break;
        case NotReachable:
            netType = @"网络断开";
            break;
        default:
            netType = @"4G";
            break;
    }
    return netType;
}

//运营商
- (NSString*)getCarrier{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString * mcc = [carrier mobileCountryCode];
    NSString * mnc = [carrier mobileNetworkCode];
    if (mnc == nil || mnc.length <1 || [mnc isEqualToString:@"SIM Not Inserted"] ) {
        return @"Unknown";
    }else {
        if ([mcc isEqualToString:@"460"]) {
            NSInteger MNC = [mnc intValue];
            switch (MNC) {
                case 00:
                case 02:
                case 07:
                    return @"1";   //China Mobile
                    break;
                case 01:
                case 06:
                    return @"2";  //China Unicom
                    break;
                case 03:
                case 05:
                    return @"3";   //China Telecom
                    break;
                case 20:
                    return @"4";   //China Tietong
                    break;
                default:
                    break;
            }
        }
    }
    
    return@"Unknown";
}

-(void)alertAction:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
