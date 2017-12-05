//
//  OrderContentView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldView.h"
#import "RadioBtn.h"

@interface OrderContentView : UIView<UITextFieldDelegate>

// 订单信息
@property (nonatomic,retain)NSArray *orderLeftName;             // 左边数据
@property (nonatomic,retain)UILabel *oderNo;                    // 订单号
@property (nonatomic,retain)UILabel *oderStatus;                // 订单状态
@property (nonatomic,retain)UILabel *orderMode;                 // 订单模式
@property (nonatomic,retain)UILabel *country;                   // 目的地国家
@property (nonatomic,retain)TextFieldView *otaTfView;           // OTA订单号
@property (nonatomic,retain)TextFieldView *channelTfView;       // 渠道
@property (nonatomic,retain)TextFieldView *areaTfView;          // 区域
@property (nonatomic,retain)TextFieldView *packageTfView;       // 套餐
@property (nonatomic,retain)TextFieldView *salesTfView;         // 销售员
@property (nonatomic,retain)TextFieldView *departmentTfView;    // 业务部门
@property (nonatomic,retain)TextFieldView *startTimeTfView;     // 开始时间
@property (nonatomic,retain)TextFieldView *daysTfView;          // 套餐天数
@property (nonatomic,retain)RadioBtn *radioBtn1;
@property (nonatomic,retain)RadioBtn *radioBtn2;

// 取货信息
@property (nonatomic,retain)NSArray *qhLeftName;                // 左边数据
@property (nonatomic,retain)TextFieldView *nameTfView;          // 取货人姓名
@property (nonatomic,retain)TextFieldView *phoneTfView;         // 取货人电话
@property (nonatomic,retain)TextFieldView *qjTfView;            // 取件地点
@property (nonatomic,retain)TextFieldView *hjTfView;            // 还件地点
@property (nonatomic,retain)UITextView *textView;               // 备注
@property (nonatomic,retain)RadioBtn *radioBtn3;
@property (nonatomic,retain)RadioBtn *radioBtn4;

// 取货信息
@property (nonatomic,retain)NSArray *yjLeftName;                // 左边数据
@property (nonatomic,retain)TextFieldView *sqTfView;            // 押金收取方式
@property (nonatomic,retain)TextFieldView *zfTfView;            // 套餐支付方式
@property (nonatomic,retain)UILabel *yjLab;                     // 押金
@property (nonatomic,retain)UILabel *tcLab;                     // 套餐
@property (nonatomic,retain)UILabel *qxLab;                     // 取消费用

// 订购数量
@property (nonatomic,retain)TextFieldView *dgTfView;            // 设备订购数

@end
