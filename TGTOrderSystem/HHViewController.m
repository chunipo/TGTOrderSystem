//
//  HHViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HHViewController.h"
#import "HHScanViewController.h"
#import "HHOrderViewController.h"

@interface HHViewController ()

@end

@implementation HHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"收货"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanOrderCx:) name:@"HHScanOrder" object:nil];
    [self initViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HHScanOrder" object:nil];
}

- (void) initViews {

    float width = isPad ? ADAPTER(400) : ADAPTER(250);
    float height = isPad ? ADAPTER(45) : ADAPTER(40);
    float jl = isPad ? ADAPTER(200) : ADAPTER(100);
    CGFloat fontSize = isPad ? 17 : 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - width)/2, jl, width, height)];
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    bgView.layer.borderWidth = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, width-10, height)];
    _textField.font = [UIFont systemFontOfSize:fontSize];
    _textField.placeholder = @"设备SSID/手机号";
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_textField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(bgView.width - height,0, height, height);
//    searchBtn.backgroundColor = TITLE_COLOR;
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"2.jpeg"] forState:UIControlStateNormal];
    [bgView addSubview:searchBtn];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(ADAPTER(70), bgView.bottom + (ADAPTER(100)), KScreenWidth - (ADAPTER(140)), 1)];
    line.image = [UIImage imageNamed:@"sign_in_line_iphone6"];
//    line.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((line.width - 150)/2, -10, 150, 20)];
    label.backgroundColor = [UIColor colorWithRed:0.9412 green:0.9412 blue:0.9412 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    label.text = @"或扫描设备条形码";
    label.textAlignment = NSTextAlignmentCenter;
    [line addSubview:label];
    
    _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - (ADAPTER(250)))/2, line.bottom + (ADAPTER(50)), ADAPTER(250), ADAPTER(120))];
    [_scanBtn setImage:[UIImage imageNamed:@"scanImg.jpeg"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanTapAction) forControlEvents:UIControlEventTouchUpInside];
    _scanBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scanBtn];
}

#pragma mark - 收键盘
- (void)tapAction {
    [_textField resignFirstResponder];
}

- (void)scanTapAction {

    [_textField resignFirstResponder];
    HHScanViewController *hhScanvc = [[HHScanViewController alloc] init];
    [self presentViewController:hhScanvc animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    _textField.text = @"TGT";
    return YES;
}

- (void)searchBtn:(UIButton *)sender {
    
    //    if (_textField.text.length != 14) {
    //
    //        // 请输入正确设备号
    //        return;
    //    }
    
    HHOrderViewController *hhorderVc = [[HHOrderViewController alloc] init];
    [self.navigationController pushViewController:hhorderVc animated:YES];
}
- (void)scanOrderCx:(NSNotification *)nitificaton {
    
    NSString *ssid = nitificaton.userInfo[@"SSID"];
    HHOrderViewController *hhorderVc = [[HHOrderViewController alloc] init];
    [self.navigationController pushViewController:hhorderVc animated:YES];
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
