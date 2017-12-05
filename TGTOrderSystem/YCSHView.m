//
//  YCSHView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "YCSHView.h"
#import "CalendarView.h"
#import "V1HttpTool.h"
#import "DefaultWarehoseAPI.h"

static YCSHView *ycsh = nil;
@implementation YCSHView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ycsh = self;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
+ (YCSHView *)shareYCSHView {
    return ycsh;
}
- (void)setGdmodel:(GDModel *)gdmodel {
    _gdmodel = gdmodel;
    [self _initViews];
    [self _initCloseBtn];
    [DefaultWarehoseAPI V2_selcectDefaultWarehouseWithNumber:_gdmodel.number returnDefaultData:^(NSDictionary *dict) {
        _ckTfView.textField.text = [NSString stringWithFormat:@"%@",dict[@"HostWarehouse"]];
        _fckTfView.textField.text = [NSString stringWithFormat:@"%@",dict[@"SubWarehouse"]];
    }];
}
- (void)tapAction {
    
    [self.sjghTfView.textField resignFirstResponder];
    [self.znjTfView.textField resignFirstResponder];
    [self.ghReasonTfView.textField resignFirstResponder];
    [self.shReasonTfView resignFirstResponder];
    [self.shKFTfView.textField resignFirstResponder];
    [self.ckTfView.textField resignFirstResponder];
    [self.fckTfView.textField resignFirstResponder];
    [_bzTextView resignFirstResponder];
}
- (void)_initCloseBtn {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 50-33, 65, 50, 50)];
    imgView.image = [UIImage imageNamed:@"guanbi@2x"];
    imgView.layer.cornerRadius = 25;
    imgView.layer.masksToBounds = YES;
    [self addSubview:imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap];
}
#pragma mark - hideView
- (void)hideView {
    [self removeFromSuperview];
}
- (void)_initViews {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, KScreenWidth - 100, KScreenHeight - 200)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, _bgView.height - 50)];
    [_bgView addSubview:_scrollView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, 50)];
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.backgroundColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLab];
    
    [_scrollView addSubview:[self contentView]];
