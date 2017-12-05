//
//  OrderDetailViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/2.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderView.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:navView];
    [navView initWithTitleName:@"订单详情"];
    
    [self cxDD];
}

#pragma mark - 查询订单
- (void)cxDD {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    OrderView *qhView = [[OrderView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth, 555+95+205)];
    [qhView _loadData:_model];
    NSString *deliverypath = [NSString stringWithFormat:@"%@",_model.deliverypath];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",_model.receivedpath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    
    if (deliveryData == nil && receivedData == nil) {
        
        if ([deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
            qhView.height = 555 + 95;
        } else {
            qhView.height = 555 + 95 + 205;
        }
    } else {
        qhView.height = 555 + 95 + 205;
    }
    [_scrollView addSubview:qhView];
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
