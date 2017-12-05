//
//  YCTableView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/17.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSMutableArray *dataList;
@end
