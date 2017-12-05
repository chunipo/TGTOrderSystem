//
//  YCSHView_V1.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "YCSHView_V1.h"
#import "V1HttpTool.h"
#import "XGGHttpsManager.h"
#import "DefaultWarehoseAPI.h"
static YCSHView_V1 *ycshV1 = nil;

@implementation YCSHView_V1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ycshV1 = self;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
//        [self _initViews];
//        [self _initCloseBtn];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        _reasonArr = [NSMutableArray array];
    }
    return self;
}
+ (YCSHView_V1 *) shareYCSHV1View {
    return ycshV1;
}
- (void)tapAction {
    
    [_ckTfView.textField resignFirstResponder];
    [_sjghTfView.textField resignFirstResponder];
    [_znjTfView.textField resignFirstResponder];
    [_shKFTfView.textField resignFirstResponder];
    [_shReasonTfView resignFirstResponder];
    [_ghBzTfView resignFirstResponder];
}
- (void)setGdmodel:(GDModel *)gdmodel {
    _gdmodel = gdmodel;
    [self _initViews];
    [self _initCloseBtn];
    
    [DefaultWarehoseAPI V1_selcectDefaultWarehouseWithNumber:_gdmodel.equno returnDefaultData:^(NSDictionary *dict) {
        _ckTfView.textField.text = [NSString stringWithFormat:@"%@",dict[@"HostWarehouse"]];
        _ckCode = [NSString stringWithFormat:@"%@",dict[@"code"]];
    }];
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
    _titleLab.backgroundColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.text = @"T1收货";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLab];
    
    [_scrollView addSubview:[self contentView]];
    
    [self initSubmitBtn];
}
- (UIView *)contentView {

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, _bgView.width, 300)];
    
    NSArray *ycLeftName = @[@"设备号",
                            @"结束时间",
                            @"滞纳费用",
                            @"归还仓库",
                            @"设备/SIM卡状态",
                            @"充电插口状态",
                            @"外壳状态",
                            @"充电配件状态",
                            @"数据线",
                            @"皮套状态",
                            @"结算方式",
                            @"扣损费用",
                            @"扣损原因",
                            @"归还备注"];
    UILabel *lab0 = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width/2 ,(0), 130, 50)];
    lab0.font = [UIFont systemFontOfSize:16];
    lab0.text = @"押金收取方式";
    lab0.numberOfLines = 0;
    lab0.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:lab0];
    _yjsqLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab0.right + 15 , lab0.top, (contentView.width - 280)/2 - 30, 50)];
    _yjsqLabel.font = [UIFont systemFontOfSize:15];
    _yjsqLabel.textColor = [UIColor darkGrayColor];
    NSString *depositmode = [NSString stringWithFormat:@"%@",_gdmodel.depositmode];
    if ([depositmode isEqualToString:@"CSTCHANNELREC"]) {
        depositmode = @"渠道代收";
    } else if ([depositmode isEqualToString:@"CSTTGTRECEIVE"]) {
        depositmode = @"途鸽代收";
    }
    _yjsqLabel.text = depositmode;
    [contentView addSubview: _yjsqLabel];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width/2 ,(40), 130, 50)];
    lab1.font = [UIFont systemFontOfSize:16];
    lab1.text = @"实际归还日期";
    lab1.numberOfLines = 0;
    lab1.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:lab1];
    _sjghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+12.5, (contentView.width - 280)/2 - 30, 25)];
    [_sjghTfView setTextFieldPlaceholder:@"选择日期"];
    _sjghTfView.textField.delegate = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowtime = [formatter stringFromDate:[NSDate date]];
    _sjghTfView.textField.text = nowtime;
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width/2 ,(80), 130, 50)];
    lab2.font = [UIFont systemFontOfSize:16];
    lab2.text = @"续租费用";
    lab2.numberOfLines = 0;
    lab2.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:lab2];
    NSString *fee_str = [NSString stringWithFormat:@"%@",_gdmodel.extendfee];
    if ([fee_str isEqualToString:@""]||[fee_str isEqualToString:@"(null)"]||[fee_str isEqualToString:@"<null>"]) {
        fee_str = @"无续租费用";
    }
    _xzLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab2.right + 15 , lab2.top, (contentView.width - 280)/2 - 30, 50)];
    _xzLabel.font = [UIFont systemFontOfSize:15];
    _xzLabel.textColor = [UIColor darkGrayColor];
    _xzLabel.text = fee_str;
    [contentView addSubview: _xzLabel];
    
    [contentView addSubview: _sjghTfView];
    
    for (int i = 0; i < ycLeftName.count; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 , i * (40), 130, 50)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = ycLeftName[i];
        lab1.numberOfLines = 0;
        lab1.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:lab1];
        if (i == 13) {
            lab1.top = lab1.top + 30;
        }
        
        switch (i) {
            case 0:{
                
                _snLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top, (contentView.width - 280)/2 - 30, 50)];
                _snLabel.font = [UIFont systemFontOfSize:15];
                _snLabel.textColor = [UIColor darkGrayColor];
                _snLabel.text = [NSString stringWithFormat:@"%@",_gdmodel.equno];
                [contentView addSubview: _snLabel];
        
            }
                break;
            case 1:{
                _jstimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top, (contentView.width - 280)/2 - 30, 50)];
                _jstimeLabel.font = [UIFont systemFontOfSize:15];
                _jstimeLabel.textColor = [UIColor darkGrayColor];
                _jstimeLabel.text = [NSString stringWithFormat:@"%@",[_gdmodel.end_time componentsSeparatedByString:@" "].firstObject];
                [contentView addSubview: _jstimeLabel];
            }
                break;
            case 2:{
                
                _znjTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+12.5, (contentView.width - 280)/2 - 30, 25)];
                _znjTfView.textField.font = [UIFont systemFontOfSize:15];
                _znjTfView.textField.textColor = [UIColor darkGrayColor];
                _znjTfView.textField.text = [NSString stringWithFormat:@""];
                [_znjTfView setTextFieldPlaceholder:@"滞纳费用"];
                _znjTfView.textField.delegate = self;
                [contentView addSubview: _znjTfView];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *nowtime = [formatter stringFromDate:[NSDate date]];
                NSString *end_time = [_gdmodel.end_time componentsSeparatedByString:@" "].firstObject;
                NSString *str = [YCSHView_V1 dateTimeDifferenceWithStartTime:end_time endTime:nowtime];
                _dayStr = str;
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
            case 3:{
                _ckTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+12.5, (contentView.width - 280)/2 - 30, 25)];
                [_ckTfView setTextFieldPlaceholder:@"收货仓库"];
                _ckTfView.textField.delegate = self;
                [contentView addSubview: _ckTfView];
            }
                break;
            case 4:{
                
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
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：500元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 5:{
                
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
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：200元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 6:{
                
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
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：100元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 7:{
                
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
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：25元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 8:{
                
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
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：25元";
                [contentView addSubview:label_price];
            }
                break;
                
            case 9:{
                
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
                
                UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right+250, lab1.top, 150, 50)];
                label_price.font = [UIFont systemFontOfSize:13];
                label_price.textColor = [UIColor darkGrayColor];
                label_price.text = @"*建议赔偿：50元";
                [contentView addSubview:label_price];
            }
                break;
            case 10:{
                
                _jsfs_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                [_jsfs_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"途鸽代收" action:@selector(jsfsAction:)];
//                _jsfs_radioBtn1.btn.selected = YES;
                [contentView addSubview:_jsfs_radioBtn1];
                
                _jsfs_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_jsfs_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                [_jsfs_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"渠道代收" action:@selector(jsfsAction:)];
                [contentView addSubview:_jsfs_radioBtn2];
                
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsfsAction_tap:)];
                [_jsfs_radioBtn1.titleLabel addGestureRecognizer:tap1];
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsfsAction_tap:)];
                [_jsfs_radioBtn2.titleLabel addGestureRecognizer:tap2];
                
                
                NSString *depositmode = [NSString stringWithFormat:@"%@",_gdmodel.depositmode];
                if ([depositmode isEqualToString:@"CSTCHANNELREC"]) {
                    //                    depositmode = @"渠道代收";
                    _jsfs_radioBtn2.btn.selected = YES;
                } else if ([depositmode isEqualToString:@"CSTTGTRECEIVE"]) {
                    //                    depositmode = @"途鸽代收";
                    _jsfs_radioBtn1.btn.selected = YES;
                }
                
            }
                break;
            case 11:{
                _shKFTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+12.5, (contentView.width - 280)/2 - 30, 25)];
                _shKFTfView.textField.font = [UIFont systemFontOfSize:15];
                _shKFTfView.textField.textColor = [UIColor darkGrayColor];
                [_shKFTfView setTextFieldPlaceholder:@"扣损费用"];
                _shKFTfView.textField.delegate = self;
                [contentView addSubview: _shKFTfView];
                _shKFTfView.textField.text = @"0.00";
                /*
                 _yqzt_radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 30 , lab1.top, 80, lab1.height)];
                 [_yqzt_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"正常" action:@selector(yqztAction:)];
                 _yqzt_radioBtn1.btn.selected = YES;
                 [contentView addSubview:_yqzt_radioBtn1];
                 
                 _yqzt_radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_yqzt_radioBtn1.right + 20 , lab1.top, 80, lab1.height)];
                 [_yqzt_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"滞纳" action:@selector(yqztAction:)];
                 [contentView addSubview:_yqzt_radioBtn2];
                 
                 UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yqztAction_tap:)];
                 [_yqzt_radioBtn1.titleLabel addGestureRecognizer:tap1];
                 
                 UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yqztAction_tap:)];
                 [_yqzt_radioBtn2.titleLabel addGestureRecognizer:tap2];
                 */
            }
                break;
            case 12: {
                
                _shReasonTfView = [[UITextView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+10, contentView.width - 280 - 30, 60)];
                _shReasonTfView.layer.borderWidth = 1;
                _shReasonTfView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _shReasonTfView.backgroundColor = [UIColor whiteColor];
                _shReasonTfView.layer.cornerRadius = 5;
                _shReasonTfView.layer.masksToBounds = YES;
                _shReasonTfView.font = [UIFont systemFontOfSize:15];
                _shReasonTfView.text = @"设备完好";
                _shReasonTfView.delegate = self;
                [contentView addSubview: _shReasonTfView];
                [self reloadKsReason];
            }
                break;
            case 13: {
                
                _ghBzTfView = [[UITextView alloc] initWithFrame:CGRectMake(lab1.right + 15 , lab1.top+10, contentView.width - 280 - 30, 60)];
                _ghBzTfView.layer.borderWidth = 1;
                _ghBzTfView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _ghBzTfView.backgroundColor = [UIColor whiteColor];
                _ghBzTfView.layer.cornerRadius = 5;
                _ghBzTfView.layer.masksToBounds = YES;
                _ghBzTfView.delegate = self;
                _ghBzTfView.font = [UIFont systemFontOfSize:15];
                [contentView addSubview: _ghBzTfView];
            }
                break;
                
            default:
                break;
        }

    }
    
    // 新增实际费用
    UILabel *paylab = [[UILabel alloc] initWithFrame:CGRectMake(10 + 1 % 2 * (115 + (contentView.width - 280)/2), 40*11, 130, 50)];
    paylab.font = [UIFont systemFontOfSize:16];
    paylab.text = @"实际支付";
    paylab.numberOfLines = 0;
    paylab.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:paylab];
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(paylab.right + 15 , paylab.top+12.5, (contentView.width - 280)/2 - 30, 25)];
    _payLabel.font = [UIFont systemFontOfSize:15];
    _payLabel.textColor = [UIColor darkGrayColor];
    [contentView addSubview: _payLabel];
    _payLabel.text = [self actualpayment];
    
    contentView.height = _bgView.height - 120;
    return contentView;
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

