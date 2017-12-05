//
//  DefaultWarehoseAPI.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 17/1/13.
//  Copyright © 2017年 TGT. All rights reserved.
//

#import "DefaultWarehoseAPI.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"
#import "XGGHttpsManager.h"


@implementation DefaultWarehoseAPI

+ (void)V1_selcectDefaultWarehouseWithNumber:(NSString *)number returnDefaultData:(DefaultData)firstData {
    NSString *sn;
    if ([number isEqualToString:@"(null)"]||[number isEqualToString:@"<null>"]||[number isEqualToString:@""]) {
        sn = @"";
    } else {
        sn = number;
    }
    NSDictionary *dic = @{@"sn":sn};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *keyStr = [V1HttpTool getKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.getAllWareHouse",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        if ([dict[@"code"] isEqualToString:@"0"]) {
            NSArray *arr_v1 = dict[@"wareHouses"];
            NSDictionary *firstDic = arr_v1.firstObject;
            NSString *defaultName = [NSString stringWithFormat:@"%@",firstDic[@"name"]];
            NSString *ck_code = [NSString stringWithFormat:@"%@",firstDic[@"code"]];
            firstData(@{@"HostWarehouse":defaultName,@"code":ck_code});
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

+ (void)V2_selcectDefaultWarehouseWithNumber:(NSString *)number returnDefaultData:(DefaultData)firstData {
    
    NSString *gd_number;
    if ([number isEqualToString:@"(null)"]||[number isEqualToString:@"<null>"]||[number isEqualToString:@""]) {
        gd_number = @"";
    } else {
        gd_number = number;
    }
    
    NSString *accountId = @"tgt_ipad";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//    [dataDic setObject:gd_number forKey:@"number"];
    /*将number改成code字段*/
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    [dataDic setObject:DeviceID forKey:@"code"];
    
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"queryWarehose",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"queryWarehose",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.queryWarehose",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    NSArray *arr = dict[@"data"];
                    NSString *hostWarehouse;
                    NSString *subwarehouse;
                    if (arr.count == 0) {
                        hostWarehouse = @"";
                        subwarehouse = @"";
                        firstData(@{@"HostWarehouse":hostWarehouse,@"SubWarehouse":subwarehouse});
                    } else {
                        NSDictionary *firstDic = arr.firstObject;
                        hostWarehouse = [NSString stringWithFormat:@"%@",firstDic[@"warehosename"]];
                        NSArray *sub_arr = firstDic[@"subwarehose"];
                        if (sub_arr.count == 0) {
                            subwarehouse = @"";
                        } else {
                            NSDictionary *subDic;
                            for (NSDictionary *dic in sub_arr) {
                                NSString *defaultreceivesub = [NSString stringWithFormat:@"%@",dic[@"defaultreceivesub"]];
                                if ([defaultreceivesub isEqualToString:@"1"]) {
                                    subDic = dic;
                                }
                            }
                            subwarehouse = [NSString stringWithFormat:@"%@",subDic[@"subwarehosename"]];
                        }
                        if ([subwarehouse isEqualToString:@""]||[subwarehouse isEqualToString:@"<null>"]||[subwarehouse isEqualToString:@"(null)"]) {
                            subwarehouse = @"";
                        }
                        firstData(@{@"HostWarehouse":hostWarehouse,@"SubWarehouse":subwarehouse});
                    }
                    
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货仓库查询失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    
    [task resume];
}

@end
