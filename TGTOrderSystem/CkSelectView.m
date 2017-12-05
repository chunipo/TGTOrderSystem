//
//  CkSelectView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "CkSelectView.h"
#import "YCSHView.h"
#import "HHView.h"
#import "YCSHView_V1.h"
#import "V1HttpTool.h"

static CkSelectView *ckv = nil;
@implementation CkSelectView 

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title formPage:(NSString *)page number:(NSString *)number
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([number isEqualToString:@"(null)"]||[number isEqualToString:@"<null>"]||[number isEqualToString:@""]) {
            _firstNumber = @"";
        } else {
            _firstNumber = number;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        
        ckv = self;
        _fromPage = page;
        _title = title;
        self.backgroundColor = [UIColor whiteColor];
        [self initBtn];
        [self initPickerView];
        if ([_fromPage isEqualToString:@"V1_ycsh"]) {
            [self submitAction];
        } else {
            [self loadDataWithQueryWarehose];
        }
    }
    return self;
}
+ (CkSelectView *)shareckSelectView {
    return ckv;
}
- (void)reloadDataFromDataArr:(NSArray *)dataArr {

    if ([_title isEqualToString:@"收货仓库"]) {
        
        NSMutableArray *z_arr = [NSMutableArray array];
        for (NSDictionary *dict in dataArr) {
            NSString *warehosename = [NSString stringWithFormat:@"%@",dict[@"warehosename"]];
            [z_arr addObject:warehosename];
        }
        _arr = z_arr;
        if ([_fromPage isEqualToString:@"zcsh"]) {
//            [HHView shareHHView].ckTfView.textField.text = _arr[0];
        } else {
            
//            [YCSHView shareYCSHView].ckTfView.textField.text = [NSString stringWithFormat:@"%@",_arr[0]];
        }
        
    } else {
        if ([_fromPage isEqualToString:@"zcsh"]) {
            
            NSMutableArray *f_arr = [NSMutableArray array];
            for (NSDictionary *dict in dataArr) {
                NSArray *subwarehose = dict[@"subwarehose"];
                NSString *warehosename = [NSString stringWithFormat:@"%@",dict[@"warehosename"]];
                if ([[HHView shareHHView].ckTfView.textField.text isEqualToString:warehosename]) {
                    for (NSDictionary *dic in subwarehose) {
                        NSString *subwarehosename = dic[@"subwarehosename"];
                        [f_arr addObject:subwarehosename];
                    }
                }
            }
            _arr = f_arr;
            if (_arr.count != 0) {
//                [HHView shareHHView].fckTfView.textField.text = _arr[0];
            }
        } else {
            
            NSMutableArray *f_arr = [NSMutableArray array];
            for (NSDictionary *dict in dataArr) {
                NSArray *subwarehose = dict[@"subwarehose"];
                NSString *warehosename = [NSString stringWithFormat:@"%@",dict[@"warehosename"]];
                if ([[YCSHView shareYCSHView].ckTfView.textField.text isEqualToString:warehosename]) {
                    for (NSDictionary *dic in subwarehose) {
                        NSString *subwarehosename = [NSString stringWithFormat:@"%@",dic[@"subwarehosename"]];
                        NSString *defaultreceivesub = [NSString stringWithFormat:@"%@",dic[@"defaultreceivesub"]];
                        if ([defaultreceivesub isEqualToString:@"1"]) {
                            [f_arr insertObject:subwarehosename atIndex:0];
                        } else {
                            [f_arr addObject:subwarehosename];
                        }
                    }
                }
            }
            _arr = f_arr;
            if (_arr.count != 0) {
//                [YCSHView shareYCSHView].fckTfView.textField.text = _arr[0];
            }
        }
    }
    [_picker reloadComponent:0];
}

- (void)initBtn {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width,50)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _title;
    [self addSubview:titleLabel];
    
    NSArray *btnTitle = @[@"取消",@"确定"];
    for (int i = 0; i < 2; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i * (self.width - 50), 0, 50, 50);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:btnTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.1608 green:.5294 blue:.9412 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
- (void)initPickerView {
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 50, self.width - 100, 200)];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.dataSource = self;
    _picker.delegate = self;
    [self addSubview:_picker];
}

