//
//  HHTopView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/17.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldView.h"
#import "RadioBtn.h"
#import "YCTableView.h"
#import "XGGHttpsManager.h"
#import "V1HttpTool.h"
#import "GDModel.h"

@interface HHTopView : UIView 

@property (nonatomic,copy)UILabel *titleLab;
@property (nonatomic,retain)TextFieldView *sjghTfView;  // 归还日期
@property (nonatomic,retain)TextFieldView *yqfyTfView;  // 延期未使用费用
@property (nonatomic,retain)TextFieldView *ycghTfView;  // 延迟归还原因
@property (nonatomic,retain)TextFieldView *shyyTfView;  // 设备损坏原因
@property (nonatomic,retain)TextFieldView *shkfTfView;  // 设备损坏扣费
@property (nonatomic,retain)TextFieldView *jsfsTfView;  // 结算方式
@property (nonatomic,copy)NSString *yjType;  // 押金收取方式

@property (nonatomic,retain)RadioBtn *radioBtn1;

@property (nonatomic,retain)YCTableView *ycTableView;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,copy)NSString *devNum;

@property (nonatomic,retain)GDModel *gdmodel;
@end
