//
//  OrderListViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderListViewController.h"
#import "ScanViewController.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"
#import "GDModel.h"
#import "XGGHttpsManager.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.、
    
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"发货"];
    UIButton *button_gotoHome = [UIButton buttonWithType:UIButtonTypeCustom];
    button_gotoHome.frame = CGRectMake(KScreenWidth - 100 - 15, 20, 100, 44);
    button_gotoHome.backgroundColor = [UIColor clearColor];
    [button_gotoHome setTitle:@"匹配设备" forState:UIControlStateNormal];
    button_gotoHome.titleLabel.font = [UIFont systemFontOfSize:15];
    [button_gotoHome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_gotoHome addTarget:self action:@selector(getEqunoAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:button_gotoHome];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDevData:) name:@"dev" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadyjtData:) name:@"yjt" object:nil];
    
    [self cxDD];
    [self searchOrderWithKeyWord:_model.orderno];
    
    _equnoTableView = [[EqunoTableView alloc] initWithFrame:CGRectMake(KScreenWidth - 250, 64, 250, 600) style:UITableViewStylePlain];
    _equnoTableView.hidden = YES;
    _equnoTableView.devCount = _devCount;
//    [self.view addSubview:_equnoTableView];
    
    NSString *deliverypath = [NSString stringWithFormat:@"%@",_model.deliverypath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    if (deliveryData == nil) {
        if ([deliverypath isEqualToString:@"(null)"]) {
            isUpImg = NO;
        } else {
            isUpImg = YES;
        }
    } else {
        isUpImg = YES;
    }
}

- (void)getEqunoAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"匹配设备"]) {
        [self getEquno];
        _equnoTableView.hidden = NO;
        [sender setTitle:@"关闭匹配" forState:UIControlStateNormal];
    } else {
        _equnoTableView.hidden = YES;
        _equnoTableView.dataList = @[];
        [sender setTitle:@"匹配设备" forState:UIControlStateNormal];
    }
}
- (void)getEquno {
    
    NSString *accountId = @"tgt_ipad";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:_model.orderno forKey:@"orderno"];
    [dataDic setObject:@"TGT" forKey:@"equno"];
    
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_equnoTableView animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.queryAvalibleEquipment",BaseURL_V2];
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
                    
                    NSLog(@"%@",dict);
                    NSArray *data = dict[@"data"];
                    _equnoTableView.dataList = data;
                    
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"匹配失败" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    
    [task resume];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dev" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yjt" object:nil];
}

- (void)fillAlert2 {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入金额"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认并拍取小票", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1003;
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.placeholder = @"请输入收取金额";
    tf.text = @"500";
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1001) {
        
        if (buttonIndex == 0) {
            // 取消
        } else if (buttonIndex == 1) {
            // 预授权
            _yjNumber = nil;
            [self takePhoto];
            
        } else if (buttonIndex == 2) {
            // 支付宝
            _yjNumber = nil;
            [self takePhoto];
        } else if (buttonIndex == 3) {
            // 现金收取 拍照
            [self fillAlert2];
        }
        
    } else if (alertView.tag == 1003){
        
        if (buttonIndex == 0) {
            // 取消
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            
        } else {
            // 确认
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            NSLog(@"%@",inputField.text);
            _yjNumber = inputField.text;
            [self takePhoto];
        }
    }
}