//    [self _initTableView];
    [self initSubmitBtn];
}
//CO-16090600004
- (UIView *)contentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, _bgView.width, 400)];
    
    NSArray *leftUpName = @[@"设备号",@"押金收取方式",
                            @"结束时间",@"实际归还日期",
                            @"滞纳费用",@"续租费用",
                            @"收货仓库",@"收货分仓库"];
    NSArray *leftBottomName = @[@"设备/SIM卡状态",
                                @"设备屏幕状态",
                                @"充电插口状态",
                                @"外壳状态",
                                @"充电配件状态",
                                @"数据线",
                                @"皮套状态",
                                @"结算方式",
                                @"扣损费用",
                                @"扣损原因",
                                @"工单备注",
                                @"订单备注"];
    
    for (int i = 0; i < leftUpName.count; i ++) {
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (contentView.width - 280)/2), i / 2 * (40), 130, 40)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = leftUpName[i];
        lab1.numberOfLines = 0;
        lab1.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:lab1];
        switch (i) {
            case 0: {
                _snLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                _snLabel.font = [UIFont systemFontOfSize:15];
                _snLabel.textColor = [UIColor darkGrayColor];
                _snLabel.text = [NSString stringWithFormat:@"%@",_gdmodel.equno];
                [contentView addSubview: _snLabel];
            }
                break;
            case 1: {
                
                _yjsqLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                _yjsqLabel.font = [UIFont systemFontOfSize:15];
                _yjsqLabel.textColor = [UIColor darkGrayColor];
                NSString *depositmode = [NSString stringWithFormat:@"%@",_gdmodel.depositmode];
                if ([depositmode isEqualToString:@"CSTCHANNELREC"]) {
                    depositmode = @"渠道代收";
                } else if ([depositmode isEqualToString:@"CSTTGTRECEIVE"]) {
                    depositmode = @"途鸽代收";
                } else if ([depositmode isEqualToString:@""]||[depositmode isEqualToString:@"<null>"] ||[depositmode isEqualToString:@"(null)"]) {
                    depositmode = @"无";
                }
                _yjsqLabel.text = depositmode;
                [contentView addSubview: _yjsqLabel];
            }
                break;
            case 2: {
                
                _jstimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                _jstimeLabel.font = [UIFont systemFontOfSize:15];
                _jstimeLabel.textColor = [UIColor darkGrayColor];
                _jstimeLabel.text = [NSString stringWithFormat:@"%@",[_gdmodel.end_time componentsSeparatedByString:@" "].firstObject];
                [contentView addSubview: _jstimeLabel];
            }
                break;
            case 3: {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *nowtime = [formatter stringFromDate:[NSDate date]];
                _sjghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                [_sjghTfView setTextFieldPlaceholder:@"选择日期"];
                _sjghTfView.textField.delegate = self;
                _sjghTfView.textField.text = nowtime;
                [contentView addSubview: _sjghTfView];
            }
                break;
            case 4: {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *nowtime = [formatter stringFromDate:[NSDate date]];
                _znjTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                [_znjTfView setTextFieldPlaceholder:@"滞纳金"];
                _znjTfView.textField.delegate = self;
                [contentView addSubview: _znjTfView];
                NSString *end_time = [_gdmodel.end_time componentsSeparatedByString:@" "].firstObject;
                NSString *str = [YCSHView dateTimeDifferenceWithStartTime:end_time endTime:nowtime];
                float str_num = [str floatValue];
                if (str_num > 6) {
                    _znjTfView.textField.text = @"500.00";
                } else {
                    float dayFee = str_num * [_gdmodel.defaultnotusefee floatValue];
                    _znjTfView.textField.text = [NSString stringWithFormat:@"%.2f",dayFee];
                }
                _payLabel.text = [self actualpayment];
            }
                break;
            case 5: {
                
                NSString *fee_str = [NSString stringWithFormat:@"%@",_gdmodel.extendfee];
                if ([fee_str isEqualToString:@""]||[fee_str isEqualToString:@"(null)"]||[fee_str isEqualToString:@"<null>"]) {
                    fee_str = @"无续租费用";
                }
                
                _xzLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top, (contentView.width - 280)/2 - 30, 40)];
                _xzLabel.font = [UIFont systemFontOfSize:15];
                _xzLabel.textColor = [UIColor darkGrayColor];
                _xzLabel.text = fee_str;
                [contentView addSubview: _xzLabel];
                
            }
                break;
            case 6: {
                _ckTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                [_ckTfView setTextFieldPlaceholder:@"收货仓库"];
                _ckTfView.textField.delegate = self;
                [contentView addSubview: _ckTfView];
            }
                break;
            case 7: {
                _fckTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                [_fckTfView setTextFieldPlaceholder:@"收货分仓库"];
                _fckTfView.textField.delegate = self;
                [contentView addSubview: _fckTfView];
            }
                break;
        }
    }
    
    for (int i = 0; i < leftBottomName.count; i ++) {
        
        float height_top;
        if (i >= 8) {
            switch (i) {
                case 8:
//                    height_top = (i-1)*40;
                    height_top = (i)*40;
                    break;
                case 9:
//                    height_top = (i-1)*40;
                    height_top = (i)*40;
                    break;
                case 10:
//                    height_top = (i-2)*40+80;
                    height_top = (i-1)*40+80;
                    break;
                case 11:
//                    height_top = (i-2)*40+80+10;
                    height_top = (i-1)*40+80+10;
                    break;
                default:
                    break;
            }
        } else {
            height_top = i*40;
        }
        
//        int j = i==8 ? 1 : 0;
        int j = i==8 ? 0 : 0;
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + j % 2 * (115 + (contentView.width - 280)/2), 160 + height_top, 130, 40)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = leftBottomName[i];
        lab1.numberOfLines = 0;
        lab1.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:lab1];
        switch (i) {
            case 1: {
                _screen_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_screen_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(screenAction:)];
                _screen_radioBtn1.btn.selected = YES;
                [contentView addSubview:_screen_radioBtn1];
                
                _screen_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_screen_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_screen_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(screenAction:)];
                [contentView addSubview:_screen_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenAction_tap:)];
                [_screen_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenAction_tap:)];
                [_screen_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：200元";
                [contentView addSubview:label_price];
            }
                break;
            case 0:{
                
                _sim_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_sim_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(simAction:)];
                _sim_radioBtn1.btn.selected = YES;
                [contentView addSubview:_sim_radioBtn1];
                
                _sim_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_sim_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_sim_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(simAction:)];
                [contentView addSubview:_sim_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simAction_tap:)];
                [_sim_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simAction_tap:)];
                [_sim_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：500元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 2:{
                
                _ck_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_ck_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(ckAction:)];
                _ck_radioBtn1.btn.selected = YES;
                [contentView addSubview:_ck_radioBtn1];
                
                _ck_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_ck_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_ck_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(ckAction:)];
                [contentView addSubview:_ck_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ckAction_tap:)];
                [_ck_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ckAction_tap:)];
                [_ck_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：200元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 3:{
                
                _wk_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_wk_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(wkAction:)];
                _wk_radioBtn1.btn.selected = YES;
                [contentView addSubview:_wk_radioBtn1];
                
                _wk_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_wk_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_wk_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(wkAction:)];
                [contentView addSubview:_wk_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wkAction_tap:)];
                [_wk_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wkAction_tap:)];
                [_wk_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：100元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 4:{
                
                _pj_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_pj_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(pjAction:)];
                _pj_radioBtn1.btn.selected = YES;
                [contentView addSubview:_pj_radioBtn1];
                
                _pj_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_pj_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_pj_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(pjAction:)];
                [contentView addSubview:_pj_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pjAction_tap:)];
                [_pj_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pjAction_tap:)];
                [_pj_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：25元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 5:{
                
                _sjx_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_sjx_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(sjxAction:)];
                _sjx_radioBtn1.btn.selected = YES;
                [contentView addSubview:_sjx_radioBtn1];
                
                _sjx_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_sjx_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_sjx_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(sjxAction:)];
                [contentView addSubview:_sjx_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sjxAction_tap:)];
                [_sjx_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sjxAction_tap:)];
                [_sjx_radioBtn2.titleLabel addGestureRecognizer:tap2];
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：25元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 6:{
                
                _pt_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_pt_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"完好" action:@selector(ptAction:)];
                _pt_radioBtn1.btn.selected = YES;
                [contentView addSubview:_pt_radioBtn1];
                
                _pt_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_pt_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_pt_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"损毁" action:@selector(ptAction:)];
                [contentView addSubview:_pt_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptAction_tap:)];
                [_pt_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ptAction_tap:)];
                [_pt_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 40)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：50元";
                [contentView addSubview:label_price];
            }
                break;
            case 7: {
                _radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"途鸽已收" action:@selector(t2Action:)];
                _radioBtn3 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_radioBtn3 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"渠道代收" action:@selector(t2Action:)];
