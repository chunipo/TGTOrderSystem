//
//  WOViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/23.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "WOViewController.h"
#import "JSViewController.h"

@interface WOViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    if ([_devNumber hasPrefix:@"TGT0"]) {
        [navView initWithTitleName:@"押金条"];
    } else {
        [navView initWithTitleName:@"工单"];
    }
    [self _initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsActon) name:@"jsActon" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jsActon" object:nil];
}
- (void)_initView {

    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    if ([_devNumber hasPrefix:@"TGT0"]) {
        
        _leftArr = @[@"领用日期",@"押金条单号",@"设备编号",@"开通状态",
                     @"押金收取",@"待付金额",@"归还时间",@"押金消费",
                     @"没收押金金额",@"押金退款",@"扣款原因",@"门店",
                     @"设备情况",@"代付金额"];
        _rightArr = @[@"2016-05-19",@"YJ201605191838048",_devNumber,@"开",
                      @"500.00",@"400.00",@"",@"",
                      @"",@"",@"",@"途鸽总部",@"完好",@"0.00"];
    } else {
    
        _leftArr = @[@"编号",@"设备号",@"预计归还日期",@"已收押金金额",@"套餐",@"金额",@"开始时间",@"结束时间",@"取消费用",@"延期未使用费用",@"设备损坏扣费",@"延单费用",@"预算备注"];
        _rightArr = @[@"16042000617",_devNumber,@"2016-04-23",@"500元",@"中国日租",@"51.00元",@"2016-04-20",@"2016-04-22",@"",@"",@"",@"",@""];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _leftArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, cell.height)];
    leftLab.font = [UIFont systemFontOfSize:18];
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.text = _leftArr[indexPath.row];
    [cell.contentView addSubview:leftLab];
    
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(210, 0,KScreenWidth - 210-10, cell.height)];
    rightLab.font = [UIFont systemFontOfSize:17];
    rightLab.textColor = [UIColor darkGrayColor];
    rightLab.text = _rightArr[indexPath.row];
    [cell.contentView addSubview:rightLab];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 50, KScreenWidth - 100, 45);
    button.backgroundColor = TITLE_COLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:@"收货" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    return bgView;
}

- (void)buttonAction:(UIButton *)sender {

    _hhtopView = [[HHTopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
#warning 收货textfield delegate
    _hhtopView.sjghTfView.textField.delegate = self;
    _hhtopView.titleLab.text = @"收货";
    [self.view addSubview:_hhtopView];
}

- (void)jsActon {
    
    [_hhtopView removeFromSuperview];
    NSLog(@"结算");
    JSViewController *jsVc = [[JSViewController alloc] init];
    jsVc.devNumber = _devNumber;
    [self.navigationController pushViewController:jsVc animated:YES];
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
