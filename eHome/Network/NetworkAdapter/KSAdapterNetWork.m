
//
//  KSAdapterNetWork.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterNetWork.h"
#import "AFHTTPRequestOperationManager.h"
#import "KSAuthenticationCenter.h"
#import "KSSecurityPolicyAdapter.h"

#define DEFAULT_SCHEME @"https"
#define DEFAULT_HOST @"112.54.207.8"
//#define DEFAULT_HOST @"192.168.8.29"

#define DEFAULT_PORT @"8081"
//#define DEFAULT_PORT @"8080"
//#define DEFAULT_HOST @"172.20.6.133" //@"172.20.6.148"
//#define DEFAULT_PORT @"8080"  //@"8080"
#define DEFAULT_PARH @"PersonSafeManagement/"
#define KS_MANWU_BASE_URL [NSString stringWithFormat:@"%@://%@:%@/",DEFAULT_SCHEME,DEFAULT_HOST,DEFAULT_PORT]


@interface KSAdapterNetWork()

@end

@implementation KSAdapterNetWork


+ (instancetype)sharedAdapterNetWork{
    static KSAdapterNetWork *_sharedAdapterNetWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAdapterNetWork = [[KSAdapterNetWork alloc] init];
    });
    
    return _sharedAdapterNetWork;
}

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startNetworkMonitorSuccess) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        return self;
    }
    
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startNetworkMonitorSuccess
{
    self.isStartNetWorkMonitor = YES;
}

-(void)request:(NSString *)apiName withParam:(NSDictionary *)param onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    
    if (self.isStartNetWorkMonitor && ![AFNetworkReachabilityManager sharedManager].isReachable) {
        
        EHLogError(@"network error");
        NSString* errorString = @"当前网络不可用，请检查网络设置!";
        [WeAppToast toast:errorString];
        NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:9999 userInfo:@{NSLocalizedDescriptionKey: errorString}];
        NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
        if (error) {
            [errorDic setObject:error forKey:@"responseError"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            errorBlock(errorDic);
        });
        
        return;
    }
    // 检查是否需要登陆
    self.needLogin = [param objectForKey:@"needLogin"];
    // 增加最外层的json配置属性
    NSString* jsonTopKey = [param objectForKey:@"__jsonTopKey__"];
    // 统一调用登陆逻辑
    [self callWithAuthCheck:apiName method:^{
        NSString* path = [NSString stringWithFormat:@"%@%@",DEFAULT_PARH,apiName];
        
        // 默认为json序列化
        NSMutableDictionary* newParams = [self getMutableParamWithParam:param];
        
        // 获取successCompleteBlock
        void(^successCompleteBlock)(AFHTTPRequestOperation *operation, id responseObject) = [self getSuccessCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        // 获取errorCompleteBlock
        void(^errorCompleteBlock)(AFHTTPRequestOperation *operation, NSError *error) = [self getErrorCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        [self preProccessParamWithParam:newParams];
        
        AFHTTPRequestOperationManager *httpRequestOM = [self getAFHTTPRequestOperationManager];
        [httpRequestOM.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        
        [self showNetworkActivityIndicatorVisible];

        [httpRequestOM POST:path parameters:newParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successCompleteBlock) {
                successCompleteBlock(operation, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorCompleteBlock) {
                errorCompleteBlock(operation, error);
            }
        }];
    } onError:errorBlock];
}

-(NSMutableDictionary*)getMutableParamWithParam:(NSDictionary*)param{
    NSMutableDictionary* newParams = nil;
    if (param) {
        newParams = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return newParams;
}

-(void)preProccessParamWithParam:(NSMutableDictionary*)newParams{
    
    if (self.needLogin && ![newParams objectForKey:@"user_phone"] && [KSAuthenticationCenter userPhone]) {
        [newParams setObject:[KSAuthenticationCenter userPhone] forKey:@"user_phone"];
    }
    
    /****************************/
    // 删除不必要的参数
    [newParams removeObjectForKey:@"needLogin"];
    // 去除最外层的json配置属性
    [newParams removeObjectForKey:@"__jsonTopKey__"];
}

-(AFHTTPRequestOperationManager*)getAFHTTPRequestOperationManager{
    AFHTTPRequestOperationManager *httpRequestOM = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:KS_MANWU_BASE_URL]];
    httpRequestOM.shouldUseCredentialStorage = NO;
    /**** SSL Pinning ****/
    KSSecurityPolicyAdapter *securityPolicy = [KSSecurityPolicyAdapter policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    [httpRequestOM setSecurityPolicy:securityPolicy];
    /**** SSL Pinning ****/
    
    [httpRequestOM.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        if ([parameters isKindOfClass:[NSString class]]) {
            return (NSString*)parameters;
        }
        NSError* jsonError = nil;
        NSData*  jsonData = [NSJSONSerialization
                            dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&jsonError];
        if ([jsonData length] > 0 && jsonError == nil){
            id paramObj = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#ifdef DEBUG
            EHLogInfo(@"JSON String = %@", paramObj);
#endif
            return paramObj;
        }
        return nil;
    }];
    return httpRequestOM;
}

