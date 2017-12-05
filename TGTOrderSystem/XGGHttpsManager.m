//
//  XGGHttpsManager.m
//  afDemo
//
//  Created by XGG on 16/6/11.
//  Copyright © 2016年 XGG. All rights reserved.
//

#import "XGGHttpsManager.h"

@implementation XGGHttpsManager

#pragma mark - GET/POST
+ (void)requstURL:(NSString *)urlStr
        parametes:(NSDictionary *)param
       httpMethod:(HttpMethodType)httpMethod
         progress:(ProgressBlock)progressHandler
          success:(SuccessBlock)success
          failure:(AFNErrorBlock)failure
{
    if (httpMethod == Http_GET) {
        
        // 创建请求类
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;         // 超时时间
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];     // 上传普通格式
//            manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];     // 声明获取到的数据为普通格式
//            manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 声明获取到的数据为JSON格式
        
        [manager GET:urlStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            // 获取到目前数据请求的进度
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                float progressFloat = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                progressHandler(progressFloat);
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dict,YES);
            } else {
                success(@{@"error":@"无数据返回"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            failure(error);
        }];
    } else if (httpMethod == Http_POST) {
    
        // 创建请求类
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;         // 超时时间
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];     // 上传普通格式
//            manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];     // 声明获取到的数据为普通格式
//            manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 声明获取到的数据为JSON格式
        
        [manager POST:urlStr parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
            // 回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置进度条的百分比
                float progressFloat = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                progressHandler(progressFloat);
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dict,YES);
            } else {
                success(@{@"error":@"无数据返回"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            failure(error);
        }];
    }
}

#pragma mark - 上传
+ (void)uploadURL:(NSString *)urlStr
        parametes:(NSDictionary *)param
         fileData:(NSData *)data
         progress:(ProgressBlock)progressHandler
             name:(NSString *)name
         fileName:(NSString *)fileName
         mimeType:(NSString *)mimeType
          success:(SuccessBlock)success
          failure:(AFNErrorBlock)failure
{
    // 创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            float progressFloat = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            progressHandler(progressFloat);
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(dict,YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        failure(error);
    }];
}

#pragma mark - 下载
+ (void)downLoadWithURL:(NSString *)urlStr
               progress:(ProgressBlock)progressHandler
               complete:(DownLoadComplete)completeHandler
{
    // 创建管理者对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            float progressFloat = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            progressHandler(progressFloat);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // doucmentPath 为文件下载的存放路径
        NSString *cachesPath = [filePath path];
        completeHandler((NSDictionary *)response ,cachesPath);
    }];
    // 启动下载任务
    [task resume];
}

@end