- (void)cxDD {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    qhView = [[QHView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth, 250)];
    [qhView _loadData:_model];
    [_scrollView addSubview:qhView];
    
    qhView.xpimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [qhView.xpimageView addGestureRecognizer:tap];
    
    [self addDevAndFhUI];
}
- (void)addDevAndFhUI {
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, qhView.height+10, KScreenWidth, KScreenHeight - 64-10-qhView.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
    addDevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addDevBtn.frame = CGRectMake(15, 5, 90, 40);
    addDevBtn.layer.cornerRadius = 3;
    addDevBtn.layer.masksToBounds = YES;
    addDevBtn.layer.borderWidth = 1;
    addDevBtn.layer.borderColor = TITLE_COLOR.CGColor;
    addDevBtn.backgroundColor = [UIColor whiteColor];
    addDevBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addDevBtn addTarget:self action:@selector(addDev:) forControlEvents:UIControlEventTouchUpInside];
    [addDevBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [addDevBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [bgView addSubview:addDevBtn];
    
    [addDevBtn setTitle:@"添加设备" forState:UIControlStateNormal];
    ztLab = [[UILabel alloc] initWithFrame:CGRectMake(addDevBtn.right + 20, 15, 200, 30)];
    ztLab.font = [UIFont systemFontOfSize:15];
    _devCount = _model.ticketcount;
    ztLab.text = [NSString stringWithFormat:@"已添加 %ld/%@",(long)_dataList.count,_devCount];
    [bgView addSubview:ztLab];
    
    UIButton *sendDevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendDevBtn.frame = CGRectMake(KScreenWidth - 105, 5, 90, 40);
    sendDevBtn.layer.cornerRadius = 3;
    sendDevBtn.layer.masksToBounds = YES;
    sendDevBtn.layer.borderWidth = 1;
    sendDevBtn.layer.borderColor = TITLE_COLOR.CGColor;
    sendDevBtn.backgroundColor = [UIColor whiteColor];
    sendDevBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendDevBtn setTitle:@"确认发货" forState:UIControlStateNormal];
    [sendDevBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [sendDevBtn addTarget:self action:@selector(sendDevAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendDevBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [bgView addSubview:sendDevBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, KScreenWidth - 25, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:line];
    
    [_scrollView setContentSize:CGSizeMake(KScreenWidth, bgView.bottom)];
    
    _devTableView = [[DevTableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, bgView.height - 50) style:UITableViewStylePlain];
    _devTableView.dataList = [NSMutableArray arrayWithArray:_dataList];
    [bgView addSubview:_devTableView];
    /*
     if ([_devNum isEqualToString:@"T2"]) {
     
     _devTableView = [[DevTableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, bgView.height - 50) style:UITableViewStylePlain];
     _devTableView.dataList = [NSMutableArray arrayWithArray:_dataList];
     [bgView addSubview:_devTableView];
     }else {
     
     _t1TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, bgView.height - 50) style:UITableViewStylePlain];
     _t1TableView.delegate = self;
     _t1TableView.dataSource = self;
     [bgView addSubview:_t1TableView];
     }
     */
}
#pragma mark - 确认发货
- (void)sendDevAction:(UIButton *)sender {
    
    // 如果是渠道代收押金直接确认发货，如果是途鸽收取，弹框提示是现场收取还是预授权，现场收取：弹出输入框（默认500），预授权：调用相机拍照
    // 发货逻辑 T2直接批量处理。T1需要在查询V1订单，并在后台默认生成押金条，在押金条中发货该设备。（多设备需要并行处理还是一台一台串行添加？）

    NSString *t2t1flag = [NSString stringWithFormat:@"%@",_model.t2t1flag];
    // 渠道代收 直接确认发货
    if ([t2t1flag isEqualToString:@"T1"]) {
        // T1
        [self loadDataWithSendDevice];
    } else {
        // T2
        [self loadDataWithSendDevice_V2:0];
    }
    
}

#pragma mark - 发货
// V2
- (void)loadDataWithSendDevice_V2:(NSInteger)index {
    
    NSMutableArray *gdNumber = [NSMutableArray array];
    NSMutableArray *gdNumber_index = [NSMutableArray array];
    NSMutableArray *sbNumber = [NSMutableArray array];
    NSMutableArray *allNumber = [NSMutableArray array];
    for (GDModel *model1 in _numberArr) {
        NSString *number = [NSString stringWithFormat:@"%@",model1.number];
        if ([number isEqualToString:@""]||[number isEqualToString:@"(null)"]||[number isEqualToString:@"<null>"]) {
            
        } else {
            NSString *equno = model1.equno;
            if (equno.length == 0) {
                [gdNumber addObject:model1.number];
                [gdNumber_index addObject:model1.number];
            }
        }
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
    NSArray *arr_dev = [NSArray arrayWithContentsOfFile:filename];
    
    if (arr_dev.count != [_devCount integerValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先添加完整设备数量" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    for (NSDictionary *dict in arr_dev) {
        NSString *dev = dict[@"equno"];
        NSString *status = dict[@"status"];
        NSString *number = dict[@"number"];
        [gdNumber removeObject:number];
        if ([status isEqualToString:@"BAD"]) {
            [allNumber addObject:dict];
        }
        if ([status isEqualToString:@"待发货"]) {
            [sbNumber addObject:dev];
        }
    }
    NSLog(@"%@",gdNumber);
    NSLog(@"%@ - allNumber:%@",sbNumber,allNumber);
    
    if (index == gdNumber_index.count) {
        
        NSString *msg = @"";
        if (allNumber.count != 0) {
            for (NSDictionary *dict_bad in allNumber) {
                NSString *dev_str = [NSString stringWithFormat:@"%@",dict_bad[@"equno"]];
                NSString *msg_str = [NSString stringWithFormat:@"%@",dict_bad[@"msg"]];
                msg = [NSString stringWithFormat:@"%@%@(%@)\n",msg,dev_str,msg_str];
            }
            msg = [msg substringToIndex:msg.length - 1];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        } else {
        
            if (isUpImg == NO) {
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths    objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                NSMutableArray *arr_plist = [NSMutableArray arrayWithContentsOfFile:filename];
                NSMutableArray *dev_arr_plist = [NSMutableArray array];
                for (NSDictionary *dic in arr_plist) {
                    NSString *status = dic[@"status"];
                    [dev_arr_plist addObject:status];
                }
                if (![dev_arr_plist containsObject:@"待发货"]) {
                    
                    NSString *channel = [NSString stringWithFormat:@"%@",_model.depositmode];
                    if ([channel isEqualToString:@"CSTTGTRECEIVE"]) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成发货，选择途鸽代收方式" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预授权收取"@" ", nil];
                        alert.tag = 1001;
                        [alert show];
                    } else {
                        // 渠道代收提示
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发货完成" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
            } else {
                // 途鸽代收提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发货完成" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        // 更新工单
        [self searchOrderWithKeyWord:_model.orderno];
        return;
    }
    
    NSString *accountId = @"tgt_ipad";
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    /*   */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    
    NSDictionary *dataDic = @{@"number":gdNumber[0],@"equno":sbNumber[0],@"operator":creator,@"code":DeviceID};
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"mobileDeliveryOrder",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"accountId":accountId,
                          @"data":dataDic,
                          @"requestTime":@"time_test",
                          @"serviceName":@"mobileDeliveryOrder",
                          @"sign":sign_md5,
                          @"version":@"OSSV2"};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.mobileDeliveryOrder",BaseURL_V2];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data_dic;
    request.timeoutInterval = 10;
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hideAnimated:YES];
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"resultCode"]];
                if ([code isEqualToString:@"0000"]) {
                    
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                    NSString *path=[paths    objectAtIndex:0];
                    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
                    NSMutableArray *dev_arr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        NSString *equno = dic[@"equno"];
//                        for (NSString *str_equno in sbNumber) {
                            if ([equno isEqualToString:sbNumber[0]]) {
                                [dic setValue:@"RECEIVED" forKey:@"status"];
                                [dic setValue:gdNumber[0] forKey:@"number"];
                            }
//                        }
                        [dev_arr addObject:dic];
                    }
                    [dev_arr writeToFile:filename atomically:YES];
                    NSArray *arr1 = [NSArray arrayWithContentsOfFile:filename];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:arr1 forKey:@"devList"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
                } else {
                
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                    NSString *path=[paths    objectAtIndex:0];
                    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
                    NSMutableArray *dev_arr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        NSString *equno = dic[@"equno"];
                        //                        for (NSString *str_equno in sbNumber) {
                        if ([equno isEqualToString:sbNumber[0]]) {
                            [dic setValue:@"BAD" forKey:@"status"];
                            [dic setValue:resultMessage forKey:@"msg"];
                            [dic setValue:gdNumber[0] forKey:@"number"];
                        }
                        //                        }
                        [dev_arr addObject:dic];
                    }
                    [dev_arr writeToFile:filename atomically:YES];
                    NSArray *arr1 = [NSArray arrayWithContentsOfFile:filename];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:arr1 forKey:@"devList"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
                }
                NSInteger integer = index + 1;
                [self loadDataWithSendDevice_V2:integer];
            });
            
        } else {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hideAnimated:YES];
            });
        }
    }];
    
    [task resume];
}
// V1
- (void)loadDataWithSendDevice {
    
    NSMutableArray *gdNumber = [NSMutableArray array];
    NSMutableArray *sbNumber = [NSMutableArray array];
    for (GDModel *model1 in _numberArr) {
        NSString *equno = [NSString stringWithFormat:@"%@",model1.equno];
        NSString *number = [NSString stringWithFormat:@"%@",model1.number];
        if ([number isEqualToString:@""]||[number isEqualToString:@"(null)"]||[number isEqualToString:@"<null>"]) {
            
        } else {
            NSDictionary *dic = @{@"orderNo":model1.number};
            [gdNumber addObject:dic];
        }
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
    NSArray *arr_dev = [NSArray arrayWithContentsOfFile:filename];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in arr_dev) {
        NSString *dev = dict[@"equno"];
        NSString *status = dict[@"status"];
        if ([status isEqualToString:@"待发货"] || [status isEqualToString:@"RECEIVED"]) {
            NSDictionary *dic = @{@"sn":dev};
            [sbNumber addObject:dic];
            [mArr addObject:dict];
        }
    }
    NSLog(@"T1确认发货");
    NSLog(@"%@",gdNumber);
    NSLog(@"%@",sbNumber);
    
    NSString *keyStr = [V1HttpTool getKey];
    
    NSArray *snArr = sbNumber;
    
    NSArray *orderArr = gdNumber;
    
    if (sbNumber.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先添加设备" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    
    NSDictionary *dic = @{@"equipments":snArr,
                          @"orders":orderArr,
                          @"creator":creator};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.ship",BaseURL_V1,keyStr];
//    [LBProgressHUD showHUDto:self.view animated:YES];
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
       
        NSArray *arr = dict[@"equipments"];
        NSString *msg = @"";
        for (NSDictionary *dic in arr) {
            NSString *sn = [NSString stringWithFormat:@"%@",dic[@"sn"]];
            NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
            if ([status isEqualToString:@"0"]) {
                // 成功
                msg = [NSString stringWithFormat:@"%@%@（发货成功）\n",msg,sn];
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths    objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
                NSMutableArray *dev_arr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    NSString *equno = dic[@"equno"];
                    if ([sn isEqualToString:equno]) {
                        [dic setValue:@"RECEIVED" forKey:@"status"];
                    }
                    [dev_arr addObject:dic];
                }
                [dev_arr writeToFile:filename atomically:YES];
                NSArray *arr1 = [NSArray arrayWithContentsOfFile:filename];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:arr1 forKey:@"devList"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
                
            } else if ([status isEqualToString:@"-1"]) {
                msg = [NSString stringWithFormat:@"%@%@（设备不存在）\n",msg,sn];
            } else if ([status isEqualToString:@"-2"]) {
                msg = [NSString stringWithFormat:@"%@%@（设备不是库存状态）\n",msg,sn];
            } else if ([status isEqualToString:@"-3"]) {
                msg = [NSString stringWithFormat:@"%@%@（卡1为空）\n",msg,sn];
            } else if ([status isEqualToString:@"-4"]) {
                msg = [NSString stringWithFormat:@"%@%@（卡1流量不足）\n",msg,sn];
            } else if ([status isEqualToString:@"-5"]) {
                msg = [NSString stringWithFormat:@"%@%@（发货失败）\n",msg,sn];
            } else if ([status isEqualToString:@"-6"]) {
                msg = [NSString stringWithFormat:@"%@%@（无匹配订单）\n",msg,sn];
            }
        }
         
        msg = [NSString stringWithFormat:@"%@",[msg substringToIndex:msg.length - 1]];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
        NSMutableArray *arr_plist = [NSMutableArray arrayWithContentsOfFile:filename];
        NSMutableArray *dev_arr_plist = [NSMutableArray array];
        for (NSDictionary *dic in arr_plist) {
            NSString *status = dic[@"status"];
            [dev_arr_plist addObject:status];
        }
        if (![dev_arr_plist containsObject:@"待发货"]) {
            
            NSString *channel = [NSString stringWithFormat:@"%@",_model.depositmode];
            if ([channel isEqualToString:@"CSTTGTRECEIVE"]) {
                if (isUpImg == NO) {
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成发货，选择途鸽代收方式" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"预授权收取"@" ", nil];
                    alert.tag = 1001;
                    [alert show];
                    
                } else {
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成发货" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成发货" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [hud1 hideAnimated:YES];
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [hud1 hideAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发货失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

#pragma mark - 添加设备
- (void)addDev:(UIButton *)sender {
    
    if ([_devCount integerValue] == _dataList.count) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设备已添加完成" message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ScanViewController *scanVc = [[ScanViewController alloc] init];
    scanVc.devCount = _devCount;
    scanVc.orderno = _model.orderno;
    scanVc.flag = _model.t2t1flag;
    [self.navigationController pushViewController:scanVc animated:YES];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
    if (_dataList == nil) {
        _dataList = @[];
    }
    [_dataList writeToFile:filename atomically:YES];
}
- (void)reloadDevData:(NSNotification *)nitification {
    
    _dataList = nitification.userInfo[@"devList"];
    NSString *delete = nitification.userInfo[@"delete"];
    ztLab.text = [NSString stringWithFormat:@"已添加 %ld/%@",(long)_dataList.count,_devCount];
    if ([delete isEqualToString:@"1"]) {
        return;
    }
    _devTableView.dataList = [NSMutableArray arrayWithArray:_dataList];
    [_devTableView reloadData];
}

- (void)reloadyjtData:(NSNotification *)nitification {
    
    NSDictionary *dic = nitification.userInfo;
    NSString *dev_number = [NSString stringWithFormat:@"%@",dic[@"dev_number"]];
    if (dev_number.length == 14) {
        
        [addDevBtn setTitle:@"押金条" forState:UIControlStateNormal];
        addDevBtn.backgroundColor = [UIColor lightGrayColor];
        addDevBtn.userInteractionEnabled = NO;
    }
    self.t1DataList = @[dic];
    [_t1TableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _t1DataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = (NSDictionary *)_t1DataList[indexPath.row];
    UILabel *yjtNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 300, 30)];
    yjtNum.font = [UIFont systemFontOfSize:17];
    yjtNum.text = [NSString stringWithFormat:@"押金条：%@",dic[@"yjt_number"]];
    [cell.contentView addSubview:yjtNum];
    
    UILabel *yjsLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 300, 30)];
    yjsLab.font = [UIFont systemFontOfSize:16];
    yjsLab.textColor = [UIColor darkGrayColor];
    yjsLab.text = [NSString stringWithFormat:@"押金收取：%@        待付押金：%@",dic[@"yjsq"],dic[@"dfyj"]];
    [cell.contentView addSubview:yjsLab];
    
    UILabel *devNum = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 330, 10, 300, 30)];
    devNum.font = [UIFont systemFontOfSize:17];
    //    devNum.textColor = [UIColor darkGrayColor];
    devNum.text = [NSString stringWithFormat:@"设备号：%@",dic[@"dev_number"]];
    [cell.contentView addSubview:devNum];
    
    UILabel *sjLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 330, 40, 300, 30)];
    sjLab.font = [UIFont systemFontOfSize:16];
    sjLab.textColor = [UIColor darkGrayColor];
    sjLab.text = [NSString stringWithFormat:@"创建时间：%@",dic[@"collection_date"]];
    [cell.contentView addSubview:sjLab];
    
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 79, KScreenWidth - 40, 1)];
    line1.backgroundColor = BG_COLOR;
    [cell.contentView addSubview:line1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJTView *yjtView = [[YJTView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    yjtView.dic = (NSDictionary *)_t1DataList[indexPath.row];
    [self.view addSubview:yjtView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - 拍照
- (void)takePhoto {
    
    // 资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    // 判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        // 资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{ }];
    }else {
        NSLog(@"该设备无摄像头");
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    // 当图片不为空时显示图片并保存图片
    if (image != nil) {
        
        UIImage *img_sy = [self addText:image text:[NSString stringWithFormat:@"订单号：%@\n电话：%@",_model.orderno,_model.membercellphone]];
        NSData *data = UIImageJPEGRepresentation(img_sy,0.5);
        // 保存本地
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
        [data writeToFile:filePath atomically:YES];
        
        
        qhView.height = 250 + 200;
        bgView.top = qhView.height+10;
        bgView.height = KScreenHeight - 64-10-qhView.height;
        
        qhView.leftLabel.hidden = NO;
        qhView.xpimageView.hidden = NO;
        qhView.xpimageView.image = [UIImage imageWithData:data];
        
        if (_yjNumber != nil) {
            qhView.yjRightLabTitle.hidden = NO;
            qhView.yjRightLabContent.hidden = NO;
            qhView.yjRightLabContent.text = _yjNumber;
        } else {
            qhView.yjRightLabTitle.hidden = YES;
            qhView.yjRightLabContent.hidden = YES;
        }
        // 调用v2接口上传图片和订单号
        [self submitQianZi:[UIImage imageWithData:data]];
    }
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage *)addText:(UIImage *)image text:(NSString *)text
{
    int w = image.size.width;
    int h = image.size.height;
    UIGraphicsBeginImageContext(image.size);
    [[UIColor whiteColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:25.0];
    [text drawInRect:CGRectMake((image.size.width)/2, 0, self.view.bounds.size.width,200) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    NSString *orderno = [NSString stringWithFormat:@"%@",_model.orderno];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:orderno forKey:@"orderno"];
    [dataDic setObject:aString forKey:@"deliveryuploadpicture"];
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
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
//                [hud hideAnimated:YES];
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    isUpImg = YES;
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
            });
        }
    }];
    
    [task resume];
}

