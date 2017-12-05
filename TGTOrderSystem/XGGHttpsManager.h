//
//  XGGHttpsManager.h
//  afDemo
//
//  Created by XGG on 16/6/11.
//  Copyright © 2016年 XGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kTimeOutInterval 15 // 请求超时的时间
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error);                  // 访问失败block
typedef void (^ProgressBlock)(float progress);                  // 进度block
typedef void (^DownLoadComplete)(NSDictionary *respone ,NSString *path);  // 下载完成回调block

@interface XGGHttpsManager : NSObject

typedef enum {
    Http_GET,          // GET方法
    Http_POST,         // POST方法
} HttpMethodType;

/**
 *  ---- HTTP GET/POST请求 ----
 *
 *  urlStr             请求URL字符串
 *  param              请求参数
 *  httpMethod         请求方法，HttpMethodType枚举类型
 *  progressHandler    进度回调
 *  success / failure  成功/失败回调
 */
+ (void)requstURL:(NSString *)urlStr
        parametes:(NSDictionary *)param
       httpMethod:(HttpMethodType)httpMethod
         progress:(ProgressBlock)progressHandler
          success:(SuccessBlock)success
          failure:(AFNErrorBlock)failure;

/**
 *  ---- 上传文件 -----
 *
 *  urlStr             请求URL字符串
 *  param              请求参数
 *  data               文件数据
 *  progressHandler    进度回调
 *  name               文件填写file
 *  fileName           上传的文件名
 *  mimeType           媒体类型（zip文件：application/zip ; 图片文件：image/png）
 *  success / failure  成功/失败回调
 */
+ (void)uploadURL:(NSString *)urlStr
        parametes:(NSDictionary *)param
         fileData:(NSData *)data
         progress:(ProgressBlock)progressHandler
             name:(NSString *)name
         fileName:(NSString *)fileName
         mimeType:(NSString *)mimeType
          success:(SuccessBlock)success
          failure:(AFNErrorBlock)failure;

/**
 *  ----- 下载文件 -----
 *
 *  urlStr             请求URL字符串
 *  progressHandler    下载进度的回调
 *  completeHandler    下载完成的回调
 */
+ (void)downLoadWithURL:(NSString *)urlStr
               progress:(ProgressBlock)progressHandler
               complete:(DownLoadComplete)completeHandler;

@end