- (void)buttonAction:(UIButton *)sender {
    
    NSDictionary *dic;
    if (sender.tag == 0) {
        dic = @{@"btnTag":@"0"};
    } else {
        dic = @{@"btnTag":@"1"};
        if (_selectStr == nil) {
            if (_arr.count != 0) {
                _selectStr = [NSString stringWithFormat:@"%@",_arr[0]];
            } else {
                _selectStr = @"";
            }
        }
        if ([_title isEqualToString:@"收货仓库"]) {
            if ([_fromPage isEqualToString:@"zcsh"]) {
                [HHView shareHHView].ckTfView.textField.text = [NSString stringWithFormat:@"%@",_selectStr];
            } else {
                if ([_fromPage isEqualToString:@"V1_ycsh"]) {
                    
                    [YCSHView_V1 shareYCSHV1View].ckTfView.textField.text = [NSString stringWithFormat:@"%@",_selectStr];
                } else {
                    [YCSHView shareYCSHView].ckTfView.textField.text = [NSString stringWithFormat:@"%@",_selectStr];
                    
                    NSMutableArray *f_arr = [NSMutableArray array];
                    for (NSDictionary *dict in _dataList) {
                        NSArray *subwarehose = dict[@"subwarehose"];
                        NSString *warehosename = [NSString stringWithFormat:@"%@",dict[@"warehosename"]];
                        if ([[YCSHView shareYCSHView].ckTfView.textField.text isEqualToString:warehosename]) {
                            for (NSDictionary *dic in subwarehose) {
                                NSString *subwarehosename = [NSString stringWithFormat:@"%@",dic[@"subwarehosename"]];
                                NSString *defaultreceivesub = [NSString stringWithFormat:@"%@",dic[@"defaultreceivesub"]];
                                if ([defaultreceivesub isEqualToString:@"1"]) {
                                    [f_arr insertObject:subwarehosename atIndex:0];
                                } else {
                                    [f_arr addObject:subwarehosename];
                                }
                            }
                        }
                    }
                    if (f_arr.count != 0) {
                        [YCSHView shareYCSHView].fckTfView.textField.text = [NSString stringWithFormat:@"%@",f_arr[0]];
                    }
                }
            }
        } else {
            if ([_fromPage isEqualToString:@"zcsh"]) {
                if (_arr.count != 0) {
                    [HHView shareHHView].fckTfView.textField.text = [NSString stringWithFormat:@"%@",_selectStr];
                }
            } else {
                if (_arr.count != 0) {
                    [YCSHView shareYCSHView].fckTfView.textField.text = [NSString stringWithFormat:@"%@",_selectStr];
                }
            }
        }
    }
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return _arr.count;
}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _arr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (_arr.count != 0) {
        _selectStr = [NSString stringWithFormat:@"%@",_arr[row]];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - 查询仓库
// V1
- (void)submitAction {
    
    NSDictionary *dic = @{@"sn":_firstNumber};
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    NSDictionary *param = @{@"param":str};
    
    NSString *keyStr = [V1HttpTool getKey];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/tgt/web/api/%@/depositBill1.getAllWareHouse",BaseURL_V1,keyStr];
    [XGGHttpsManager requstURL:urlStr parametes:param httpMethod:Http_POST progress:^(float progress) {
        ;
    } success:^(NSDictionary *dict, BOOL success) {
        NSLog(@"%@",dict);
        [hud hideAnimated:YES];
        if ([dict[@"code"] isEqualToString:@"0"]) {
            _v1List = dict[@"wareHouses"];
            NSMutableArray *arr_v1 = [NSMutableArray array];
            for (NSDictionary *dic in _v1List) {
                [arr_v1 addObject:[NSString stringWithFormat:@"%@",dic[@"name"]]];
            }
            _arr = arr_v1;
            [_picker reloadComponent:0];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [hud hideAnimated:YES];
    }];
}

// V2
- (void)loadDataWithQueryWarehose {
    
    NSString *accountId = @"tgt_ipad";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//    [dataDic setObject:_firstNumber forKey:@"number"];

    /*将number改成code字段*/
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [userDefault stringForKey:@"UUID"];
    [dataDic setObject:DeviceID forKey:@"code"];
    
    NSString *data_json = [V1HttpTool dictionaryToJson:dataDic];
    data_json = [NSString stringWithFormat:@"\"data\":%@",data_json];
    data_json = [data_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data_json = [data_json stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nsdata = [data_json dataUsingEncoding:NSUTF8StringEncoding];
    NSString *data_base64 = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *sign_str = [NSString stringWithFormat:@"%@%@%@%@%@%@",accountId,@"queryWarehose",requestTime,data_base64,@"OSSV2",@"D751812669664A388982D224CB124555"];
    NSString *sign_md5 = [V1HttpTool md5_32BitLower:sign_str];
    
    NSDictionary *dic = @{@"requestTime":@"time_test",
                          @"version":@"OSSV2",
                          @"sign":sign_md5,
                          @"serviceName":@"queryWarehose",
                          @"data":dataDic,
                          @"accountId":accountId};
    
    NSString *str = [V1HttpTool dictionaryToJson:dic];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"time_test" withString:requestTime];
    NSData *data_dic = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/web/api/portalinvoke/handler.queryWarehose",BaseURL_V2];
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
                NSLog(@"%@",dict);
                if ([dict[@"resultCode"] isEqualToString:@"0000"]) {
                    _dataList = dict[@"data"];
                    [self reloadDataFromDataArr:_dataList];
                } else {
                    NSString *resultMessage = [NSString stringWithFormat:@"%@",dict[@"resultMessage"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货仓库查询失败" message:resultMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询错误" message:@"服务器连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
    }];
    
    [task resume];
}
@end
