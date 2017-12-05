//
//  OrderTableView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderTableView.h"

@implementation OrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
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
    FHModel *model = _dataList[indexPath.row];
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
    
    if ([_fromStr isEqualToString:@"cx"]) {
        
        OrderDetailViewController *orderVc = [[OrderDetailViewController alloc] init];
        orderVc.model = _dataList[indexPath.row];
        [self.ViewController.navigationController pushViewController:orderVc animated:YES];
    } else {
        OrderListViewController *orderVc = [[OrderListViewController alloc] init];
        orderVc.model = _dataList[indexPath.row];
        [self.ViewController.navigationController pushViewController:orderVc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

@end
