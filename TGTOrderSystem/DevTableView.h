//
//  DevTableView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/16.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSMutableArray *dataList;
@end
