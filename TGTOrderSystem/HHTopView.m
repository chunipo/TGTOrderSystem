//
//  HHTopView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/17.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HHTopView.h"
#import "YCTableView.h"

@implementation HHTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setYjType:(NSString *)yjType {
    _yjType = yjType;
    
    [self _initViews];
    [self _initCloseBtn];
}
- (void)tapAction {

    [self.sjghTfView.textField resignFirstResponder];
    [self.yqfyTfView.textField resignFirstResponder];
    [self.ycghTfView.textField resignFirstResponder];
    [self.shyyTfView.textField resignFirstResponder];
    [self.shkfTfView.textField resignFirstResponder];
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
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 50)];
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_titleLab];
    
    NSArray *ycLeftName;
    if ([_yjType isEqualToString:@"途鸽代收"]) {
        ycLeftName = @[@"延期未使用标示",@"实际归还日期",
                       @"延期未使用费用",@"延迟归还原因",
                       @"设备损坏原因",@"设备损坏扣费"];
    } else {
        ycLeftName = @[@"延期未使用标示",@"实际归还日期",
                       @"延期未使用费用",@"延迟归还原因",
                       @"设备损坏原因",@"设备损坏扣费",@"结算方式"];
    }
    
    for (int i = 0; i < ycLeftName.count; i ++) {
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10 + i % 2 * (115 + (bgView.width - 280)/2), _titleLab.bottom + 5 + i / 2 * (30 + 3), 120, 30)];
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.text = ycLeftName[i];
        lab1.textColor = [UIColor darkGrayColor];
        lab1.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:lab1];
        
        switch (i) {
            case 0: {
                
                _radioBtn1 = [[RadioBtn alloc] initWithFrame:CGRectMake(lab1.right + 10 , lab1.top, 80, 30)];
                [_radioBtn1 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"  " action:@selector(t1Action:)];
                [bgView addSubview:_radioBtn1];
            }
                break;
            case 1: {
                
                _sjghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_sjghTfView setTextFieldPlaceholder:@"选择日期"];
                [bgView addSubview: _sjghTfView];
            }
                break;
            case 2: {
                
                _yqfyTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_yqfyTfView setTextFieldPlaceholder:@"填写延期费用"];
                [bgView addSubview: _yqfyTfView];
            }
                break;
            case 3: {
                
                _ycghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_ycghTfView setTextFieldPlaceholder:@"填写原因"];
                [bgView addSubview: _ycghTfView];

            }
                break;
            case 4: {
                
                _shyyTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_shyyTfView setTextFieldPlaceholder:@"填写原因"];
                [bgView addSubview: _shyyTfView];
            }
                break;
            case 5: {
                
                _shkfTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_shkfTfView setTextFieldPlaceholder:@"填写扣费数额"];
                [bgView addSubview: _shkfTfView];
            }
                break;
            case 6: {
                
                _jsfsTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(lab1.right + 5 , lab1.top+2.5, (bgView.width - 280)/2 - 30, 25)];
                [_jsfsTfView setTextFieldPlaceholder:@"选择结算方式"];
                [bgView addSubview: _jsfsTfView];
            }
                break;
            default: break;
        }
    }
    float tab_top;
    if ([_yjType isEqualToString:@"途鸽代收"]) {
        tab_top = _shkfTfView.bottom + 10;
    } else {
        tab_top = _jsfsTfView.bottom + 10;
    }
    _ycTableView = [[YCTableView alloc] initWithFrame:CGRectMake(0, tab_top, bgView.width, bgView.height - tab_top - 75) style:UITableViewStylePlain];
    _dataList = @[];
    _ycTableView.dataList = [NSMutableArray arrayWithArray:_dataList];
    [bgView addSubview:_ycTableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, bgView.height - 55, bgView.width-40, 45);
    button.backgroundColor = TITLE_COLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:@"确认归还" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
}
- (void)buttonAction:(UIButton *)sender {
    NSString *number = [NSString stringWithFormat:@"%@",_gdmodel.number];
    NSString *t2t1flag = [NSString stringWithFormat:@"%@",_gdmodel.t2t1flag];
    if ([t2t1flag isEqualToString:@"T2"]||[t2t1flag isEqualToString:@"SCP"]) {
        [self loadDataWithReceiveDevice_V2:number];
    } else if ([t2t1flag isEqualToString:@"T1"]) {
        [self loadDataWithReceiveDevice];
    }
}

