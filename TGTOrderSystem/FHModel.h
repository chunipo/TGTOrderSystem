//
//  FHModel.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHModel : NSObject

@property (nonatomic,retain)NSString *orderno;              // 订单号
@property (nonatomic,retain)NSString *dptypeid;             // 套餐
@property (nonatomic,retain)NSString *t2t1flag;             // T1T2
@property (nonatomic,retain)NSString *members;              // 渠道
@property (nonatomic,retain)NSString *start_time;           // 开始时间
@property (nonatomic,retain)NSString *end_time;             // 结束时间
@property (nonatomic,retain)NSString *membername;           // 姓名
@property (nonatomic,retain)NSString *membercellphone;      // 手机号码
@property (nonatomic,retain)NSString *depositmode;          // 押金收取方式
@property (nonatomic,retain)NSString *ticketcount;          // 设备数量

@property (nonatomic,retain)NSString *otaorderid;           // OTA订单号
@property (nonatomic,retain)NSString *orderstatus;          // 订单状态
@property (nonatomic,retain)NSString *salerentalflag;       // 商业模式
@property (nonatomic,retain)NSString *area;                 // 区域
@property (nonatomic,retain)NSString *country_set;          // 目的地
@property (nonatomic,retain)NSString *org;                  // 渠道编号
@property (nonatomic,retain)NSString *carrytype;            // 取货方式
@property (nonatomic,retain)NSString *use_members;          // 订单所属者
@property (nonatomic,retain)NSString *takelocationname;     // 取件地点
@property (nonatomic,retain)NSString *returnlocationname;   // 还件地点
@property (nonatomic,retain)NSString *expno;                // 快递号
@property (nonatomic,retain)NSString *expectdeliverytime;   // 预计发货日期
@property (nonatomic,retain)NSString *expectreturntime;     // 预计归还日期
@property (nonatomic,retain)NSString *contactremark;        // 备注
@property (nonatomic,retain)NSString *deposit;              // 押金
@property (nonatomic,retain)NSString *paynowpaylaterflag;   // 套餐支付方式
@property (nonatomic,retain)NSString *channelorderdptypefee;// 套餐金额
//@property (nonatomic,retain)NSString *membername;         // 取消费用
@property (nonatomic,retain)NSString *cancelcount;          // 取消数量

@property (nonatomic,retain)NSString *adddays;
@property (nonatomic,retain)NSString *bizorg;
@property (nonatomic,retain)NSString *salesperson;          // 销售员
@property (nonatomic,retain)NSString *settleman;            // 结算人
@property (nonatomic,retain)NSString *creator;              // 下单人
@property (nonatomic,retain)NSString *created_time;         // 下单时间
@property (nonatomic,retain)NSString *last_modifier;        // 修改人
@property (nonatomic,retain)NSString *last_modified_time;   // 修改时间

@property (nonatomic,retain)NSString *deliverypath;
@property (nonatomic,retain)NSString *receivedpath;

@end
