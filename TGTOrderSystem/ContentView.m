//
//  ContentView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "ContentView.h"
#import "BtnView.h"

@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    
    UIColor *color1 = [UIColor colorWithRed:0.4667 green:0.8627 blue:0.2980 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:0.1137 green:0.5176 blue:0.9843 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:0.9922 green:0.7490 blue:0.2549 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:0.8784 green:0.0510 blue:0.2627 alpha:1];
    
    NSArray *color = @[color1,color2,color3,color4];
    _title = @[@"发货",@"返还",@"订单查询",@"下单"];
     NSArray *imgArr = @[@"wifi_icon7",@"wifi_icon4",@"wifi_icon5",@"adv1"];
    
    float jl = isPad ? ADAPTER(60) : ADAPTER(20);
    float width = isPad ? ADAPTER(100) : ADAPTER(80);
    float jl_H = isPad ? 30 : 15;
    
    for (int i = 0; i < _title.count - 1; i++) {
        
        BtnView *btnBgView = [[BtnView alloc] initWithFrame:CGRectMake(jl + i % 3 * (width + (KScreenWidth - width * 3 - jl * 2)/2), jl_H + i / 3 * (width + 30 + 30), width, width + 30)];
        btnBgView.tag = i + 10;
        btnBgView.titleLab.text = _title[i];
        btnBgView.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[i]]];
        [self addSubview:btnBgView];
        UIColor *bgColor = color[i];
        btnBgView.view1.backgroundColor = [bgColor colorWithAlphaComponent:.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [btnBgView addGestureRecognizer:tap];
    }
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 480, self.height - 50, 250, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"模拟后台环境，原型测试时使用";
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    
    _radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(KScreenWidth - 200 , self.height - 50, 80, 30)];
    [_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"T1" action:@selector(t1Action:)];
    [self addSubview:_radioBtn1];
    
    _radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(_radioBtn1.right ,  self.height - 50, 80, 30)];
    [_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"T2" action:@selector(t2Action:)];
    [self addSubview:_radioBtn2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *devNum = [defaults objectForKey:@"system"];
    if ([devNum isEqualToString:@"T1"]) {
        _radioBtn1.btn.selected = YES;
    } else if ([devNum isEqualToString:@"T2"]) {
        _radioBtn2.btn.selected = YES;
    } else {
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"T2" forKey:@"system"];
        [defaults synchronize];
        _radioBtn2.btn.selected = YES;
    }
    */
}

- (void)t1Action:(UIButton *)sender {
    
    _radioBtn1.btn.selected = !_radioBtn1.btn.selected;
    if (_radioBtn2.btn.selected == YES) {
        _radioBtn2.btn.selected = NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"T1" forKey:@"system"];
    [defaults synchronize];
}
- (void)t2Action:(UIButton *)sender {
    
    _radioBtn2.btn.selected = !_radioBtn2.btn.selected;
    if (_radioBtn1.btn.selected == YES) {
        _radioBtn1.btn.selected = NO;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"T2" forKey:@"system"];
    [defaults synchronize];
}
#pragma mark - 按钮事件
- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSString *index = [NSString stringWithFormat:@"%ld",(long)tap.view.tag - 10];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickBtn" object:nil userInfo:@{@"titleIndex":index}];
}
@end