#pragma mark - 显示图片
- (void)tapAction: (UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    UIImage *image = imageView.image;
    
    UIView *imgbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imgbgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imgbgView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight - 240)];
    bgimageView.image = image;
    [imgbgView addSubview:bgimageView];
    bgimageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap:)];
    tap1.numberOfTapsRequired = 1;
    [imgbgView addGestureRecognizer:tap1];
}
- (void)tap2:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:.3 animations:^{
        tap.view.transform = CGAffineTransformScale(tap.view.transform, 1.6, 1.6);
    }];
}
-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender{
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        self.currentScale = paramSender.scale;
    }else if(paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f){
        paramSender.scale = self.currentScale;
    }
    if (paramSender.scale !=NAN && paramSender.scale != 0.0) {
        paramSender.view.transform = CGAffineTransformMakeScale(paramSender.scale, paramSender.scale);
    }
}
// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
- (void)popTap:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:.25 animations:^{
        tap.view .alpha = 0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}


#pragma mark - 查询工单
- (void)searchOrderWithKeyWord:(NSString *)keyWord {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *accountId = @"tgt_ipad";
    bool bool_true = true;
    bool bool_false = false;
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
    NSURLSession *session=[NSURLSession  sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData*_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        
        if(error == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            NSArray *dataArr = dict[@"data"];
            if (dict.count == 3) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    _numberArr = [GDModel mj_objectArrayWithKeyValuesArray:dataArr];
                    
                    NSMutableArray *sbNumber = [NSMutableArray array];
                    for (GDModel *model1 in _numberArr) {
                        NSString *equno = [NSString stringWithFormat:@"%@",model1.equno];
                        NSString *status = [NSString stringWithFormat:@"%@",model1.channelorderstatus];
                        NSString *number = [NSString stringWithFormat:@"%@",model1.number];
                        if ([equno isEqualToString:@""]||[equno isEqualToString:@"(null)"]||[equno isEqualToString:@"<null>"]) {
                            
                        } else {
                            NSDictionary *dic = @{@"equno":equno,
                                                  @"status":status,
                                                  @"number":number};
                            [sbNumber addObject:dic];
                        }
                    }
                    
                    _dataList = sbNumber;
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                    NSString *path=[paths objectAtIndex:0];
                    NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
                    if (_dataList == nil) {
                        _dataList = @[];
                    }
                    [_dataList writeToFile:filename atomically:YES];
                    ztLab.text = [NSString stringWithFormat:@"已添加 %ld/%@",(long)_dataList.count,_devCount];
                    _devTableView.dataList = [NSMutableArray arrayWithArray:_dataList];
                    [_devTableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            NSLog(@"%@",error);
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