//                [contentView addSubview:_radioBtn2];
                [contentView addSubview:_radioBtn3];
                
                NSString *depositmode = [NSString stringWithFormat:@"%@",_gdmodel.depositmode];
                if ([depositmode isEqualToString:@"CSTCHANNELREC"]) {
                    //                    depositmode = @"渠道代收";
                    _radioBtn3.btn.selected = YES;
                } else if ([depositmode isEqualToString:@"CSTTGTRECEIVE"]) {
                    //                    depositmode = @"途鸽代收";
                    _radioBtn2.btn.selected = YES;
                }
                
                // 滞纳金 续租费用 扣损费用均无的情况下，隐藏续租费用按钮
                
            }
                break;
            case 8: {
                
                _shKFTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
                [_shKFTfView setTextFieldPlaceholder:@"设备损坏扣费"];
                _shKFTfView.textField.delegate = self;
                [contentView addSubview: _shKFTfView];
                _shKFTfView.textField.text = @"0.00";
            }
                break;
            
            case 9: {
                _shReasonTfView = [[UITextView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+5, contentView.width - 280 - 30, 70)];
                _shReasonTfView.layer.borderWidth = 1;
                _shReasonTfView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _shReasonTfView.backgroundColor = [UIColor whiteColor];
                _shReasonTfView.layer.cornerRadius = 5;
                _shReasonTfView.layer.masksToBounds = YES;
                _shReasonTfView.delegate = self;
                _shReasonTfView.font = [UIFont systemFontOfSize:15];
                _shReasonTfView.text = @"设备完好";
                [contentView addSubview: _shReasonTfView];
                
                [self reloadKsReason];
                
            }
                break;
            case 10: {
                
                _bzTextView = [[UITextView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top, contentView.width - 280 - 30, 38)];
                _bzTextView.font = [UIFont systemFontOfSize:15];
                _bzTextView.layer.borderWidth = 1;
                _bzTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _bzTextView.layer.cornerRadius = 5;
                _bzTextView.layer.masksToBounds = YES;
                _bzTextView.delegate = self;
                _bzTextView.backgroundColor = [UIColor whiteColor];
                [contentView addSubview: _bzTextView];
            }
                break;
            case 11: {
                
                _noteLab = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top-10, contentView.width - 180 - 30, 60)];
                _noteLab.numberOfLines = 0;
                _noteLab.font = [UIFont systemFontOfSize:14];
                _noteLab.textColor = [UIColor redColor];
