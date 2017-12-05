//
//  YJTView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/24.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "YJTView.h"
#import "TextFieldView.h"

@implementation YJTView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        
        [self _initViews];
        [self _initCloseBtn];
    }
    return self;
}
- (void)_initCloseBtn {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 50-33, 85, 50, 50)];
    //    imgView.backgroundColor = [UIColor orangeColor];
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

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, KScreenWidth - 100, KScreenHeight - 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 50)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"押金条";
    [bgView addSubview:titleLab];
    
    NSArray *ycLeftName = @[@"领用日期",@"押金条单号",@"设备编号",@"开通状态",
                            @"押金收取",@"待付金额",@"归还时间",@"押金消费",
                            @"没收押金金额",@"押金退款",@"扣款原因",@"门店",
                            @"制单人",@"快递单号",@"设备情况",@"代付金额"];
    for (int i = 0; i < ycLeftName.count; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (bgView.width - 280)/2), titleLab.bottom + 5 + i / 2 * (30 + 10), 120, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = ycLeftName[i];
        lab1.textColor = [UIColor darkGrayColor];
        lab1.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:lab1];
        
        TextFieldView *yjTFView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
        [yjTFView setTextFieldPlaceholder:@"请点击填写"];
        [bgView addSubview: yjTFView];
        if (i == 1) {
            yjTFView.textField.text = @"YJ201605191838048";
        }
    }
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(50, titleLab.bottom + 320 + 50, bgView.width - 100, 45);
    submitBtn.backgroundColor = TITLE_COLOR;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitBtn];
}

- (void)layoutSubviews {

    NSString *dev = [NSString stringWithFormat:@"%@",_dic[@"dev_number"]];
    if (![dev hasPrefix:@"TGT"]) {
        submitBtn.hidden = NO;
    } else {
        submitBtn.hidden = YES;
    }
}

- (void)submitAction:(UIButton *)sender {

    NSDictionary *dic = @{@"collection_date":@"2016-05-19",
                          @"yjt_number":@"YJ201605191838048",
                          @"dev_number":@"TGT01234243241",
                          @"state":@"开",
                          @"yjsq":@"500.00",
                          @"dfyj":@"400.00",
                          @"gh_date":@"",
                          @"yjxf":@"",
                          @"msyj":@"",
                          @"yjtk":@"",
                          @"kkyy":@"",
                          @"md":@"途鸽总部",
                          @"zhr":@"",
                          @"kddh":@"",
                          @"sbqk":@"完好",
                          @"dfje":@"0.00"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yjt" object:nil userInfo:dic];
    [self hideView];
}

@end
