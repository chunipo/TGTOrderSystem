//
//  DefaultWarehoseAPI.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 17/1/13.
//  Copyright © 2017年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DefaultData)(NSDictionary *dict);

@interface DefaultWarehoseAPI : NSObject

// V1
+ (void)V1_selcectDefaultWarehouseWithNumber:(NSString *)number returnDefaultData:(DefaultData)firstData;
// V2
+ (void)V2_selcectDefaultWarehouseWithNumber:(NSString *)number returnDefaultData:(DefaultData)firstData;
@end
