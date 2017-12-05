//
//  QHViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "QHViewController.h"
#import "QHView.h"
#import "ScanViewController.h"
#import "SheetView.h"
#import "YJTView.h"
#import "V2HttpTool.h"
#import "V1HttpTool.h"
#import "OrderTableView.h"
#import "QRScanViewController.h"

@interface QHViewController () <QrCodeResponseDelegate>
{
    OrderTableView *_tableView;
}
@end

@implementation QHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    //自定义导航栏
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"发货列表"];
    [self initTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    if (_tableView.dataList.count == 0 && _qrString == nil) {
        [self performSelector:@selector(fillAlert) withObject:nil afterDelay:.5];
    }
}
- (void)fillAlert {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单查询"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"搜索输入框内容", @"去扫描二维码",nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1002;
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.placeholder = @"手机号/订单号/预留姓名";
    tf.text = @"";
    [alert show];
}

- (void)initTableView {

    _tableView = [[OrderTableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
}
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    alertView.frame = CGRectMake(0, 0, 0, 0);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1002){
    
        if (buttonIndex == 0) {
            
            // 取消
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        } else if (buttonIndex == 1) {
            
            // 确认
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            // 查询订单
            [self searchOrderWithKeyWord:inputField.text];
        } else {
            
            // 扫描二维码
            QRScanViewController *qrScanView = [[QRScanViewController alloc] init];
            qrScanView.delegate = self;
            [self.navigationController pushViewController:qrScanView animated:YES];
        }
    } else if (alertView.tag == 1007) {
        [self fillAlert];
    }
}

- (void)getQrCodeResponse:(NSString *)qrCodeString {
    _qrString = qrCodeString;
    [self searchOrderWithKeyWord:_qrString];
}

#pragma mark - 查询订单
- (void)searchOrderWithKeyWord:(NSString *)keyWord {
    
//    [LBProgressHUD showHUDto:self.view animated:YES];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *accountId = @"tgt_ipad";
    bool bool_true = true;
    bool bool_false = false;
    NSDictionary *dataDic;
    if ([keyWord hasPrefix:@"CO-"]) {
        dataDic = @{@"orderno":keyWord,@"showbill":@(bool_false),@"selecttype":@"0"};
    } else if ([QHViewController validateMobile:keyWord]) {
        dataDic = @{@"membercellphone":keyWord,@"showbill":@(bool_false),@"selecttype":@"0"};
    } else if ([keyWord containsString:@"TGT"]) {
        dataDic = @{@"equno":keyWord,@"showbill":@(bool_false),@"selecttype":@"0"};
    } else {
        dataDic = @{@"membername":keyWord,@"showbill":@(bool_false),@"selecttype":@"0"};
    }
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
                
                _orderList = [NSMutableArray array];
                NSMutableArray *marr = [NSMutableArray array];
                marr = [FHModel mj_objectArrayWithKeyValuesArray:dataArr];
                for (FHModel *model2 in marr) { // PAID
                    if ([model2.orderstatus isEqualToString:@"PAID"]) {
                        [_orderList addObject:model2];
                    }
                }
                for (FHModel *model2 in marr) { // RECEIVED
                    if ([model2.orderstatus isEqualToString:@"RECEIVED"]) {
                        [_orderList addObject:model2];
                    }
                }
                
                if (_orderList.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_hud hideAnimated:YES];
                        _tableView.dataList = _orderList;
                        UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:@"未查询到符合发货条件的订单" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        alert_failed.tag = 1007;
                        [alert_failed show];
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_hud hideAnimated:YES];
                        _tableView.dataList = _orderList;
                    });
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_hud hideAnimated:YES];
                    UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:@"未查询到符合发货条件的订单" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert_failed.tag = 1007;
                    [alert_failed show];
                });
            }
        } else {
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            NSString *description = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
            NSString *msg = [NSString stringWithFormat:@"%@(%@)",description,code];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_hud hideAnimated:YES];
                    UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:description message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert_failed.tag = 1007;
                    [alert_failed show];
                });
            });
        }
        
    }];
    [task resume];
}
+ (BOOL) validateMobile:(NSString *)mobile
{
    //    /^1[3|4|5|7|8]\d{9}$/
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

//  2016-10-19 09:12:12.425 TGTOrderSystem[230:5052] Error Domain=NSURLErrorDomain Code=-1009 "似乎已断开与互联网的连接。" UserInfo={NSUnderlyingError=0x14f143120 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorCodeKey=8, _kCFStreamErrorDomainKey=12}}, NSErrorFailingURLStringKey=http://oss.51tgt.com/web/api/portalinvoke/handler.mobileQuery, NSErrorFailingURLKey=http://oss.51tgt.com/web/api/portalinvoke/handler.mobileQuery, _kCFStreamErrorDomainKey=12, _kCFStreamErrorCodeKey=8, NSLocalizedDescription=似乎已断开与互联网的连接。}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
