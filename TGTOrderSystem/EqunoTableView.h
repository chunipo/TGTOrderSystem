//
//  EqunoTableView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/19.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqunoTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSString *devCount;
@property (nonatomic,retain)NSArray *dataList;
@end
