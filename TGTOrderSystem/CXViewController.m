//
//  CXViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "CXViewController.h"
#import "OrderView.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"
#import "OrderTableView.h"

@interface CXViewController ()<UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    OrderTableView *_tableView;
}
@end

@implementation CXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"订单列表"];
    
    [self initTableView];
    [self performSelector:@selector(fillAlert) withObject:nil afterDelay:.5];
}

- (void)initTableView {
    
    _tableView = [[OrderTableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    _tableView.fromStr = @"cx";
    [self.view addSubview:_tableView];
}

- (void)fillAlert {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"订单查询"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"手机号/订单号/预留姓名";
    tf.text = @"";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1007) {
        [self fillAlert];
    } else {
        if (buttonIndex == 0) {
            // 取消
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // 确认
            UITextField *inputField = [alertView textFieldAtIndex:0];
            [inputField resignFirstResponder];
            [self searchOrderWithKeyWord:inputField.text];
        }
    }
}

#pragma mark - 查询订单
- (void)searchOrderWithKeyWord:(NSString *)keyWord {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *accountId = @"tgt_ipad";
    bool bool_false = false;
    NSDictionary *dataDic;
    //输入的内容
    if ([keyWord hasPrefix:@"CO-"]) {
        dataDic = @{@"orderno":keyWord,@"showbill":@(bool_false)};
    } else if ([CXViewController validateMobile:keyWord]) {
        dataDic = @{@"membercellphone":keyWord,@"showbill":@(bool_false)};
    } else if ([keyWord containsString:@"TGT"]) {
        dataDic = @{@"equno":keyWord,@"showbill":@(bool_false)};
    } else {
        dataDic = @{@"membername":keyWord,@"showbill":@(bool_false)};
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
    //    网络请求
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
            if (dataArr.count != 0) {
                _orderList = [NSMutableArray array];
                _orderList = [FHModel mj_objectArrayWithKeyValuesArray:dataArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    _tableView.dataList = _orderList;
                });
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                    UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:@"未查询到相应订单信息" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert_failed.tag = 1007;
                    [alert_failed show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
                NSString *description = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
                NSString *msg = [NSString stringWithFormat:@"%@(%@)",description,code];
                UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:description message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                alert_failed.tag = 1007;
                [alert_failed show];
            });
        }
    }];
    [task resume];
}

// 校验手机号
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
