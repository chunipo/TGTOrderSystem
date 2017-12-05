//
//  AppUntils.h
//  test
//
//  Created by DEVCOM on 11/22/17.
//  Copyright © 2017 DEVCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUntils : NSObject

+(void)saveUUIDToKeyChain;

+(NSString *)readUUIDFromKeyChain;

+ (NSString *)getUUIDString;

/*存储服务器返回的id*/
+(NSString *)getServerId;


@end
