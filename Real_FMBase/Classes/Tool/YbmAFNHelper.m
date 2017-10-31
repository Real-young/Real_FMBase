//
//  YbmAFNHelper.m
//  YbmAFNHelper
//
//  Created by Mac on 2017/2/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "YbmAFNHelper.h"
typedef void(^reachabilityBlock)(NSString * status);
@implementation YbmAFNHelper

+ (void)netWorkingStatusBlock:(reachabilityBlock)reachability
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            reachability(@"当前网络已断开");
        }else if (status == 1){
            reachability(@"3G/4G网络");
        }else if (status == 2){
            reachability(@"wifi状态下");
        }
    }];
}

+ (YbmAFNHelper *)shareManager
{
    static YbmAFNHelper *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [YbmAFNHelper manager];
        //设置可接受的类型
        handle.responseSerializer = [AFHTTPResponseSerializer serializer];
        handle.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"image/jpeg", nil];
    });
    return handle;
}

+ (void)get:(NSString *)url parameter:(id)parameter success:(void (^)(id responseObject))success failure:(void (^)(id error))failure
{
    [self netWorkingStatusBlock:^(NSString *status) {
        if ([status isEqual: @"当前网络已断开"]) {
            [MessageWindow messageWindowString:status];
        }
    }];
    [[YbmAFNHelper shareManager] GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success([self gb2312ToUtf8:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)post:(NSString *)url parameter:(id)parameter success:(void (^)(id responseObject))success failure:(void (^)(id error))failure
{
    [self netWorkingStatusBlock:^(NSString *status) {
        if ([status isEqual: @"当前网络已断开"]) {
            [MessageWindow messageWindowString:status];
            return ;
        }
    }];
    [[YbmAFNHelper shareManager] POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success([self gb2312ToUtf8:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)post:(NSString *)url parameter:(id)patameter contructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(id error))failure
{
    [[YbmAFNHelper shareManager] POST:url parameters:patameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)downloadTaskWithUrl:(NSString *)url progress:(void (^)(id downloadProgress))ProgressBlock savePath:(NSString *)savePath  completionHandler:(void (^)(NSURLResponse *response ,NSURL *filePath))completion  error:(void (^)(id error))failure;
{
    //创建请求
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //创建任务
    NSURLSessionDownloadTask *download = [[YbmAFNHelper shareManager] downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgress) {
            ProgressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            completion(response,filePath);
        }else
        {
            if (error) {
                failure(error);
            }
        }
    }];
    
    //开启任务
    [download resume];
}

#pragma mark -gb2312 转 UTF-8
+ (NSDictionary *)gb2312ToUtf8: (NSData *)data {
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    return [self dictionaryWithJsonString:retStr];
}
#pragma mark -字符串转JSON
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    BMLog(@"%@",jsonString);
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