#pragma mark - V2收货
- (void)loadDataWithReceiveDevice_V2:(NSString *)number {
    
    NSString *accountId = @"tgt_ipad";
    
    bool bool_false = false;
    /*  */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
  
    NSDictionary *dataDic = @{@"number":number,
                              @"delaynotuseflag":@(bool_false),     // 延期未使用
                              @"actreturndate":@"",                 // 实际归还时间
                              @"contactremark":@"",                 // 备注
                              @"returndate":@"",                    // 寄回时间
                              @"delaynotusefee":@"0.00",            // 滞纳金
                              @"delayreason":@"",                   // 设备损坏原因
                              @"damagemoney":@"0.00",               // 设备损坏扣费
                              @"extendfee":@"0.00",                 // 续租费用
                              @"settletype":@"TUGE",                // 扣款、滞纳金和续租费用收取方式
                              @"warehosename":@"北京主仓库",          // 主仓库名称（完整主仓库名称）
                              @"subwarehosename":@"北京分仓01",       // 分仓库名称（完成分仓库名称）
                              @"code":DeviceID
                              };
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"mobileReceivedOrder",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"accountId":accountId,
                          @"data":dataDic,
                          @"requestTime":@"time_test",
                          @"serviceName":@"0.00",
                          @"sign":sign_md5,
                          @"version":@"OSSV2"};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
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
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ycshwc" object:nil];
                    [self hideView];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            NSLog(@"%@",error);
        }
    }];
    
    [task resume];
}

#pragma mark - V1收货
- (void)loadDataWithReceiveDevice {
    
    NSArray *listData = _ycTableView.dataList;
    bool bool_chargingSocketStatus = true;
    bool bool_shellStatus = true;
    bool bool_chargingHeadStatus = true;
    bool bool_dataLineStatus = true;
    bool bool_holsterStatus = true;
    bool bool_demurrageStatus = true;
    
    NSInteger equSimStatus = 1;  // 1:完好 2:待维修 3：损毁
    
    for (NSDictionary *dic in listData) {
        NSString *des = [NSString stringWithFormat:@"%@",dic[@"des"]];
        NSString *state = [NSString stringWithFormat:@"%@",dic[@"state"]];
        
        if ([des isEqualToString:@"设备/SIM卡状态"]) {
            if ([state isEqualToString:@"待维修"]) {
                equSimStatus = 2;
            } else if ([state isEqualToString:@"损毁"]) {
                equSimStatus = 3;
            }
        } else if ([des isEqualToString:@"充电插口"]) {
            bool_chargingSocketStatus = false;
        } else if ([des isEqualToString:@"外壳状态"]) {
            bool_shellStatus = false;
        } else if ([des isEqualToString:@"充电配件"]) {
            bool_chargingHeadStatus = false;
        } else if ([des isEqualToString:@"数据线"]) {
            bool_dataLineStatus = false;
        } else if ([des isEqualToString:@"皮套状态"]) {
            bool_holsterStatus = false;
        }
    }
    if (_radioBtn1.btn.selected) {
        bool_demurrageStatus = false;
    }
    
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    NSString *creator = [login objectForKey:@"TGTACOUNT"];
    
    NSDictionary *dic = @{@"sn":_devNum,
                          @"rebackWh":@"CN-SZ001",
                          @"rebackUser":creator,
                          @"equSimStatus":@(equSimStatus),
                          @"chargingSocketStatus":@(bool_chargingSocketStatus),
                          @"shellStatus":@(bool_shellStatus),
                          @"chargingHeadStatus":@(bool_chargingHeadStatus),
                          @"dataLineStatus":@(bool_dataLineStatus),
                          @"holsterStatus":@(bool_holsterStatus),
                          @"demurrageStatus":@(bool_demurrageStatus),
                          @"settleType":@"TUGE",
                          @"note":@"备注123"};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *keyStr = [V1HttpTool getKey];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.reback",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        if ([dict[@"code"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ycshwc" object:nil];
            [self hideView];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)t1Action:(UIButton *)sender {
    _radioBtn1.btn.selected = !_radioBtn1.btn.selected;
}
@end
