//
//  V2HttpTool.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V2HttpTool : NSObject

+ (NSString *)searchOrderWithKeyWord:(NSDictionary *)dict requestTime:(NSString *)requestTime;

+ (NSString *)searchOrderWithUUID:(NSDictionary *)dict requestTime:(NSString *)requestTime;
@end
