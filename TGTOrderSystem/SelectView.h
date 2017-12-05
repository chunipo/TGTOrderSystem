//
//  SelectView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/12.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock)(NSString *selectStr);

@interface SelectView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)SelectBlock selectBlock;

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,retain)NSString *titleName;
@property (nonatomic,retain)NSString *selectStr;

@end
