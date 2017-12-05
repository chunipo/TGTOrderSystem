//
//  GDModel.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/2.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDModel : NSObject

@property (nonatomic,retain)NSString *number;              // 工单号
@property (nonatomic,retain)NSString *channelorderstatus;  // 工单状态
@property (nonatomic,retain)NSString *equno;               // 设备
@property (nonatomic,retain)NSString *t2t1flag;
@property (nonatomic,retain)NSString *end_time;
@property (nonatomic,retain)NSString *depositmode;
@property (nonatomic,retain)NSString *attrset8dailyprice;
@property (nonatomic,retain)NSString *extendfee;
@property (nonatomic,retain)NSString *extdailycount;
@property (nonatomic,retain)NSString *membername;           // 姓名
@property (nonatomic,retain)NSString *membercellphone;      // 手机号码
@property (nonatomic,retain)NSString *defaultnotusefee;

@end