//                _noteLab.layer.borderWidth = 1;
//                _noteLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
//                _noteLab.layer.cornerRadius = 5;
//                _noteLab.layer.masksToBounds = YES;
                _noteLab.backgroundColor = [UIColor whiteColor];
                [contentView addSubview: _noteLab];
            }
                break;
        }
    }
    
    // 新增实际费用
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + 1 % 2 * (115 + (contentView.width - 280)/2), 160 + 40*8, 130, 40)];
    lab1.font = [UIFont systemFontOfSize:16];
    lab1.text = @"实际支付";
    lab1.numberOfLines = 0;
    lab1.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:lab1];
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+7.5, (contentView.width - 280)/2 - 30, 25)];
//    [_payTfView setTextFieldPlaceholder:@"实际支付"];
//    _payTfView.textField.delegate = self;
    _payLabel.font = [UIFont systemFontOfSize:15];
    _payLabel.textColor = [UIColor darkGrayColor];
    [contentView addSubview: _payLabel];
    _payLabel.text = [self actualpayment];
    
    contentView.height = 700;
    return contentView;
}
- (void)setOrderNote:(NSString *)orderNote {
    _orderNote = orderNote;
    if ([_orderNote isEqualToString:@"(null)"]) {
        _orderNote = @"";
    }
    _noteLab.text = _orderNote;
//    _noteLab.top = 370 - (_noteLab.height/2);
}

- (void)_initTableView {
    _ycTableView = [[YCTableView alloc] initWithFrame:CGRectMake(0, 460, _bgView.width, _bgView.height - 460 - 60) style:UITableViewStylePlain];
    [_bgView addSubview:_ycTableView];
}
- (void)initSubmitBtn {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, _bgView.height - 45 - 7.5, _bgView.width - 60, 45);
    button.backgroundColor = TITLE_COLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:@"确认收货" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
}
- (void)t1Action:(UIButton *)sender {
    _radioBtn1.btn.selected = !_radioBtn1.btn.selected;
}
- (void)t2Action:(UIButton *)sender {
    
    if (sender == _radioBtn2.btn) {
        _radioBtn2.btn.selected = YES;
        _radioBtn3.btn.selected = NO;
    } else {
        _radioBtn3.btn.selected = YES;
        _radioBtn2.btn.selected = NO;
    }
}

