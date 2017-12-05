//
//  GetOrderImage.m
//  TGTOrderSystem
//
//  Created by Ke Liu on 2017/3/20.
//  Copyright © 2017年 TGT. All rights reserved.
//

#import "GetOrderImage.h"
#import "V1HttpTool.h"


@implementation GetOrderImage

+ (instancetype)shareInstance {
    static GetOrderImage *getImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getImg = [[GetOrderImage alloc] init];
    });
    return getImg;
}


#pragma mark - 获取订单图片
- (void)getOrderImageWithOrder_no:(NSString *)order_no Type:(NSString *)type ImgUrlBlock:(ImgUrl)block {
    
    NSString *accountId = @"tgt_ipad";
    bool bool_false = false;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:order_no forKey:@"orderno"];
    [dataDic setObject:type forKey:@"type"];
    
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"downloadPicture",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"downloadPicture",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.downloadPicture",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session=[NSURLSession  sharedSession];
    __block NSString *imgUrl = @"";
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
 
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    imgUrl = [NSString stringWithFormat:@"%@",dict[@"data"]];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                block(imgUrl);
            });
        } else {
            block(imgUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"图片无法显示" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        
    }];
    [task resume];
    
}

@end
