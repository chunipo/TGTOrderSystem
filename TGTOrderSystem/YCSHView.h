//
//  YCSHView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioBtn.h"
#import "TextFieldView.h"
#import "CkSelectView.h"
#import "YCTableView.h"
#import "GDModel.h"

typedef void (^ReloadSelectBlock)(NSString *selectStr);

@interface YCSHView : UIView <UITextFieldDelegate,UITextViewDelegate>
{
    CkSelectView *seleCtView;
    YCTableView *_ycTableView;
    UIScrollView *_scrollView;
    UILabel *_noteLab;
}
@property (nonatomic,retain)UILabel *titleLab;
@property (nonatomic,retain)UIView *bgView;

@property (nonatomic,retain)UILabel *snLabel;               //sn
@property (nonatomic,retain)RadioBtn *radioBtn1;
@property (nonatomic,retain)TextFieldView *sjghTfView;      // 实际归还日期
@property (nonatomic,retain)TextFieldView *znjTfView;       // 滞纳金
@property (nonatomic,retain)UILabel *jstimeLabel;           // 结束时间
@property (nonatomic,retain)TextFieldView *ghReasonTfView;  // 归还原因
@property (nonatomic,retain)UITextView *shReasonTfView;     // 损坏原因
@property (nonatomic,retain)TextFieldView *shKFTfView;      // 损坏扣费
@property (nonatomic,retain)UILabel *payLabel;       // 实际扣费
@property (nonatomic,retain)RadioBtn *radioBtn2;            // 途鸽已收
@property (nonatomic,retain)RadioBtn *radioBtn3;            // 渠道代收
@property (nonatomic,retain)TextFieldView *ckTfView;        // 收货仓库
@property (nonatomic,retain)TextFieldView *fckTfView;       // 收货分仓库
@property (nonatomic,retain)UILabel *yjsqLabel;             // 押金收取方式
@property (nonatomic,retain)UILabel *xzLabel;               // 续租费用
@property (nonatomic,retain)UITextView *bzTextView;         // 工单备注
@property (nonatomic,retain)GDModel *gdmodel;

@property (nonatomic,retain)RadioBtn *screen_radioBtn1;        // 设备屏幕
@property (nonatomic,retain)RadioBtn *screen_radioBtn2;
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

@property (nonatomic,copy)NSString *orderNote;
+ (YCSHView *)shareYCSHView;
@end
