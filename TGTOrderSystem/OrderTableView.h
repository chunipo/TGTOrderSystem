//
//  OrderTableView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListViewController.h"
#import "OrderDetailViewController.h"

@interface OrderTableView : UITableView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *fromStr;
@property (nonatomic,retain)NSArray *dataList;
@end
