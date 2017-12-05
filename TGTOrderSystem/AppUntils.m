//
//  AppUntils.m
//  test
//
//  Created by DEVCOM on 11/22/17.
//  Copyright © 2017 DEVCOM. All rights reserved.
//

#import "AppUntils.h"


#import  <Security/Security.h>
#import "KeychainItemWrapper.h"


@implementation AppUntils

#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:Acount service:Server accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:Acount service:Server accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}



+(NSString *)getServerId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    
    return DeviceID;
}

@end
