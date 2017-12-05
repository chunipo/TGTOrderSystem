//
//  V1HttpManager.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/7/13.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "V1HttpTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation V1HttpTool

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getKey {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *nowtime = [formatter stringFromDate:[NSDate date]];
    NSString *keyStr = [@"TERMINAL" stringByAppendingString:nowtime];
    
    return [V1HttpTool md5_32BitLower:keyStr];
}

+ (NSString*)md5_32BitLower:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
@end
