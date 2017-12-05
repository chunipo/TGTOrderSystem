//
//  V2HttpTool.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "V2HttpTool.h"
#import "V1HttpTool.h"

@implementation V2HttpTool

#pragma mark - V2签名类
+ (NSString *)searchOrderWithKeyWord:(NSDictionary *)dict requestTime:(NSString *)requestTime {
    
    NSDictionary *dataDic = dict;
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"tgt_ipad",@"mobileQuery",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    return sign_md5;
}

#pragma mark - UUID签名
+ (NSString *)searchOrderWithUUID:(NSDictionary *)dict requestTime:(NSString *)requestTime {
    
    NSDictionary *dataDic = dict;
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"tgt_ipad",@"queryLocatEquip",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    return sign_md5;
}

@end
