//
//  GHListViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/2.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "GHListViewController.h"
#import "V1HttpTool.h"
#import "V2HttpTool.h"
#import "FHModel.h"

@interface GHListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,retain)NSMutableArray *orderList;
@end

@implementation GHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"订单列表"];
    
    [self initTableView];
    [self searchOrderWithKeyWord:_inputStr];
}

#pragma mark - 查询订单
- (void)searchOrderWithKeyWord:(NSString *)keyWord {
    
//    [LBProgressHUD showHUDto:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *requestTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *accountId = @"tgt_ipad";
    bool bool_false = false;
    NSDictionary *dataDic;
    if ([keyWord hasPrefix:@"CO-"]) {
        dataDic = @{@"orderno":keyWord,@"showbill":@(bool_false),@"selecttype":@"1"};
    } else if ([GHListViewController validateMobile:keyWord]) {
        dataDic = @{@"membercellphone":keyWord,@"showbill":@(bool_false),@"selecttype":@"1"};
    } else if ([keyWord containsString:@"TGT"]||[keyWord containsString:@"tgt"]) {
        NSString *str = [keyWord substringFromIndex:3];
        str = [str uppercaseString];
        dataDic = @{@"equno":str,@"showbill":@(bool_false),@"selecttype":@"1"};
    } else {
        dataDic = @{@"membername":keyWord,@"showbill":@(bool_false),@"selecttype":@"1"};
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
                for (FHModel *model2 in marr) { // RECEIVED
                    if ([model2.orderstatus isEqualToString:@"RECEIVED"]) {
                        [_orderList addObject:model2];
                    }
                }
                if (_orderList.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [_tableView reloadData];
                        UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:@"未查询到符合收货条件的订单" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        alert_failed.tag = 1007;
                        [alert_failed show];
                    });
                } else {
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [_tableView reloadData];
                    });
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:@"未查询到符合收货条件的订单" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert_failed.tag = 1007;
                    [alert_failed show];
                });
            }
        } else {
            
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            NSString *description = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
            NSString *msg = [NSString stringWithFormat:@"%@(%@)",description,code];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                UIAlertView *alert_failed = [[UIAlertView alloc] initWithTitle:description message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                alert_failed.tag = 1007;
                [alert_failed show];
            });
            NSLog(@"%@",error);
        }
        
    }];
    [task resume];
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    while (cell.contentView.subviews.lastObject != nil) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    FHModel *model = _orderList[indexPath.row];
    NSString *orderno = [NSString stringWithFormat:@"%@",model.orderno];
    NSString *membername = [NSString stringWithFormat:@"%@",model.membername];
    NSString *membercellphone = [NSString stringWithFormat:@"%@",model.membercellphone];
    
    NSString *orderstatus = [NSString stringWithFormat:@"%@",model.orderstatus];
    NSString *dptypeid = [NSString stringWithFormat:@"%@",model.dptypeid];
    NSString *start_time = [NSString stringWithFormat:@"%@",model.start_time];
    NSString *end_time = [NSString stringWithFormat:@"%@",model.end_time];
    NSString *ticketcount = [NSString stringWithFormat:@"%@",model.ticketcount];
    
    if ([orderno isEqualToString:@""]||[orderno isEqualToString:@"(null)"]||[orderno isEqualToString:@"<null>"]) {
        orderno = @"无";
    }
    if ([membername isEqualToString:@""]||[membername isEqualToString:@"(null)"]||[membername isEqualToString:@"<null>"]) {
        membername = @"无";
    }
    if ([membercellphone isEqualToString:@""]||[membercellphone isEqualToString:@"(null)"]||[membercellphone isEqualToString:@"<null>"]) {
        membercellphone = @"无";
    }
    if ([orderstatus isEqualToString:@""]||[orderstatus isEqualToString:@"(null)"]||[orderstatus isEqualToString:@"<null>"]) {
        orderstatus = @"无";
    }
    if ([dptypeid isEqualToString:@""]||[dptypeid isEqualToString:@"(null)"]||[dptypeid isEqualToString:@"<null>"]) {
        dptypeid = @"无";
    }
    if ([start_time isEqualToString:@""]||[start_time isEqualToString:@"(null)"]||[start_time isEqualToString:@"<null>"]) {
        start_time = @"无";
    }
    if ([end_time isEqualToString:@""]||[end_time isEqualToString:@"(null)"]||[end_time isEqualToString:@"<null>"]) {
        end_time = @"无";
    }
    if ([ticketcount isEqualToString:@""]||[ticketcount isEqualToString:@"(null)"]||[ticketcount isEqualToString:@"<null>"]) {
        ticketcount = @"无";
    }
    
    // 订单号
    UILabel *order_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 30)];
    order_Label.font = [UIFont boldSystemFontOfSize:17];
    order_Label.text = [NSString stringWithFormat:@"订单号：%@",orderno];
    [order_Label sizeToFit];
    order_Label.top = 30;
    [cell.contentView addSubview:order_Label];
    // 姓名
    UILabel *membername_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, KScreenWidth/3, 30)];
    membername_Label.font = [UIFont systemFontOfSize:16];
    membername_Label.text = [NSString stringWithFormat:@"姓名：%@",membername];
    [cell.contentView addSubview:membername_Label];
    // 手机号
    UILabel *membercellphone_Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/3, 60, KScreenWidth/3, 30)];
    membercellphone_Label.font = [UIFont systemFontOfSize:16];
    membercellphone_Label.text = [NSString stringWithFormat:@"手机号：%@",membercellphone];
    [cell.contentView addSubview:membercellphone_Label];
    // 订单状态
    UILabel *orderStatus_Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/3 *2, 60, KScreenWidth/3, 30)];
    orderStatus_Label.font = [UIFont systemFontOfSize:16];
    NSString *str = orderstatus;
    if ([str isEqualToString:@"PAID"]) {
        str = @"已支付";
    }
    if ([str isEqualToString:@"RECEIVED"]) {
        str = @"已取件";
    }
    if ([str isEqualToString:@"CLOSED"]) {
        str = @"已关闭";
    }
    if ([str isEqualToString:@"SETTLED"]) {
        str = @"已结算";
    }
    if ([str isEqualToString:@"PARTIALCANCEL"]) {
        str = @"部分取消";
    }
    if ([str isEqualToString:@"CANCELFAIL"]) {
        str = @"取消（审核）失败";
    }
    if ([str isEqualToString:@"SAVE"]) {
        str = @"保存";
    }
    if ([str isEqualToString:@"NEW"]) {
        str = @"新建";
    }
    orderStatus_Label.text = [NSString stringWithFormat:@"订单状态：%@",str];
    [cell.contentView addSubview:orderStatus_Label];
    
    // 开始时间
    UILabel *start_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, KScreenWidth/3, 30)];
    start_Label.font = [UIFont systemFontOfSize:16];
    start_Label.text = [NSString stringWithFormat:@"出行日期：%@",[start_time componentsSeparatedByString:@" "].firstObject];
    [cell.contentView addSubview:start_Label];
    // 结束时间
    UILabel *end_Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/3, 90, KScreenWidth/3, 30)];
    end_Label.font = [UIFont systemFontOfSize:16];
    end_Label.text = [NSString stringWithFormat:@"返回日期：%@",[end_time componentsSeparatedByString:@" "].firstObject];
    [cell.contentView addSubview:end_Label];
    // 设备订购台数
    UILabel *ticketcount_label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/3 * 2, 90, KScreenWidth/3, 30)];
    ticketcount_label.font = [UIFont systemFontOfSize:16];
    if ([ticketcount isEqualToString:@"无"]) {
        ticketcount_label.text = [NSString stringWithFormat:@"设备数量：%@",ticketcount];
    } else {
        ticketcount_label.text = [NSString stringWithFormat:@"设备数量：%@台",ticketcount];
    }
    [cell.contentView addSubview:ticketcount_label];
    
    // 套餐
    UILabel *tc_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, KScreenWidth-40, 60)];
    tc_Label.font = [UIFont systemFontOfSize:16];
    tc_Label.numberOfLines = 0;
    tc_Label.text = [NSString stringWithFormat:@"套餐名称：%@",dptypeid];
    [tc_Label sizeToFit];
    tc_Label.top = 130;
    [cell.contentView addSubview:tc_Label];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HHOrderViewController *hhorderVc = [[HHOrderViewController alloc] init];
    hhorderVc.model = _orderList[indexPath.row];
    hhorderVc.inputStr = _inputStr;
    [self.navigationController pushViewController:hhorderVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (NSString *)modelStrTostr:(NSString *)str {
    if ([str isEqualToString:@""]||[str isEqualToString:@"<null>"]||[str isEqualToString:@"(null)"]) {
        str = @"无";
    }
    return str;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1007) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 校验手机号
+ (BOOL) validateMobile:(NSString *)mobile
{
    //    /^1[3|4|5|7|8]\d{9}$/
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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
