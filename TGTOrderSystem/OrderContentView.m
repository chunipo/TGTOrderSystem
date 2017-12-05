//
//  OrderContentView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderContentView.h"

@implementation OrderContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initDataList];
        [self _initOrderView];
        [self _initQHView];
        [self initfyView];
        [self initdevView];
    }
    return self;
}
- (void)initDataList {

    _orderLeftName = @[@"订单号",@"OTA订单号",@"订单状态",@"T2T1标识",
                  @"商业模式",@"渠道",@"区域",@"目的地国家",
                  @"套餐",@"渠道编号",@"结算人",@"销售员",
                  @"业务部门",@"开始时间",@"套餐天数",@"结束时间"];
    
    _qhLeftName = @[@"取货人姓名",@"取货人电话",@"取货方式",@"订单所属者",
                    @"取件地点名称",@"还件地点名称",@"快递号",@"",
                    @"预计发货日期",@"预计归还日期",@"备注"];
    
    _yjLeftName = @[@"押金收取方式",@"押金",@"套餐支付方式",@"套餐金额",@"取消费用"];
}
- (void)_initOrderView {
    
    // 订单信息
    UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 25)];
    titleLab1.layer.cornerRadius = 2;
    titleLab1.layer.masksToBounds = YES;
    titleLab1.backgroundColor = TITLE_COLOR;
    titleLab1.textAlignment = NSTextAlignmentCenter;
    titleLab1.font = [UIFont systemFontOfSize:16];
    titleLab1.textColor = [UIColor whiteColor];
    titleLab1.text = @"订单信息";
    [self addSubview:titleLab1];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, KScreenWidth - 25, 1)];
    line1.backgroundColor = TITLE_COLOR;
    [self addSubview:line1];
    UIColor *rightTitleColor = [UIColor grayColor];
    // 订单号
    for (int i = 0; i < 16; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (KScreenWidth - 240)/2), line1.bottom + 5 + i / 2 * (30 + 3), 100, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = _orderLeftName[i];
        lab1.textAlignment = NSTextAlignmentRight;
        [self addSubview:lab1];
        
        switch (i) {
            case 0: {
                
                _oderNo = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _oderNo.font = [UIFont systemFontOfSize:15];
                _oderNo.text = @"CO-16051100001";
                _oderNo.textColor = rightTitleColor;
                [self addSubview:_oderNo];
            }
                break;
            case 1: {
                
                _otaTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_otaTfView setTextFieldPlaceholder:@"OTA订单号"];
                [self addSubview: _otaTfView];
            }
                break;
            case 2: {
                
                _oderStatus = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _oderStatus.font = [UIFont systemFontOfSize:15];
                _oderStatus.text = @"已支付";
                _oderStatus.textColor = rightTitleColor;
                [self addSubview:_oderStatus];
            }
                break;
            case 3: {
                
                _radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 20 , lab1.top, 80, 30)];
                [_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"T1" action:@selector(t1Action:)];
                [self addSubview:_radioBtn1];
                
                _radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_radioBtn1.right , lab1.top, 80, 30)];
                [_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"T2" action:@selector(t2Action:)];
                [self addSubview:_radioBtn2];
            }
                break;
            case 4: {
                
                _orderMode = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _orderMode.font = [UIFont systemFontOfSize:15];
                _orderMode.text = @"租赁";
                _orderMode.textColor = rightTitleColor;
                [self addSubview:_orderMode];
            }
                break;
            case 5: {
                
                _channelTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_channelTfView setTextFieldPlaceholder:@"选择渠道"];
                [self addSubview: _channelTfView];
            }
                break;
            case 6: {
                
                _areaTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_areaTfView setTextFieldPlaceholder:@"选择区域"];
                [self addSubview: _areaTfView];
            }
                break;
            case 7: {
                
                _country = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _country.font = [UIFont systemFontOfSize:15];
                _country.text = @"澳大利亚";
                _country.textColor = rightTitleColor;
                [self addSubview:_country];
            }
                break;
            case 8: {
                
                _packageTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_packageTfView setTextFieldPlaceholder:@"选择套餐"];
                [self addSubview: _packageTfView];
            }
                break;
            case 9: {
                
            }
                break;
            case 10: {
                
            }
                break;
            case 11: {
                
                _salesTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_salesTfView setTextFieldPlaceholder:@"销售员"];
                [self addSubview: _salesTfView];
            }
                break;
            case 12: {
                
                _departmentTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_departmentTfView setTextFieldPlaceholder:@"业务部门"];
                [self addSubview: _departmentTfView];
            }
                break;
            case 13: {
                
                _startTimeTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_startTimeTfView setTextFieldPlaceholder:@"开始时间"];
                [self addSubview: _startTimeTfView];
            }
                break;
            case 14: {
                
                _daysTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_daysTfView setTextFieldPlaceholder:@"套餐天数"];
                _daysTfView.textField.keyboardType = UIKeyboardTypeNumberPad;
                [self addSubview: _daysTfView];
            }
                break;
                
            case 15: {
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)_initQHView {
    
    // 取货信息
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,_daysTfView.bottom + 15 , 75, 25)];
    titleLab2.layer.cornerRadius = 2;
    titleLab2.layer.masksToBounds = YES;
    titleLab2.backgroundColor = TITLE_COLOR;
    titleLab2.textAlignment = NSTextAlignmentCenter;
    titleLab2.font = [UIFont systemFontOfSize:16];
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.text = @"取货信息";
    [self addSubview:titleLab2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab2.top + 24, KScreenWidth - 25, 1)];
    line2.backgroundColor = TITLE_COLOR;
    [self addSubview:line2];
    
    for (int i = 0; i < _qhLeftName.count; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (KScreenWidth - 240)/2), line2.bottom + 5 + i / 2 * (30 + 3), 100, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = _qhLeftName[i];
        lab1.textAlignment = NSTextAlignmentRight;
        [self addSubview:lab1];
        if (i == _qhLeftName.count - 1) {
            lab1.height = 80;
        }
        
        switch (i) {
            case 0:{
            
                _nameTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_nameTfView setTextFieldPlaceholder:@"填写取件人姓名"];
                [self addSubview: _nameTfView];
            }
                break;
            case 1:{
                
                _phoneTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_phoneTfView setTextFieldPlaceholder:@"填写取件人电话"];
                [self addSubview: _phoneTfView];
            }
                break;
            case 2:{
                
                _radioBtn3 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 20 , lab1.top, 80, 30)];
                [_radioBtn3 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"邮寄" action:@selector(t3Action:)];
                [self addSubview:_radioBtn3];
                
                _radioBtn4 = [[RadioBtn alloc] initWithFrame:CGRectMake(_radioBtn3.right , lab1.top, 80, 30)];
                [_radioBtn4 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"自提" action:@selector(t4Action:)];
                [self addSubview:_radioBtn4];
            }
                break;
            case 3:{
                
                
            }
                break;
            case 4:{
                
                _qjTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_qjTfView setTextFieldPlaceholder:@"选择取件地点"];
                [self addSubview: _qjTfView];
            }
                break;
            case 5:{
                
                _hjTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_hjTfView setTextFieldPlaceholder:@"选择还件地点"];
                [self addSubview: _hjTfView];
            }
                break;
            case 10:{
                
                _textView = [[UITextView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 100 - 60 - 15), 76)];
                _textView.layer.cornerRadius = 5;
                _textView.font = [UIFont systemFontOfSize:15];
                _textView.layer.masksToBounds = YES;
                _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _textView.layer.borderWidth = 1;
                [self addSubview:_textView];
            }
                break;
            default:
                break;
        }
    }
}