#pragma mark - textFile Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == _noteLab) {
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self tapAction];
    
    if (textField == _sjghTfView.textField) {
        [self selectDateFormCalenarViewwithReloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
            NSString *end_time = [_gdmodel.end_time componentsSeparatedByString:@" "].firstObject;
            NSString *str = [YCSHView dateTimeDifferenceWithStartTime:end_time endTime:selectStr];
            float str_num = [str floatValue];
            if (str_num > 6) {
                _znjTfView.textField.text = @"500.00";
            } else {
                float dayFee = str_num * [_gdmodel.defaultnotusefee floatValue];
                _znjTfView.textField.text = [NSString stringWithFormat:@"%.2f",dayFee];
            }
            _payLabel.text = [self actualpayment];
            [self reloadKsReason];
        }];
        return NO;
    } else if (textField == _ckTfView.textField) {
        [seleCtView removeFromSuperview];
        seleCtView = [[CkSelectView alloc] initWithFrame:CGRectMake(0, _bgView.height - 250, _bgView.width, 250) WithTitle:@"收货仓库" formPage:@"ycsh" number:_gdmodel.number];
        [_bgView addSubview:seleCtView];
        return NO;
    } else if (textField == _fckTfView.textField) {
        [seleCtView removeFromSuperview];
        seleCtView = [[CkSelectView alloc] initWithFrame:CGRectMake(0, _bgView.height - 250, _bgView.width, 250) WithTitle:@"收货分仓库" formPage:@"ycsh" number:_gdmodel.number];
        [_bgView addSubview:seleCtView];
        return NO;
    } else if (textField == _shKFTfView.textField) {
        [UIView animateWithDuration:.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 175);
        }];
        return YES;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == _znjTfView.textField || textField == _shKFTfView.textField) {
        _payLabel.text = [self actualpayment];
        [self reloadKsReason];
        [UIView animateWithDuration:.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int day = (int)value / (24 * 3600) - 2;
    NSString *str;
    if (day != 0) {
        if (day < 0) {
            day = 0;
        }
        str = [NSString stringWithFormat:@"%d",day];
    }
    return str;
}

#pragma mark - 选择日期
- (void)selectDateFormCalenarViewwithReloadSelectBlock:(ReloadSelectBlock)reloadSelectBlock {
    
    CalendarView *calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    calendarView.selectBlock = ^(NSString *str){
        reloadSelectBlock(str);
    };
    [self.superview addSubview:calendarView];
}

- (void)submitAction:(UIButton *)button {
    
    NSString *sjgh_time = _sjghTfView.textField.text;
    if (sjgh_time.length == 0) {
        // 请填写实际归还时间
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写实际归还时间" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    NSString *ck_info = _ckTfView.textField.text;
    if (ck_info.length == 0) {
        // 请选择收货仓库
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择收货仓库" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    NSString *fck_info = _fckTfView.textField.text;
    if (fck_info.length == 0) {
        // 请选择收货仓库
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择收货分仓库" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    if (_radioBtn3.btn.selected == NO && _radioBtn2.btn.selected == NO) {
        // 请选择结算方式
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择结算方式" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    
    NSString *accountId = @"tgt_ipad";
    bool bool_false = false;
    if (_radioBtn1.btn.selected == YES) {
        bool_false = true;
    }
    NSString *settletype = @"";
    if (_radioBtn2.btn.selected == YES) {
        settletype = @"TUGE";
    }
    if (_radioBtn3.btn.selected == YES) {
        settletype = @"CHANNE";
    }
    NSString *xz_fee = @"";
    if ([_xzLabel.text isEqualToString:@"无续租费用"]) {
        xz_fee = @"0";
    } else {
        xz_fee = _xzLabel.text;
    }
    NSString *actual_fee = @"";
    if ([_payLabel.text isEqualToString:@"(null)"]||[_payLabel.text isEqualToString:@"<null>"]||[_payLabel.text isEqualToString:@""]) {
        actual_fee = @"0";
    } else {
        actual_fee = _payLabel.text;
    }
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:@"subWarehouse" forKey:@"subwarehosename"];
    [dataDic setObject:_shReasonTfView.text forKey:@"damagereason"];
    [dataDic setObject:_shKFTfView.textField.text forKey:@"damagemoney"];
    [dataDic setObject:_gdmodel.number forKey:@"number"];
    [dataDic setObject:_sjghTfView.textField.text forKey:@"actreturndate"];
    [dataDic setObject:_znjTfView.textField.text forKey:@"delaynotusefee"];
    [dataDic setObject:_ckTfView.textField.text forKey:@"warehosename"];
    [dataDic setObject:settletype forKey:@"settletype"];
    [dataDic setObject:xz_fee forKey:@"extendfee"];
    [dataDic setObject:@(bool_false) forKey:@"delaynotuseflag"];
    [dataDic setObject:_shReasonTfView.text forKey:@"delayreason"];
    [dataDic setObject:_bzTextView.text forKey:@"orderremark"];
    [dataDic setObject:@"" forKey:@"returndate"];
    [dataDic setObject:actual_fee forKey:@"actualpayment"];
    [dataDic setObject:creator forKey:@"operator"];
    /*  */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    [dataDic setObject:DeviceID forKey:@"code"];
    /*
    NSDictionary *dataDic = @{@"number":@"",
                              @"delaynotuseflag":@(bool_false),                     // 延期未使用
                              @"actreturndate":_sjghTfView.textField.text,          // 实际归还时间
                              @"contactremark":_bzTextView.text,                    // 备注
                              @"returndate":@"",                                    // 寄回时间
                              @"delaynotusefee":_znjTfView.textField.text,          // 滞纳金
                              @"delayreason":_shReasonTfView.text,                  // 设备损坏原因
                              @"damagemoney":_shKFTfView.textField.text,            // 设备损坏扣费
                              @"extendfee":_xzLabel.text,                           // 续租费用
                              @"settletype":settletype,                             // 扣款、滞纳金和续租费用收取方式
                              @"warehosename":_ckTfView.textField.text,             // 主仓库名称（完整主仓库名称）
                              @"subwarehosename":_fckTfView.textField.text          // 分仓库名称（完成分仓库名称）
                              };
     */
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"subWarehouse" withString:_fckTfView.textField.text];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"mobileReceivedOrder",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"accountId":accountId,
                          @"data":dataDic,
                          @"requestTime":@"time_test",
                          @"serviceName":@"mobileReceivedOrder",
                          @"sign":sign_md5,
                          @"version":@"OSSV2"};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    str = [str stringByReplacingOccurrencesOfString:@"subWarehouse" withString:_fckTfView.textField.text];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.mobileReceivedOrder",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ycshwc" object:nil];
                    [self hideView];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    
    [task resume];
    
}

