//
//  YCSHView_V1.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioBtn.h"
#import "TextFieldView.h"
#import "GDModel.h"
#import "CalendarView.h"
#import "CkSelectView.h"

typedef void (^ReloadSelectBlock)(NSString *selectStr);

@interface YCSHView_V1 : UIView <UITextFieldDelegate,UITextViewDelegate>
{
    UIView *_bgView;
    UILabel *_titleLab;
    CkSelectView *seleCtView;
    UIScrollView *_scrollView;
    NSString *_dayStr;
    NSString *_ckCode;
}
@property (nonatomic,retain)UILabel *snLabel;               //sn
@property (nonatomic,retain)TextFieldView *ckTfView;        // 收货仓库
@property (nonatomic,retain)UILabel *jstimeLabel;           // 结束时间
@property (nonatomic,retain)TextFieldView *sjghTfView;      // 实际归还日期
@property (nonatomic,retain)UILabel *zhLabel;               // 归还人账号
@property (nonatomic,retain)UILabel *payLabel;       // 实际扣费
@property (nonatomic,retain)RadioBtn *sim_radioBtn1;        // 设备、sim
@property (nonatomic,retain)RadioBtn *sim_radioBtn2;
@property (nonatomic,retain)RadioBtn *ck_radioBtn1;         // 插口
@property (nonatomic,retain)RadioBtn *ck_radioBtn2;
@property (nonatomic,retain)RadioBtn *wk_radioBtn1;         // 外壳
@property (nonatomic,retain)RadioBtn *wk_radioBtn2;
@property (nonatomic,retain)RadioBtn *pj_radioBtn1;         // 配件
@property (nonatomic,retain)RadioBtn *pj_radioBtn2;
@property (nonatomic,retain)RadioBtn *sjx_radioBtn1;        // 数据线
@property (nonatomic,retain)RadioBtn *sjx_radioBtn2;
@property (nonatomic,retain)RadioBtn *pt_radioBtn1;         // 皮套
@property (nonatomic,retain)RadioBtn *pt_radioBtn2;
@property (nonatomic,retain)RadioBtn *yqzt_radioBtn1;       // 延期状态
@property (nonatomic,retain)RadioBtn *yqzt_radioBtn2;
@property (nonatomic,retain)RadioBtn *jsfs_radioBtn1;       // 结算方式
@property (nonatomic,retain)RadioBtn *jsfs_radioBtn2;
//@property (nonatomic,retain)UILabel *yqfLabel;              // 延期费
@property (nonatomic,retain)TextFieldView *znjTfView;       // 滞纳金
@property (nonatomic,retain)UILabel *xzLabel;               // 续租费
//@property (nonatomic,retain)UILabel *ksLabel;               // 扣损费
@property (nonatomic,retain)TextFieldView *shKFTfView;      // 损坏扣费
@property (nonatomic,retain)UILabel *yjsqLabel;             // 押金收取方式
@property (nonatomic,retain)UITextView *shReasonTfView;     // 损坏原因
@property (nonatomic,retain)UITextView *ghBzTfView;     // 归还备注

@property (nonatomic,retain)GDModel *gdmodel;

@property (nonatomic,retain)NSMutableArray *reasonArr;
+ (YCSHView_V1 *)shareYCSHV1View;
@end
