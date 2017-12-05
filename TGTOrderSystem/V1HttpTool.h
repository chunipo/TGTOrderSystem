//
//  V1HttpManager.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/7/13.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V1HttpTool : NSObject

+ (NSString *)getKey;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSString*)md5_32BitLower:(NSString *)str;

@end