// 押金及套餐费用
- (void)initfyView {

    // 押金及套餐费用
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,_textView.bottom + 15 , 75, 25)];
    titleLab2.layer.cornerRadius = 2;
    titleLab2.layer.masksToBounds = YES;
    titleLab2.backgroundColor = TITLE_COLOR;
    titleLab2.textAlignment = NSTextAlignmentCenter;
    titleLab2.font = [UIFont systemFontOfSize:16];
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.text = @"取货信息";
    [self addSubview:titleLab2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab2.top + 24, KScreenWidth - 25, 1)];
    line2.backgroundColor = TITLE_COLOR;
    [self addSubview:line2];
    
    for (int i = 0; i < _yjLeftName.count; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (KScreenWidth - 240)/2), line2.bottom + 5 + i / 2 * (30 + 3), 100, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = _yjLeftName[i];
        lab1.textAlignment = NSTextAlignmentRight;
        [self addSubview:lab1];
        
        switch (i) {
            case 0: {
            
                _sqTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_sqTfView setTextFieldPlaceholder:@"选择收取方式"];
                [self addSubview: _sqTfView];
            }
                break;
            case 1:{
                
                _yjLab = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _yjLab.font = [UIFont systemFontOfSize:15];
                _yjLab.text = @"100";
                _yjLab.textColor = [UIColor lightGrayColor];
                [self addSubview:_yjLab];
            }
                
                break;
            case 2:{
                
                _zfTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
                [_zfTfView setTextFieldPlaceholder:@"选择支付方式"];
                [self addSubview: _zfTfView];
            }
                
                break;
            case 3:{
                _tcLab = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _tcLab.font = [UIFont systemFontOfSize:15];
                _tcLab.text = @"100";
                _tcLab.textColor = [UIColor lightGrayColor];
                [self addSubview:_tcLab];
            }
                break;
            case 4:
                
                _qxLab = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top, (KScreenWidth - 240)/2, 30)];
                _qxLab.font = [UIFont systemFontOfSize:15];
                _qxLab.text = @"";
                _qxLab.textColor = [UIColor lightGrayColor];
                [self addSubview:_qxLab];
                break;
                
            default:
                break;
        }
    }
}

