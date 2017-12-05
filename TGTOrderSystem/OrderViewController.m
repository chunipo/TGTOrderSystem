//
//  OrderViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderContentView.h"
#import "SelectView.h"
#import "CalendarView.h"

typedef void (^ReloadSelectBlock)(NSString *selectStr);

@interface OrderViewController ()<UITextFieldDelegate>
{
    OrderContentView *_contentView;
}
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"下单或渠道漏单"];
    
    [self performSelector:@selector(_initViews) withObject:nil afterDelay:.5];
}

- (void)_initViews {

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    [self.view addSubview:scrollView];
    _contentView = [[OrderContentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 820)];
    // 设置代理对象
    for (UIView *subView in [_contentView subviews]) {
        if ([subView isKindOfClass:[TextFieldView class]]) {
            TextFieldView *tf = (TextFieldView *)subView;
            tf.textField.delegate = self;
        }
    }
    [scrollView addSubview:_contentView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.bottom + 10, KScreenWidth, KScreenHeight - 820 - 64 - 10)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bottomView];
    scrollView.contentSize = CGSizeMake(KScreenWidth, bottomView.bottom);
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(50, 20, KScreenWidth - 100, 40);
    submitBtn.backgroundColor = TITLE_COLOR;
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:submitBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAction:)];
    [_contentView addGestureRecognizer:tap];
}
#pragma mark - 提交订单
- (void)submitAction:(UIButton *)sender {

    NSString *msg = [NSString stringWithFormat:@"    t1：%d\n    t2：%d\n邮寄：%d\n自提：%d",_contentView.radioBtn1.btn.selected,_contentView.radioBtn2.btn.selected,_contentView.radioBtn3.btn.selected,_contentView.radioBtn4.btn.selected];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - resignAction: 收键盘
- (void)resignAction:(UITapGestureRecognizer *)tap {
    
    for (UIView *subView in [_contentView subviews]) {
        
        if ([subView isKindOfClass:[TextFieldView class]]) {
            TextFieldView *tf = (TextFieldView *)subView;
            [tf.textField resignFirstResponder];
        }
        if ([subView isKindOfClass:[UITextView class]]) {
            UITextView *tf = (UITextView *)subView;
            [tf resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSArray *textViewArr = @[_contentView.otaTfView.textField,_contentView.salesTfView.textField,
                             _contentView.departmentTfView.textField,_contentView.daysTfView.textField,
                             _contentView.nameTfView.textField,_contentView.phoneTfView.textField];
    if ([textViewArr containsObject:textField]) {
        return YES;
    }
    
    for (UIView *subView in [_contentView subviews]) {
        
        if ([subView isKindOfClass:[TextFieldView class]]) {
            TextFieldView *tf = (TextFieldView *)subView;
            [tf.textField resignFirstResponder];
        }
        if ([subView isKindOfClass:[UITextView class]]) {
            UITextView *tf = (UITextView *)subView;
            [tf resignFirstResponder];
        }
    }
    
    if (textField == _contentView.channelTfView.textField) {
        // 渠道
        NSArray *arr = @[@"渠道",@"渠道",@"渠道",@"渠道",@"渠道",
                         @"渠道",@"渠道",@"渠道",@"渠道",@"渠道",
                         @"渠道",@"渠道",@"渠道",@"渠道",@"渠道"];
        [self selectViewWithData:arr titleName:@"选择渠道" reloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
        
    } else if (textField == _contentView.areaTfView.textField) {
        // 区域
        if ([_contentView.channelTfView.textField.text isEqualToString:@""]) {
            
        } else {
            NSLog(@"区域");
            NSArray *arr = @[@"区域",@"区域",@"区域",@"区域",@"区域",
                             @"区域",@"区域",@"区域",@"区域",@"区域",
                             @"区域",@"区域",@"区域",@"区域",@"区域"];
            [self selectViewWithData:arr titleName:@"选择区域" reloadSelectBlock:^(NSString *selectStr) {
                textField.text = selectStr;
            }];
        }
        
    } else if (textField == _contentView.packageTfView.textField) {
        // 套餐
        if ([_contentView.channelTfView.textField.text isEqualToString:@""]) {
            
        } else {
            NSLog(@"套餐");
            NSArray *arr = @[@"套餐",@"套餐",@"套餐",@"套餐",@"套餐",
                             @"套餐",@"套餐",@"套餐",@"套餐",@"套餐",
                             @"套餐",@"套餐",@"套餐",@"套餐",@"套餐"];
            [self selectViewWithData:arr titleName:@"选择套餐" reloadSelectBlock:^(NSString *selectStr) {
                textField.text = selectStr;
            }];
        }
    } else if (textField == _contentView.startTimeTfView.textField) {
        // 开始时间
        NSLog(@"开始时间");
        [self selectDateFormCalenarViewwithReloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
        
    } else if (textField == _contentView.qjTfView.textField) {
        // 取件地点
        NSLog(@"取件地点");
        NSArray *arr = @[@"取件地点",@"取件地点",@"取件地点",@"取件地点",@"取件地点"];
        [self selectViewWithData:arr titleName:@"选择取件地点" reloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
    } else if (textField == _contentView.hjTfView.textField) {
        // 还件地点
        NSLog(@"还件地点");
        NSArray *arr = @[@"还件地点",@"还件地点",@"还件地点",@"还件地点",@"还件地点"];
        [self selectViewWithData:arr titleName:@"选择还件地点" reloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
    } else if (textField == _contentView.sqTfView.textField) {
        // 收取押金
        NSLog(@"收取押金");
        NSArray *arr = @[@"渠道代收",@"途鸽代收"];
        [self selectViewWithData:arr titleName:@"押金收取方式" reloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
    } else if (textField == _contentView.zfTfView.textField) {
        // 支付方式
        NSLog(@"支付方式");
        NSArray *arr = @[@"挂账",@"现付"];
        [self selectViewWithData:arr titleName:@"套餐支付方式" reloadSelectBlock:^(NSString *selectStr) {
            textField.text = selectStr;
        }];
    } else if (textField == _contentView.dgTfView.textField) {
        // 订购数
        NSLog(@"订购数");
        [self fillAlert];
    }
    
    return NO;
}

#pragma mark - 选择视图
- (void)selectViewWithData:(NSArray *)dataArr titleName:(NSString *)titleName reloadSelectBlock:(ReloadSelectBlock)reloadSelectBlock {

    SelectView *selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    selectView.dataList = dataArr;
    selectView.titleName = titleName;
    selectView.selectBlock = ^(NSString *str){
        reloadSelectBlock(str);
    };
    [self.view addSubview:selectView];
}
#pragma mark - 选择日期
- (void)selectDateFormCalenarViewwithReloadSelectBlock:(ReloadSelectBlock)reloadSelectBlock {

    CalendarView *calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    calendarView.selectBlock = ^(NSString *str){
        reloadSelectBlock(str);
    };
    [self.view addSubview:calendarView];
}
#pragma mark - 订购数量
- (void)fillAlert {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"设备订购数"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.placeholder = @"输入订购数量";
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 取消
        UITextField *inputField = [alertView textFieldAtIndex:0];
        [UIView animateWithDuration:.35 animations:^{
            [inputField resignFirstResponder];
        }];
    } else {
        // 确认
        UITextField *inputField = [alertView textFieldAtIndex:0];
        [inputField resignFirstResponder];
        _contentView.dgTfView.textField.text = inputField.text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
