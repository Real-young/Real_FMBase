//
//  YbmAFNHelper.h
//  YbmAFNHelper
//
//  Created by Mac on 2017/2/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface YbmAFNHelper : AFHTTPSessionManager

/**
 创建一个单例

 @return 返回一个请求的Manager
 */
+ (YbmAFNHelper *)shareManager;

/**
 封装GET请求
 
 @param url 接口的url
 @param parameter 参数
 @param success 请求成功的block
 @param failure 请求失败的block
 */
+ (void)get:(NSString *)url parameter:(id)parameter success:(void (^)(id responseObject))success failure:(void (^)(id error))failure;

/**
 封装POST请求

 @param url 接口的url
 @param parameter 参数
 @param success 请求成功的block
 @param failure 请求失败的block
 */
+ (void)post:(NSString *)url parameter:(id)parameter success:(void (^)(id responseObject))success failure:(void (^)(id error))failure;


/**
 文件上传

 @param url 接口的url
 @param patameter 参数
 @param block 图片data
 @param success 上传成功的block
 @param failure 上传失败的block
 */
+ (void)post:(NSString *)url parameter:(id)patameter contructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(id error))failure;



/**
 文件下载

 @param url 接口的url
 @param ProgressBlock 下载进度的block
 @param savePath 存储路径
 @param completion 下载完成的block
 @param failure 下载失败的block
 */
+ (void)downloadTaskWithUrl:(NSString *)url progress:(void (^)(id downloadProgress))ProgressBlock savePath:(NSString *)savePath  completionHandler:(void (^)(NSURLResponse *response ,NSURL *filePath))completion  error:(void (^)(id error))failure;

@end