#pragma mark - 点击方法
- (void)screenAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _screen_radioBtn1.btn) {
            _screen_radioBtn1.btn.selected = YES;
            _screen_radioBtn2.btn.selected = NO;
        } else if (subView == _screen_radioBtn2.btn) {
            _screen_radioBtn2.btn.selected = YES;
            _screen_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)screenAction:(UIButton *)sender {
    
    if (sender == _screen_radioBtn1.btn) {
        _screen_radioBtn1.btn.selected = YES;
        _screen_radioBtn2.btn.selected = NO;
    } else  {
        _screen_radioBtn2.btn.selected = YES;
        _screen_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}
- (void)simAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _sim_radioBtn1.btn) {
            _sim_radioBtn1.btn.selected = YES;
            _sim_radioBtn2.btn.selected = NO;
        } else if (subView == _sim_radioBtn2.btn) {
            _sim_radioBtn2.btn.selected = YES;
            _sim_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)simAction:(UIButton *)sender {
    
    if (sender == _sim_radioBtn1.btn) {
        _sim_radioBtn1.btn.selected = YES;
        _sim_radioBtn2.btn.selected = NO;
    } else  {
        _sim_radioBtn2.btn.selected = YES;
        _sim_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}
- (void)ckAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _ck_radioBtn1.btn) {
            _ck_radioBtn1.btn.selected = YES;
            _ck_radioBtn2.btn.selected = NO;
        } else if (subView == _ck_radioBtn2.btn) {
            _ck_radioBtn2.btn.selected = YES;
            _ck_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)ckAction:(UIButton *)sender {
    
    if (sender == _ck_radioBtn1.btn) {
        _ck_radioBtn1.btn.selected = YES;
        _ck_radioBtn2.btn.selected = NO;
    } else {
        _ck_radioBtn2.btn.selected = YES;
        _ck_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}

- (void)wkAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _wk_radioBtn1.btn) {
            _wk_radioBtn1.btn.selected = YES;
            _wk_radioBtn2.btn.selected = NO;
        } else if (subView == _wk_radioBtn2.btn) {
            _wk_radioBtn2.btn.selected = YES;
            _wk_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)wkAction:(UIButton *)sender {
    
    if (sender == _wk_radioBtn1.btn) {
        _wk_radioBtn1.btn.selected = YES;
        _wk_radioBtn2.btn.selected = NO;
    } else {
        _wk_radioBtn2.btn.selected = YES;
        _wk_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}

- (void)pjAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _pj_radioBtn1.btn) {
            _pj_radioBtn1.btn.selected = YES;
            _pj_radioBtn2.btn.selected = NO;
        } else if (subView == _pj_radioBtn2.btn) {
            _pj_radioBtn2.btn.selected = YES;
            _pj_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)pjAction:(UIButton *)sender {
    
    if (sender == _pj_radioBtn1.btn) {
        _pj_radioBtn1.btn.selected = YES;
        _pj_radioBtn2.btn.selected = NO;
    } else {
        _pj_radioBtn2.btn.selected = YES;
        _pj_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}
- (void)sjxAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView == _sjx_radioBtn1.btn) {
            _sjx_radioBtn1.btn.selected = YES;
            _sjx_radioBtn2.btn.selected = NO;
        } else if (subView == _sjx_radioBtn2.btn) {
            _sjx_radioBtn2.btn.selected = YES;
            _sjx_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)sjxAction:(UIButton *)sender {
    
    if (sender == _sjx_radioBtn1.btn) {
        _sjx_radioBtn1.btn.selected = YES;
        _sjx_radioBtn2.btn.selected = NO;
    } else {
        _sjx_radioBtn2.btn.selected = YES;
        _sjx_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}
- (void)ptAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView ==  _pt_radioBtn1.btn) {
            _pt_radioBtn1.btn.selected = YES;
            _pt_radioBtn2.btn.selected = NO;
        } else if (subView == _pt_radioBtn2.btn) {
            _pt_radioBtn2.btn.selected = YES;
            _pt_radioBtn1.btn.selected = NO;
        }
    }
    [self reloadKsReason];
}
- (void)ptAction:(UIButton *)sender {
    
    if (sender == _pt_radioBtn1.btn) {
        _pt_radioBtn1.btn.selected = YES;
        _pt_radioBtn2.btn.selected = NO;
    } else {
        _pt_radioBtn2.btn.selected = YES;
        _pt_radioBtn1.btn.selected = NO;
    }
    [self reloadKsReason];
}
- (void)reloadKsReason {
    
    NSString *screenStatus;
    NSString *simStatus;
    NSString *ckStatus;
    NSString *wkStatus;
    NSString *cdtStatus;
    NSString *sjxStatus;
    NSString *ptStatus;
    // 屏幕
    if (_screen_radioBtn1.btn.selected == YES) {
        screenStatus = @"1";
    }
    if (_screen_radioBtn2.btn.selected == YES) {
        screenStatus = @"0";
    }
    // sim卡/设备
    if (_sim_radioBtn1.btn.selected == YES) {
        simStatus = @"1";
    }
    if (_sim_radioBtn2.btn.selected == YES) {
        simStatus = @"0";
    }
    // 充电插口
    if (_ck_radioBtn1.btn.selected == YES) {
        ckStatus = @"1";
    }
    if (_ck_radioBtn2.btn.selected == YES) {
        ckStatus = @"0";
    }
    // 外壳
    if (_wk_radioBtn1.btn.selected == YES) {
        wkStatus = @"1";
    }
    if (_wk_radioBtn2.btn.selected == YES) {
        wkStatus = @"0";
    }
    // 充电头
    if (_pj_radioBtn1.btn.selected == YES) {
        cdtStatus = @"1";
    }
    if (_pj_radioBtn2.btn.selected == YES) {
        cdtStatus = @"0";
    }
    // 数据线
    if (_sjx_radioBtn1.btn.selected == YES) {
        sjxStatus = @"1";
    }
    if (_sjx_radioBtn2.btn.selected == YES) {
        sjxStatus = @"0";
    }
    // 皮套
    if (_pt_radioBtn1.btn.selected == YES) {
        ptStatus = @"1";
    }
    if (_pt_radioBtn2.btn.selected == YES) {
        ptStatus = @"0";
    }
    NSString *extendfee;
    NSString *extendfee_str = [NSString stringWithFormat:@"%@",_gdmodel.extendfee];
    CGFloat extendfee_float = [extendfee_str floatValue];
    if (extendfee_float != 0) {
        extendfee = [NSString stringWithFormat:@"续租费用%@；",extendfee_str];
    } else {
        extendfee = @"";
    }
    NSString *znj_reason;
    NSString *znj_str = [NSString stringWithFormat:@"%@",_znjTfView.textField.text];
    CGFloat znj_float = [znj_str floatValue];
    if (znj_float != 0) {
        znj_reason = [NSString stringWithFormat:@"滞纳费用%@；",znj_str];
    }else {
        znj_reason = @"";
    }
    NSString *add_reason = [NSString stringWithFormat:@"%@%@",znj_reason,extendfee];
    
    // 计算逻辑
    NSString *reason_str = @"";
    float fee = 0;
    if ([simStatus isEqualToString:@"0"]) {
        reason_str = @"设备终端或SIM卡不完好，扣除费用500；";
        _shReasonTfView.text = [reason_str stringByAppendingString:add_reason];
        _shKFTfView.textField.text = @"500";
        _payLabel.text = [self actualpayment];
        return;
    }
    if ([screenStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"设备屏幕损毁200.00；"];
        fee += 200;
    }
    if ([ckStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"充电插口损毁200.00；"];
        fee += 200;
    }
    if ([wkStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"外壳损毁100.00；"];
        fee += 100;
    }
    if ([cdtStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"充电配件损毁25.00；"];
        fee += 25;
    }
    if ([sjxStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"数据线损毁25.00；"];
        fee += 25;
    }
    if ([ptStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@",reason_str,@"皮套损毁50.00；"];
        fee += 50;
    }
    if ([screenStatus isEqualToString:@"1"]&&[ptStatus isEqualToString:@"1"]&&[sjxStatus isEqualToString:@"1"]&&[wkStatus isEqualToString:@"1"]&&[cdtStatus isEqualToString:@"1"]&&[simStatus isEqualToString:@"1"]&&[ckStatus isEqualToString:@"1"]) {
        reason_str = @"设备完好；";
        _shReasonTfView.text = [reason_str stringByAppendingString:add_reason];
        _shKFTfView.textField.text = @"0.00";
        _payLabel.text = [self actualpayment];
        return;
    }
    if (fee > 500) {
        fee = 500;
    }
    _shReasonTfView.text = [reason_str stringByAppendingString:add_reason];
    _shKFTfView.textField.text = [NSString stringWithFormat:@"%0.2f",fee];
    _payLabel.text = [self actualpayment];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:.25 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 175);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:.25 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (NSString *)actualpayment {
    
    NSString *fee_str = [NSString stringWithFormat:@"%@",_gdmodel.extendfee];
    CGFloat xzj;
    if ([fee_str isEqualToString:@""]||[fee_str isEqualToString:@"(null)"]||[fee_str isEqualToString:@"<null>"]) {
        xzj = 0;
    } else {
        xzj = [fee_str floatValue];
    }
    CGFloat znj = [_znjTfView.textField.text floatValue];
    CGFloat ksj = [_shKFTfView.textField.text floatValue];
    CGFloat total = znj+xzj+ksj;
    if (total > 500) {
        total = 500;
    }
    NSString *actualPay = [NSString stringWithFormat:@"%0.2f",total];
    return actualPay;
}

@end