// 订购设备
- (void)initdevView {

    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,_qxLab.bottom + 15 , 90, 25)];
    titleLab2.layer.cornerRadius = 2;
    titleLab2.layer.masksToBounds = YES;
    titleLab2.backgroundColor = TITLE_COLOR;
    titleLab2.textAlignment = NSTextAlignmentCenter;
    titleLab2.font = [UIFont systemFontOfSize:16];
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.text = @"设备订购数";
    [self addSubview:titleLab2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab2.top + 24, KScreenWidth - 25, 1)];
    line2.backgroundColor = TITLE_COLOR;
    [self addSubview:line2];
    
    for (int i = 0; i < 2; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (KScreenWidth - 240)/2), line2.bottom + 5 + i / 2 * (30 + 3), 100, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.textAlignment = NSTextAlignmentRight;
        [self addSubview:lab1];
        
        if (i == 0) {
            lab1.text = @"设备订购数";
            
            _dgTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (KScreenWidth - 240)/2 - 50, 25)];
            [_dgTfView setTextFieldPlaceholder:@"填写设备订购数"];
            [self addSubview: _dgTfView];
            
        } else {
            lab1.text = @"取消数量";
        }
    }
}
- (void)t1Action:(UIButton *)sender {

    _radioBtn1.btn.selected = !_radioBtn1.btn.selected;
    if (_radioBtn2.btn.selected == YES) {
        _radioBtn2.btn.selected = NO;
    }
}
- (void)t2Action:(UIButton *)sender {
    
    _radioBtn2.btn.selected = !_radioBtn2.btn.selected;
    if (_radioBtn1.btn.selected == YES) {
        _radioBtn1.btn.selected = NO;
    }
}
- (void)t3Action:(UIButton *)sender {
    
    _radioBtn3.btn.selected = !_radioBtn3.btn.selected;
    if (_radioBtn4.btn.selected == YES) {
        _radioBtn4.btn.selected = NO;
    }
}
- (void)t4Action:(UIButton *)sender {
    
    _radioBtn4.btn.selected = !_radioBtn4.btn.selected;
    if (_radioBtn3.btn.selected == YES) {
        _radioBtn3.btn.selected = NO;
    }
}

@end
