//
//  GetOrderImage.h
//  TGTOrderSystem
//
//  Created by Ke Liu on 2017/3/20.
//  Copyright © 2017年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImgUrl)(NSString *imgurl);

@interface GetOrderImage : NSObject

+ (instancetype)shareInstance;
- (void)getOrderImageWithOrder_no:(NSString *)order_no Type:(NSString *)type ImgUrlBlock:(ImgUrl)block;

@end
