//
//  ScanViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMediaFormat.h>
#import "XGGHttpsManager.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UISearchBar *_searchBar;
    UIView *_searchBgView;
    UITableView *_searchTableView;
}
@property (nonatomic, retain) UIImageView * line;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"扫描设备"];
    
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
    
    [self initSearchView];
}

- (void)initSearchView {
    
    _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _searchBgView.backgroundColor = [UIColor whiteColor];
    _searchBgView.alpha = 0;
    [self.view addSubview:_searchBgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    bgView.backgroundColor = [UIColor colorWithRed:0.9255 green:0.9255 blue:0.9255 alpha:1];
    [_searchBgView addSubview:bgView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"模糊匹配设备";
    _searchBar.keyboardType = UIKeyboardTypeNumberPad;
    [_searchBar sizeToFit];
    _searchBar.backgroundColor = [UIColor colorWithRed:0.9255 green:0.9255 blue:0.9255 alpha:1];
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    [bgView addSubview:_searchBar];
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [_searchBgView addSubview:_searchTableView];
    
    _emptyTipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 50)];
    _emptyTipLab.textAlignment = NSTextAlignmentCenter;
    _emptyTipLab.textColor = [UIColor darkGrayColor];
    _emptyTipLab.font = [UIFont systemFontOfSize:20];
    _emptyTipLab.text = @"无匹配结果";
    _emptyTipLab.hidden = YES;
    [_searchTableView addSubview:_emptyTipLab];
}
//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [session stopRunning];
    [timer invalidate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
- (void)rightAction:(UIButton *)sender {
    
    // 手动输入
    [session stopRunning];
    [timer invalidate];
    
    [UIView animateWithDuration:.25 animations:^{
        _searchBgView.alpha = 1;
        [_searchBar becomeFirstResponder];
    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }];
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
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
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
    output.metadataObjectTypes=@[AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        // 输出扫描字符串
        NSLog(@"1:%@",metadataObject.stringValue);
        
        [timer invalidate];
        _line.frame = CGRectMake(20, 74, KScreenWidth - 160 - 40, 2);
        NSString *str = [NSString stringWithFormat:@"%@",metadataObject.stringValue];
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
        NSMutableArray *dev_arr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [dev_arr addObject:dic[@"equno"]];
        }
        if ([dev_arr containsObject:str1]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请勿重复扫描同一设备" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag = 107;
            [alert show];
            return;
        }
        [arr addObject:@{@"equno":str1,@"status":@"待发货",@"number":@""}];
        [arr writeToFile:filename atomically:YES];
        arr1 = [NSArray arrayWithContentsOfFile:filename];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr1 forKey:@"devList"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
        
        NSString *msg = @"";
        for (NSDictionary *dic in arr1) {
            NSString *str = dic[@"equno"];
            msg = [msg stringByAppendingString:[str stringByAppendingString:@"\n"]];
        }
        msg = [msg substringWithRange:NSMakeRange(0, msg.length - 1)];
        NSString *otherBtnTitle;
        if (arr1.count < [_devCount integerValue]) {
            otherBtnTitle = @"继续添加";
        } else {
            otherBtnTitle = @"添加完成";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已添加的设备（%ld/%@）",(long)arr1.count,_devCount] message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:otherBtnTitle, nil];
        alert.tag = 101;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    
    if (alertView.tag == 101) {
        
        if (buttonIndex == 1) {
            
            if (arr1.count == [_devCount integerValue]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [UIView animateWithDuration:.25 animations:^{
                _searchBgView.alpha = 0;
                _dataList = @[];
                _searchBar.text = @"";
                [_searchTableView reloadData];
                [_searchBar resignFirstResponder];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            } completion:^(BOOL finished) {
                [session startRunning];
                timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
            }];
        } else if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag == 1001){
    
        UITextField *inputField = [alertView textFieldAtIndex:0];
        [inputField resignFirstResponder];
        
        if (buttonIndex == 1) {
            
            if ([inputField.text hasPrefix:@"TGT"]) {
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths    objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
                
                NSMutableArray *dev_arr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    [dev_arr addObject:dic[@"equno"]];
                }
                if ([dev_arr containsObject:inputField.text]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请勿重复添加同一设备" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alert.tag = 107;
                    [alert show];
                    return;
                }
                [arr addObject:@{@"equno":inputField.text,@"status":@"待发货",@"number":@""}];
                
                [arr writeToFile:filename atomically:YES];
                arr1 = [NSArray arrayWithContentsOfFile:filename];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:arr1 forKey:@"devList"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
                
                NSString *msg = @"";
                for (NSDictionary *dic in arr1) {
                    NSString *str = dic[@"equno"];
                    msg = [msg stringByAppendingString:[str stringByAppendingString:@"\n"]];
                }
                msg = [msg substringWithRange:NSMakeRange(0, msg.length - 1)];
                NSString *otherBtnTitle;
                if (arr1.count < [_devCount integerValue]) {
                    otherBtnTitle = @"继续添加";
                } else {
                    otherBtnTitle = @"添加完成";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已添加的设备（%ld/%@）",(long)arr1.count,_devCount] message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:otherBtnTitle, nil];
                alert.tag = 101;
                [alert show];
            } else {
                
                UIAlertView *alert123 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请输入正确的SSID"] message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert123 show];
                
                return;
            }
        } else {
            [session startRunning];
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        }
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // 手动输入
            [session stopRunning];
            [timer invalidate];
            
            [UIView animateWithDuration:.25 animations:^{
                _searchBgView.alpha = 1;
                [_searchBar becomeFirstResponder];
            } completion:^(BOOL finished) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            }];
        }
    } else if (alertView.tag == 107) {
        
        [session startRunning];
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}
#pragma mark - searchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    if ([_flag isEqualToString:@"T2"] || [_flag isEqualToString:@"SCP"]) {
        if ([searchText containsString:@"TGT"]) {
            [self getEquno:[searchText stringByReplacingOccurrencesOfString:@"TGT" withString:@""]];
        } else if ([searchText containsString:@"TG"]) {
            [self getEquno:[searchText stringByReplacingOccurrencesOfString:@"TG" withString:@""]];
        } else {
            [self getEquno:searchText];
        }
    } else if ([_flag isEqualToString:@"T1"]) {
        if ([searchText containsString:@"TGT"]) {
            [self getEquno_V1:[searchText stringByReplacingOccurrencesOfString:@"TGT" withString:@""]];
        } else if ([searchText containsString:@"TG"]) {
            [self getEquno_V1:[searchText stringByReplacingOccurrencesOfString:@"TG" withString:@""]];
        } else {
            [self getEquno_V1:searchText];
        }
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    if (searchBar == _searchBar) {
        
        searchBar.showsCancelButton=YES;
        for(id cc in [searchBar.subviews[0] subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *sbtn = (UIButton *)cc;
                sbtn.titleLabel.font = [UIFont systemFontOfSize:17];
                [sbtn setTitle:@"取消" forState:UIControlStateNormal];
                [sbtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            }
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == _searchBar) {
        [UIView animateWithDuration:.25 animations:^{
            _searchBgView.alpha = 0;
            _dataList = @[];
            _searchBar.text = @"";
            [_searchTableView reloadData];
            [_searchBar resignFirstResponder];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        } completion:^(BOOL finished) {
            [session startRunning];
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataList.count == 0) {
        _emptyTipLab.hidden = NO;
    } else {
        _emptyTipLab.hidden = YES;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *equipmentcode = [NSString stringWithFormat:@"%@",_dataList[indexPath.row]];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
    
    NSMutableArray *dev_arr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [dev_arr addObject:dic[@"equno"]];
    }
    if ([dev_arr containsObject:equipmentcode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请勿重复添加同一设备" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    [arr addObject:@{@"equno":equipmentcode,@"status":@"待发货",@"number":@""}];
    
    [arr writeToFile:filename atomically:YES];
    arr1 = [NSArray arrayWithContentsOfFile:filename];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:arr1 forKey:@"devList"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
    
    NSString *msg = @"";
    for (NSDictionary *dic in arr1) {
        NSString *str = dic[@"equno"];
        msg = [msg stringByAppendingString:[str stringByAppendingString:@"\n"]];
    }
    msg = [msg substringWithRange:NSMakeRange(0, msg.length - 1)];
    NSString *otherBtnTitle;
    if (arr1.count < [_devCount integerValue]) {
        otherBtnTitle = @"继续添加";
    } else {
        otherBtnTitle = @"添加完成";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已添加的设备（%ld/%@）",(long)arr1.count,_devCount] message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:otherBtnTitle, nil];
    alert.tag = 101;
    [alert show];
}

- (void)getEquno_V1:(NSString *)input_str {
    
    NSDictionary *dic = @{@"sn":input_str};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    NSString *keyStr = [V1HttpTool getKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.getEquipment",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *equipments = dict[@"equipments"];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dict in equipments) {
                NSString *equipmentcode = [NSString stringWithFormat:@"%@",dict[@"sn"]];
                [marr addObject:equipmentcode];
            }
            _dataList = marr;
            [_searchTableView reloadData];
        } else {
            NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (void)getEquno:(NSString *)equno {
    
    NSString *accountId = @"tgt_ipad";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:_orderno forKey:@"orderno"];
    [dataDic setObject:equno forKey:@"equno"];
    
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"queryAvalibleEquipment",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"queryAvalibleEquipment",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.queryAvalibleEquipment",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session1=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session1 dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    NSArray *data = dict[@"data"];
                    NSMutableArray *marr = [NSMutableArray array];
                    for (NSDictionary *dict in data) {
                        NSString *equipmentcode = [NSString stringWithFormat:@"%@",dict[@"equipmentcode"]];
                        [marr addObject:equipmentcode];
                    }
                    _dataList = marr;
                    [_searchTableView reloadData];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    [task resume];
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
