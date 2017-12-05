//
//  HHScanViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/9.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HHScanViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMediaFormat.h>
#import "GHListViewController.h"

@interface HHScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    AVCaptureSession * session;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIActivityIndicatorView *hud;
}
@property (nonatomic, retain) UIImageView * line;

@end

@implementation HHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"收货扫描"];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(KScreenWidth - 95, 20, 80, 44);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    
    [self _initView];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        
        //无权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"途鸽提示" message:@"应用相机权限已关闭，请在设置中打开" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        alert.tag = 1002;
        [alert show];
        return;
    }
    [self initScanView];
    
//    [self performSelector:@selector(initScanView) withObject:nil afterDelay:2];
}
- (void)rightAction:(UIButton *)sender {
    
    // 手动输入
    NSLog(@"手动输入");
    [self fillAlert];
}
- (void)fillAlert {
    
    [session stopRunning];
    [timer invalidate];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"手动输入"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    alert.tag = 1001;
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.placeholder = @"请输入设备号/预留姓名/手机号";
    tf.text = @"TGT";
    [alert show];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [session stopRunning];
    [timer invalidate];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        return;
    }
    [session startRunning];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
#pragma mark - 初始化视图
- (void)_initView {
    
    UIView *zzView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 100)];
    zzView1.backgroundColor = [UIColor blackColor];
    zzView1.alpha = .5;
    [self.view addSubview:zzView1];
    UIView *zzView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 250+64, KScreenWidth, KScreenHeight - 150 - 64 - 100)];
    zzView2.backgroundColor = [UIColor blackColor];
    zzView2.alpha = .5;
    [self.view addSubview:zzView2];
    UIView *zzView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 100+64, 80, 150)];
    zzView3.backgroundColor = [UIColor blackColor];
    zzView3.alpha = .5;
    [self.view addSubview:zzView3];
    UIView *zzView4 = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 80, 100+64, 80, 150)];
    zzView4.backgroundColor = [UIColor blackColor];
    zzView4.alpha = .5;
    [self.view addSubview:zzView4];
    
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 100+64, KScreenWidth - 160, 150)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    bgView.layer.borderWidth = .5;
    [self.view addSubview:bgView];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgView.bottom + 10, KScreenWidth, 30)];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.text = @"请将途鸽设备背面条形码放置扫描框中";
    [self.view addSubview:tipsLabel];
    
    for (int i = 0; i < 4; i++) {
        
        int j1 = i / 2;
        int j2 = i % 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80 + j2 * (KScreenWidth - 160 - 16), 100 + 64 + j1 * (150 - 16), 16, 16)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ScanQR%d",i+1]];
        [self.view addSubview:imageView];
    }
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 2, KScreenWidth - 160 - 40, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    _line.hidden = YES;
    [bgView addSubview:_line];
}

-(void)animation1
{
    _line.hidden = NO;
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(20, 2 + 2*num, KScreenWidth - 160 - 40, 2);
        if (2*num == 146) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(20, 2 + 2*num, KScreenWidth - 160 - 40, 2);
        if (num == 2) {
            upOrdown = NO;
        }
    }
    
}
#pragma mark - 初始化扫描视图
- (void)initScanView {
    
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描区域
    output.rectOfInterest = CGRectMake((200+64) / KScreenHeight,80/KScreenWidth,150 / KScreenHeight, (KScreenWidth - 160)/KScreenWidth);
    
    // 初始化链接对象
    session = [[AVCaptureSession alloc]init];
    // 高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    [session addOutput:output];
    // 设置扫码支持的编码格式(如下设置只支持条形码)
    output.metadataObjectTypes = @[AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    // 开始捕获
//    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
//    [session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        // 输出扫描字符串
        NSLog(@"1:%@",metadataObject.stringValue);
        
        [timer invalidate];
        _line.frame = CGRectMake(20, 74, KScreenWidth - 160 - 40, 2);
        NSString *str = [NSString stringWithFormat:@"%@",metadataObject.stringValue];
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询订单" message:str1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查询", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1001) {
        
        UITextField *inputField = [alertView textFieldAtIndex:0];
        [inputField resignFirstResponder];
        
        if (buttonIndex == 0) {
            
            [session startRunning];
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        } else {
        
            GHListViewController *ghorderVc = [[GHListViewController alloc] init];
            ghorderVc.inputStr = inputField.text;
            [self.navigationController pushViewController:ghorderVc animated:YES];
        }
        
    }else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self fillAlert];
        }
    } else {
        if (buttonIndex == 0) {
            // 取消
            [session startRunning];
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        } else {
            // 查询
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"HHScanOrder" object:nil userInfo:@{@"SSID":alertView.message}];
//            [self dismissViewControllerAnimated:YES completion:nil];
            GHListViewController *ghorderVc = [[GHListViewController alloc] init];
            ghorderVc.inputStr = alertView.message;
            [self.navigationController pushViewController:ghorderVc animated:YES];
        }
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