#pragma mark - V1收货
- (void)submitAction:(UIButton *)button {
    
    NSString *sjgh_time = _sjghTfView.textField.text;
    if (sjgh_time.length == 0) {
        // 请填写实际归还时间
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写实际归还时间" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    if (_jsfs_radioBtn1.btn.selected == NO && _jsfs_radioBtn2.btn.selected == NO) {
        // 请选择结算方式
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择结算方式" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
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
    // 仓库名
    NSString *ck_str1 = [_ckTfView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *v1_list = [CkSelectView shareckSelectView].v1List;
    NSString *ck_code;
    if (v1_list == nil) {
        ck_code = _ckCode;
    } else {
        for (NSDictionary *ck_dic in v1_list) {
            if ([ck_str1 isEqualToString:[NSString stringWithFormat:@"%@",ck_dic[@"name"]]]) {
                ck_code = [NSString stringWithFormat:@"%@",ck_dic[@"code"]];
            }
        }
    }
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    
    NSString *sn_str = _snLabel.text;
    NSString *shck_str = ck_code;
    NSString *name_str = creator;
    NSString *sim_str = @"";
    NSString *ck_str = @"";
    NSString *wk_str = @"";
    NSString *pj_str = @"";
    NSString *sjx_str = @"";
    NSString *pt_str = @"";
    NSString *yqzt_str = @"";
    NSString *yqf_str = _znjTfView.textField.text;
    NSString *jsfs_str = @"";
    NSString *bz_str = _shReasonTfView.text;
    NSString *damageTotalMoney = _shKFTfView.textField.text;
    
    if (_sim_radioBtn1.btn.selected == YES) {
        sim_str = @"1";
    } else {
        sim_str = @"3";
    }
    if (_ck_radioBtn1.btn.selected == YES) {
        ck_str = @"1";
    } else {
        ck_str = @"2";
    }
    if (_wk_radioBtn1.btn.selected == YES) {
        wk_str = @"1";
    } else {
        wk_str = @"2";
    }
    if (_pj_radioBtn1.btn.selected == YES) {
        pj_str = @"1";
    } else {
        pj_str = @"2";
    }
    if (_sjx_radioBtn1.btn.selected == YES) {
        sjx_str = @"1";
    } else {
        sjx_str = @"2";
    }
    if (_pt_radioBtn1.btn.selected == YES) {
        pt_str = @"1";
    } else {
        pt_str = @"2";
    }
    if (_yqzt_radioBtn1.btn.selected == YES) {
        yqzt_str = @"1";
    } else {
        yqzt_str = @"2";
    }
    if (_jsfs_radioBtn1.btn.selected == YES) {
        jsfs_str = @"1";
    } else {
        jsfs_str = @"2";
    }
    
    bool bool_chargingSocketStatus = true;
    bool bool_shellStatus = true;
    bool bool_chargingHeadStatus = true;
    bool bool_dataLineStatus = true;
    bool bool_holsterStatus = true;
    bool bool_demurrageStatus = true;
    NSInteger equSimStatus = [sim_str integerValue];
    if ([ck_str isEqualToString:@"2"]) {
        bool_chargingSocketStatus = false;
    }
    if ([wk_str isEqualToString:@"2"]) {
        bool_shellStatus = false;
    }
    if ([pj_str isEqualToString:@"2"]) {
        bool_chargingHeadStatus = false;
    }
    if ([sjx_str isEqualToString:@"2"]) {
        bool_dataLineStatus = false;
    }
    if ([pt_str isEqualToString:@"2"]) {
        bool_holsterStatus = false;
    }
    if ([yqzt_str isEqualToString:@"2"]) {
        bool_demurrageStatus = false;
    }
    NSString *settleType = @"CHANNE";
    if ([jsfs_str isEqualToString:@"1"]) {
        settleType = @"TUGE";
    }
    NSString *actualPayment;
    if ([_payLabel.text isEqualToString:@""]||[_payLabel.text isEqualToString:@"(null)"]||[_payLabel.text isEqualToString:@"<null>"]) {
        actualPayment = @"";
    } else {
        actualPayment = _payLabel.text;
    }
    
    NSDictionary *dic = @{@"sn":sn_str,
                          @"rebackWh":shck_str,
                          @"rebackUser":name_str,
                          @"equSimStatus":@(equSimStatus),
                          @"chargingSocketStatus":@(bool_chargingSocketStatus),
                          @"shellStatus":@(bool_shellStatus),
                          @"chargingHeadStatus":@(bool_chargingHeadStatus),
                          @"dataLineStatus":@(bool_dataLineStatus),
                          @"holsterStatus":@(bool_holsterStatus),
                          @"demurrageStatus":@(bool_demurrageStatus),
                          @"demurrage":@([yqf_str doubleValue]),
                          @"demurrageDay":@([_dayStr intValue]),
                          @"settleType":settleType,
                          @"note":bz_str,
                          @"damageTotalMoney":@([damageTotalMoney doubleValue]),
                          @"explain":_ghBzTfView.text,
                          @"actualPayment":actualPayment};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *keyStr = [V1HttpTool getKey];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.reback",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        [hud hideAnimated:YES];
        if ([dict[@"code"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ycshwc" object:nil];
            [self hideView];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [hud hideAnimated:YES];
    }];
}
#pragma mark - 点击方法
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
- (void)yqztAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView ==  _yqzt_radioBtn1.btn) {
            _yqzt_radioBtn1.btn.selected = YES;
            _yqzt_radioBtn2.btn.selected = NO;
        } else if (subView == _yqzt_radioBtn2.btn) {
            _yqzt_radioBtn2.btn.selected = YES;
            _yqzt_radioBtn1.btn.selected = NO;
        }
    }
}
- (void)yqztAction:(UIButton *)sender {
    
    if (sender == _yqzt_radioBtn1.btn) {
        _yqzt_radioBtn1.btn.selected = YES;
        _yqzt_radioBtn2.btn.selected = NO;
    } else {
        _yqzt_radioBtn2.btn.selected = YES;
        _yqzt_radioBtn1.btn.selected = NO;
    }
}
- (void)jsfsAction_tap:(UITapGestureRecognizer *)tap {
    NSArray *subViews = tap.view.superview.subviews;
    for (UIView *subView in subViews) {
        if (subView ==  _jsfs_radioBtn1.btn) {
            _jsfs_radioBtn1.btn.selected = YES;
            _jsfs_radioBtn2.btn.selected = NO;
        } else if (subView == _jsfs_radioBtn2.btn) {
            _jsfs_radioBtn2.btn.selected = YES;
            _jsfs_radioBtn1.btn.selected = NO;
        }
    }
}
- (void)jsfsAction:(UIButton *)sender {
    
    if (sender == _jsfs_radioBtn1.btn) {
        _jsfs_radioBtn1.btn.selected = YES;
        _jsfs_radioBtn2.btn.selected = NO;
    } else {
        _jsfs_radioBtn2.btn.selected = YES;
        _jsfs_radioBtn1.btn.selected = NO;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self tapAction];
    if (textField == _sjghTfView.textField) {
        [self selectDateFormCalenarViewwithReloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
            NSString *end_time = [_gdmodel.end_time componentsSeparatedByString:@" "].firstObject;
            NSString *str = [YCSHView_V1 dateTimeDifferenceWithStartTime:end_time endTime:selectStr];
            _dayStr = str;
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
        seleCtView = [[CkSelectView alloc] initWithFrame:CGRectMake(0, _bgView.height - 250, _bgView.width, 250) WithTitle:@"收货仓库" formPage:@"V1_ycsh" number:_gdmodel.equno];
        [_bgView addSubview:seleCtView];
        return NO;
    } else {
    return YES;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _znjTfView.textField || textField == _shKFTfView.textField) {
        _payLabel.text = [self actualpayment];
        [self reloadKsReason];
        return YES;
    } else {
        return NO;
    }
}

- (void)reloadKsReason {

    NSString *simStatus;
    NSString *ckStatus;
    NSString *wkStatus;
    NSString *cdtStatus;
    NSString *sjxStatus;
    NSString *ptStatus;
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
        extendfee = [NSString stringWithFormat:@",续租费用%@",extendfee_str];
    } else {
        extendfee = @"";
    }
    NSString *znj_reason;
    NSString *znj_str = [NSString stringWithFormat:@"%@",_znjTfView.textField.text];
    CGFloat znj_float = [znj_str floatValue];
    if (znj_float != 0) {
        znj_reason = [NSString stringWithFormat:@",滞纳费用%@",znj_str];
    }else {
        znj_reason = @"";
    }
    NSString *add_reason = [NSString stringWithFormat:@"%@%@",znj_reason,extendfee];
    // 计算逻辑
    NSString *reason_str = @"";
    float fee = 0;
    if ([simStatus isEqualToString:@"0"]) {
        reason_str = @"设备终端或SIM卡不完好，扣除费用500";
        _shReasonTfView.text = [reason_str stringByAppendingString:add_reason];
        _shKFTfView.textField.text = @"500";
        _payLabel.text = [self actualpayment];
        return;
    }
    if ([ckStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@,",reason_str,@"充电插口损毁"];
        fee += 200;
    }
    if ([wkStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@,",reason_str,@"外壳损毁"];
        fee += 100;
    }
    if ([cdtStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@,",reason_str,@"充电头损毁"];
        fee += 25;
    }
    if ([sjxStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@,",reason_str,@"数据线损毁"];
        fee += 25;
    }
    if ([ptStatus isEqualToString:@"0"]) {
        reason_str = [NSString stringWithFormat:@"%@%@,",reason_str,@"皮套损毁"];
        fee += 50;
    }
    if ([ptStatus isEqualToString:@"1"]&&[sjxStatus isEqualToString:@"1"]&&[wkStatus isEqualToString:@"1"]&&[cdtStatus isEqualToString:@"1"]&&[simStatus isEqualToString:@"1"]&&[ckStatus isEqualToString:@"1"]) {
        reason_str = @"设备完好";
        _shReasonTfView.text = [reason_str stringByAppendingString:add_reason];
        _shKFTfView.textField.text = @"0.00";
        _payLabel.text = [self actualpayment];
        return;
    }
    _shReasonTfView.text = [NSString stringWithFormat:@"%@ 扣除损坏费用%0.2f%@",reason_str,fee,add_reason];
    _shKFTfView.textField.text = [NSString stringWithFormat:@"%0.2f",fee];
    _payLabel.text = [self actualpayment];
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
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:.25 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 180);
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
