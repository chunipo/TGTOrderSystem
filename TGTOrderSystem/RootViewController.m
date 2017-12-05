//
//  RootViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "HeaderView.h"
#import "ContentView.h"
#import "QHViewController.h"
#import "HHViewController.h"
#import "CXViewController.h"
#import "OrderViewController.h"
#import "QDViewController.h"
#import "SheetView.h"
#import "HHScanViewController.h"
#import "YCSHView.h"
#import "YCSHView_V1.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    // 监听按钮事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnAction:) name:@"ClickBtn" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClickBtn" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    // 检查登录
    [self isLogin];
}

#pragma mark - 判断是否登录
- (void)isLogin {
    
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [[login objectForKey:@"islogin"] boolValue];
    if (isLogin) {
        // 已登录，加载首页视图
        [self initView];
        
    } else {
        // 弹出登录页面
        LoginViewController *loginVc= [[LoginViewController alloc] init];
        [self presentViewController:loginVc animated:NO completion:nil];
        return;
    }
}

- (void)initView {
    
    float height = isPad ? ADAPTER(400) : ADAPTER(250);
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
    [headerView.logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerView];
    
    ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(0,headerView.bottom, KScreenWidth, KScreenHeight - height)];
    [self.view addSubview:contentView];
}

#pragma mark - 退出登录
- (void)logout {
    /*
    YCSHView_V1 *yc_v1 = [[YCSHView_V1 alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    yc_v1.gdmodel = nil;
    [self.view addSubview:yc_v1];
    
    YCSHView *ycshView = [[YCSHView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    ycshView.gdmodel = nil;
    ycshView.titleLab.text = @"T2收货";
    [self.view addSubview:ycshView];
     */
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *isLogin = [NSUserDefaults standardUserDefaults];
        [isLogin setObject:@"NO" forKey:@"islogin"];
        [isLogin setObject:@"" forKey:@"TGTACOUNT"];
        [isLogin synchronize];
        // 弹出登录页面
        LoginViewController *loginVc= [[LoginViewController alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark - 功能按钮
- (void)btnAction:(NSNotification *)notification {

    NSInteger titleIndex = [[NSString stringWithFormat:@"%@",notification.userInfo[@"titleIndex"]] integerValue];
    switch (titleIndex) {
        case 0:
        {
            //发货
            QHViewController *qhVc = [[QHViewController alloc] init];
            [self.navigationController pushViewController:qhVc animated:YES];
        }
            break;
        case 1:
        {
            //返还
            HHScanViewController *hhVc = [[HHScanViewController alloc] init];
            [self.navigationController pushViewController:hhVc animated:YES];
        }
            break;
        case 2:
        {
            //订单查询
            CXViewController *cxVc = [[CXViewController alloc] init];
            [self.navigationController pushViewController:cxVc animated:YES];
        }
            break;
        case 3:
        {
            //下单  柜台版本没有
            SheetView *sheetView = [[SheetView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            NSArray *titleArr = @[@"全球日租",@"套餐"];
            [sheetView setBtnWithTitle:titleArr clickbtn:^(UIButton *sender,NSInteger index) {
                if ([sender.currentTitle isEqualToString:@"全球日租"]) {
                    OrderViewController *xdVc = [[OrderViewController alloc] init];
                    [self.navigationController pushViewController:xdVc animated:YES];
                }
            }];
            [self.view addSubview:sheetView];
        }
            break;
        case 4:
        {
            QDViewController *qdVc = [[QDViewController alloc] init];
            [self.navigationController pushViewController:qdVc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
