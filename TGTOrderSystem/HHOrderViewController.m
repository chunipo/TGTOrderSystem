//
//  HHOrderViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/9.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HHOrderViewController.h"
#import "HHView.h"
#import "BottomView.h"
#import "HHTopView.h"
#import "CalendarView.h"
#import "DevListView.h"
#import "HHRKScanViewController.h"
#import "WOViewController.h"
#import "JSViewController.h"
#import "XGGHttpsManager.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"
#import "GDModel.h"
#import "QianZiView.h"
#import "YCSHView.h"
#import "YCSHView_V1.h"
#import "HHView.h"

typedef void (^ReloadSelectBlock)(NSString *selectStr);

@interface HHOrderViewController ()
{
    NSArray *_numberArr;
    UITableView *_tableView;
    GDModel *_gdModel;
    HHView *hhView;
}
@end

@implementation HHOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",_model.receivedpath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    if (receivedData == nil) {
        if ([receivedpath isEqualToString:@"(null)"]) {
            isUpImg = NO;
        } else {
            isUpImg = YES;
        }
    } else {
        isUpImg = YES;
    }
    qzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qzBtn.frame = CGRectMake(KScreenWidth - 90, 20, 90, 44);
    [qzBtn setTitle:@"签字" forState:UIControlStateNormal];
    [qzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qzBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [qzBtn addTarget:self action:@selector(showHuaBanView) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:qzBtn];
    
    if (isUpImg == YES) {
        [qzBtn setTitle:@"已签字" forState:UIControlStateNormal];
    }
    
    [navView initWithTitleName:@"订单详情"];
    [self searchOrderWithKeyWord:[NSString stringWithFormat:@"%@",_model.orderno]];
    [self _initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ycshBlock) name:@"ycshwc" object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jsActon" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ycshwc" object:nil];
}
- (void)ycshBlock {
    
    [self searchOrderWithKeyWord:[NSString stringWithFormat:@"%@",_model.orderno]];
}
- (void)_initView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    hhView = [[HHView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth,260)];
    [hhView _loadData:_model];
    [_scrollView addSubview:hhView];
    
    NSString *deliverypath = [NSString stringWithFormat:@"%@",_model.deliverypath];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",_model.receivedpath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    
    if (deliveryData == nil && receivedData == nil) {
        if ([deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
            hhView.height = 260;
        } else {
            hhView.height = 260 + 40;
        }
    } else {
         hhView.height = 260 + 40;
    }
    _devNum = [NSString stringWithFormat:@"%@",_model.t2t1flag];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, hhView.bottom + 10, KScreenWidth, KScreenHeight - 64 - hhView.height - 10) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _numberArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, KScreenWidth - 60, 70)];
    content.font = [UIFont systemFontOfSize:17];
    GDModel *gdModel = _numberArr[indexPath.row];
    NSString *equno = [NSString stringWithFormat:@"%@",gdModel.equno];
    NSString *status= [NSString stringWithFormat:@"%@",gdModel.channelorderstatus];
    content.text = equno;
    NSString *str = [_inputStr stringByReplacingOccurrencesOfString:@"TGT" withString:@""];
    str = [str uppercaseString];
    if ([equno containsString:str] && indexPath.row == 0) {
        content.textColor = [UIColor redColor];
    }
    [cell.contentView addSubview:content];
    if ([equno isEqualToString:@"(null)"]) {
        content.text = @"暂无添加设备";
    }
    if ([status isEqualToString:@"RECEIVED"]) {
        
        for (int i = 0; i < 1; i ++) {
            if (![equno isEqualToString:@"(null)"]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(KScreenWidth - 290 + 1 * (150), (70 - 44)/2, 90, 44);
                [button setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
                button.layer.borderColor = TITLE_COLOR.CGColor;
                button.layer.borderWidth = 1;
                button.layer.cornerRadius = 3;
                button.layer.masksToBounds = YES;
                button.tag = indexPath.row;
                [button setTitle:@"确认收货" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            } else {
                content.text = @"暂无添加设备";
            }
        }

    } else {
        if ([status isEqualToString:@"CONSIGN"]) {
            status = @"待发货";
        } else if ([status isEqualToString:@"CLOSED"]) {
            status = @"已完成";
        } else if ([status isEqualToString:@"CANCEL"]) {
            status = @"作废";
        } else if ([status isEqualToString:@"COMPARED"]) {
            status = @"已对账";
        } else if ([status isEqualToString:@"SETTLED"]) {
            status = @"已结算";
        } else {
            status = @"其他状态";
        }
        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 20 - 90, 0, 90, 70)];
        statusLab.font = [UIFont systemFontOfSize:16];
        statusLab.textAlignment = NSTextAlignmentLeft;
        statusLab.text = status;
        statusLab.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:statusLab];
        if ([equno isEqualToString:@"(null)"]) {
            statusLab.text = @"";
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    bgView.backgroundColor = BG_COLOR;
    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 200, 40)];
    labe.font = [UIFont systemFontOfSize:17];
    labe.text = @"订单设备列表";
    [bgView addSubview:labe];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (void)btnAction:(UIButton *)sender {

    NSLog(@"%ld",sender.tag);
    GDModel *model = _numberArr[sender.tag];
    NSString *str_dev = [NSString stringWithFormat:@"%@",model.equno];
    NSString *number = [NSString stringWithFormat:@"%@",model.number];
    NSString *t2t1flag = [NSString stringWithFormat:@"%@",model.t2t1flag];
    
    if ([sender.currentTitle isEqualToString:@"确认收货"]) {
        _btn = sender;
        // 订单异常
        if ([t2t1flag isEqualToString:@"T1"]) {
            // V1
            YCSHView_V1 *yc_v1 = [[YCSHView_V1 alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            yc_v1.gdmodel = model;
            [self.view addSubview:yc_v1];
        } else {
            // v2
            YCSHView *ycshView = [[YCSHView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            ycshView.gdmodel = model;
            NSString *contactremark = [NSString stringWithFormat:@"%@",_model.contactremark];
            ycshView.orderNote = contactremark;
            ycshView.titleLab.text = @"T2收货";
            [self.view addSubview:ycshView];
        }
        
    } else {
        // 正常收货 判断是V1或者V2
        if ([[NSString stringWithFormat:@"%@",_model.t2t1flag] isEqualToString:@"T2"]) {
            // T2
            [self loadDataWithReceiveDevice_V2:number];
            
        } else if ([[NSString stringWithFormat:@"%@",_model.t2t1flag] isEqualToString:@"T1"]) {
            // T1
            [self loadDataWithReceiveDevice:str_dev];
        }
    }
}

#pragma mark - 查询设备
- (void)searchOrderWithKeyWord:(NSString *)keyWord {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *accountId = @"tgt_ipad";
    bool bool_true = true;
    NSDictionary *dataDic = @{@"orderno":keyWord,@"showbill":@(bool_true)};
    NSString *sign_md5 = [V2HttpTool searchOrderWithKeyWord:dataDic requestTime:requestTime];
    NSDictionary *dic = @{@"accountId":accountId,
                          @"data":dataDic,
                          @"requestTime":@"time_test",
                          @"serviceName":@"mobileQuery",
                          @"sign":sign_md5,
                          @"version":@"OSSV2"};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.mobileQuery",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    request.timeoutInterval = 10;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){

            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            NSArray *dataArr = dict[@"data"];
            if (dataArr.count != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    _numberArr = [GDModel mj_objectArrayWithKeyValuesArray:dataArr];
                    NSMutableArray *statusArr = [NSMutableArray array];
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (GDModel *model2 in _numberArr) {
                        [statusArr addObject:model2.channelorderstatus];
                        NSString *str = [_inputStr stringByReplacingOccurrencesOfString:@"TGT" withString:@""];
                        str = [str uppercaseString];
                        if ([model2.equno containsString:str]||[model2.membername containsString:str]||[model2.membercellphone containsString:str]) {
                            [mArr insertObject:model2 atIndex:0];
                        } else {
                            [mArr addObject:model2];
                        }
                    }
                    _numberArr = mArr;
                    [_tableView reloadData];
                    
                    if (![statusArr containsObject:@"RECEIVED"]) {
                        // 如果接口查询的所有状态均为已收货，则收货完成，调用画板给用户签字并提交oss V2
//                        [self showHuaBanView];
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }
        } else {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }];
    [task resume];
}
#pragma mark - 签字画板
- (void)showHuaBanView {
    if (isUpImg == YES) {
        return;
    }
    QianZiView *qzView = [[QianZiView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:qzView];
    [qzView initViewsWithSaveImageBlock:^(UIImage *image) {
        
        UIImage *img_sy = [self addText:image text:[NSString stringWithFormat:@"订单号：%@\n电话：%@",_model.orderno,_model.membercellphone]];
        [UIView animateWithDuration:.3 animations:^{
            qzView.alpha = 0;
            [qzView removeFromSuperview];
        }];
        // 此处保存图片
        NSData *data = UIImageJPEGRepresentation(img_sy,0.5);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
        [data writeToFile:filePath atomically:YES];
        
        // 此处上传照片
        [self submitQianZi:img_sy];
        
        [self reloadHHView];
    }];
}
-(UIImage *)addText:(UIImage *)image text:(NSString *)text
{
    int w = image.size.width;
    int h = image.size.height;
    UIGraphicsBeginImageContext(image.size);
    [[UIColor whiteColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:25.0];
    [text drawInRect:CGRectMake((image.size.width)/2, 0, self.view.bounds.size.width, 200) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)reloadHHView {
    
    [hhView removeFromSuperview];
    hhView = [[HHView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth,260)];
    [hhView _loadData:_model];
    [_scrollView addSubview:hhView];
    
    NSString *deliverypath = [NSString stringWithFormat:@"%@",_model.deliverypath];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",_model.receivedpath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    
    if (deliveryData == nil && receivedData == nil) {
        if ([deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
            hhView.height = 260;
        } else {
            hhView.height = 260 + 40;
        }
    } else {
        hhView.height = 260 + 40;
    }
    _tableView.frame = CGRectMake(0, hhView.bottom + 10, KScreenWidth, KScreenHeight - 64 - hhView.height - 10);
}
#pragma mark - V2收货
- (void)loadDataWithReceiveDevice_V2:(NSString *)number {
    

    NSString *accountId = @"tgt_ipad";
    
    bool bool_false = false;
    
    NSString *gh_time_str = [NSString stringWithFormat:@"%@",[_model.expectreturntime componentsSeparatedByString:@" "].firstObject];
    NSString *settletype = @"";
    if (hhView.radioBtn2.btn.selected == YES) {
        settletype = @"TUGE";
    } else if (hhView.radioBtn3.btn.selected == YES) {
        settletype = @"CHANNE";
    }
    // 仓库名
    NSString *ck_str = [hhView.ckTfView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *fck_str = [hhView.fckTfView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:fck_str forKey:@"subwarehosename"];
    [dataDic setObject:@"" forKey:@"damagereason"];
    [dataDic setObject:@"0" forKey:@"damagemoney"];
    [dataDic setObject:number forKey:@"number"];
    [dataDic setObject:gh_time_str forKey:@"actreturndate"];
    [dataDic setObject:@"0" forKey:@"delaynotusefee"];
    [dataDic setObject:ck_str forKey:@"warehosename"];
    [dataDic setObject:settletype forKey:@"settletype"];
    [dataDic setObject:@"0" forKey:@"extendfee"];
    [dataDic setObject:@(bool_false) forKey:@"delaynotuseflag"];
    [dataDic setObject:@"" forKey:@"delayreason"];
    /*  */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    [dataDic setObject:DeviceID forKey:@"code"];
    
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"mobileReceivedOrder",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"mobileReceivedOrder",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
                    [self searchOrderWithKeyWord:[NSString stringWithFormat:@"%@",_model.orderno]];
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
#pragma mark - V1收货
- (void)loadDataWithReceiveDevice:(NSString *)dev  {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    
    bool bool_true = true;
    NSDictionary *dic = @{@"sn":dev,
                          @"rebackWh":@"CN-SZ001",
                          @"rebackUser":creator,
                          @"equSimStatus":@1,
                          @"chargingSocketStatus":@(bool_true),
                          @"shellStatus":@(bool_true),
                          @"chargingHeadStatus":@(bool_true),
                          @"dataLineStatus":@(bool_true),
                          @"holsterStatus":@(bool_true),
                          @"demurrageStatus":@(bool_true),
                          @"note":@"正常收货"};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *keyStr = [V1HttpTool getKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.reback",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        [hud hideAnimated:YES];
        if ([dict[@"code"] isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self searchOrderWithKeyWord:[NSString stringWithFormat:@"%@",_model.orderno]];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        NSLog(@"%@",error);
    }];
}

#pragma mark - 签字提交
- (void)submitQianZi:(UIImage *)image {
    
    NSString *accountId = @"tgt_ipad";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0XFF];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    NSString *aString = string;
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:_model.orderno forKey:@"orderno"];
    [dataDic setObject:aString forKey:@"receivednamesign"];
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"uploadPicture",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"uploadPicture",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.uploadPicture",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    isUpImg = YES;
                    [qzBtn setTitle:@"已签字" forState:UIControlStateNormal];
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