-(void(^)(AFHTTPRequestOperation *operation, id responseObject))getSuccessCompleteBlockWithApiName:(NSString *)apiName withParam:(NSDictionary *)param jsonTopKey:(NSString*)jsonTopKey onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    return ^void(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* responseDict = (NSDictionary*)responseObject;
            if (jsonTopKey && [jsonTopKey isKindOfClass:[NSString class]] && jsonTopKey.length > 0) {
                responseDict = [responseDict objectForKey:jsonTopKey];
            }
//            EHLogInfo(@"----> responseDict:%@",responseDict);
            NSString* resultstring = [responseDict objectForKey:@"outPut_msg"];
            NSString* resulttime = [responseDict objectForKey:@"outPut_time"];
            NSUInteger resultcode = [[responseDict objectForKey:@"outPut_status"] integerValue];
            EHLogInfo(@"----> resultTime:%@,resultstring:%@,resultcode:%lu,apiName:%@",resulttime,resultstring,resultcode,apiName);
            if (resultcode == 1) {
                EHLogInfo(@"responseDict = %@",responseDict);
                successBlock(responseDict);
            }else{
                if (resultstring == nil) {
                    resultstring = @"连接成功，请求数据不存在";
                }
                NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:resultcode userInfo:@{NSLocalizedDescriptionKey: resultstring}];
                NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
                if (error) {
                    [errorDic setObject:error forKey:@"responseError"];
                }
                errorBlock(errorDic);
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: @"连接成功，请求数据不存在"}];
            NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
            if (error) {
                [errorDic setObject:error forKey:@"responseError"];
            }
            errorBlock(errorDic);
        }
        [self hideNetworkActivityIndicatorVisible];
    };
}

-(void(^)(AFHTTPRequestOperation *operation, NSError *error))getErrorCompleteBlockWithApiName:(NSString *)apiName withParam:(NSDictionary *)param jsonTopKey:(NSString*)jsonTopKey onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    return ^void(AFHTTPRequestOperation *operation, NSError *error){
        NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
        if (error) {
            [errorDic setObject:error forKey:@"responseError"];
        }
        errorBlock(errorDic);
        [self hideNetworkActivityIndicatorVisible];
    };
}

-(void)uploadfile:(NSString *)apiName withFileName:(NSString*)fileName withFileContent: (NSData*)fileContent withParam:(NSDictionary *)param onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    // 检查是否需要登陆
    self.needLogin = [param objectForKey:@"needLogin"];
    // 增加最外层的json配置属性
    NSString* jsonTopKey = [param objectForKey:@"__jsonTopKey__"];
    // 统一调用登陆逻辑
    [self callWithAuthCheck:apiName method:^{
        NSString* path = [NSString stringWithFormat:@"%@%@",DEFAULT_PARH,apiName];
        
        // 默认为json序列化
        NSMutableDictionary* newParams = [self getMutableParamWithParam:param];
        
        // 获取successCompleteBlock
        void(^successCompleteBlock)(AFHTTPRequestOperation *operation, id responseObject) = [self getSuccessCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        // 获取errorCompleteBlock
        void(^errorCompleteBlock)(AFHTTPRequestOperation *operation, NSError *error) = [self getErrorCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        [self preProccessParamWithParam:newParams];
        
        AFHTTPRequestOperationManager *httpRequestOM = [self getAFHTTPRequestOperationManager];
        [httpRequestOM.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        
        [httpRequestOM POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString*key in [newParams allKeys]) {
                [formData appendPartWithFormData:[NSData dataWithBytes:[[newParams objectForKey:key] UTF8String]  length:[[newParams objectForKey:key] length]] name:key];
            }
            
            [formData appendPartWithFileData:fileContent name:fileName fileName:fileName mimeType:@"application/octet-stream"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successCompleteBlock) {
                successCompleteBlock(operation, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorCompleteBlock) {
                errorCompleteBlock(operation, error);
            }
        }];
    } onError:errorBlock];
}


// 判断是否需要登陆才能操作，如果需要登陆，则先登陆，登陆成功后在回调接口；否则直接访问
-(void)callWithAuthCheck:(NSString*) apiName method:(CallMethod)callMethod onError:(NetworkErrorBlock)errorBlock{
    
    if (self.needLogin)
    {
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:^(BOOL loginSuccess) {
            if (loginSuccess)
                callMethod();
            else if (self.needLogin && errorBlock){
                NSDictionary* errorDic = [self getLoginErrorDict];
                errorBlock(errorDic);
            }
        } cancelActionBlock:^{
            if (errorBlock) {
                NSDictionary* errorDic = [self getLoginErrorDict];
                errorBlock(errorDic);
            }
        }];
    }
    else {
        callMethod();
    }
}

-(NSMutableDictionary*)getLoginErrorDict{
    NSError* error = [NSError errorWithDomain:loginFailDomain code:loginFailCode userInfo:nil];
    NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
    if (error) {
        [errorDic setObject:error forKey:@"responseError"];
    }
    return errorDic;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark showOrhide network

-(void)showNetworkActivityIndicatorVisible{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideNetworkActivityIndicatorVisible{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
