//
//  OrderListViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/1.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHModel.h"
#import "QHView.h"
#import "DevTableView.h"
#import "SheetView.h"
#import "YJTView.h"
#import "EqunoTableView.h"

@interface OrderListViewController : UIViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIScrollView *_scrollView;
    UIButton *addDevBtn;
    UITableView *_t1TableView;
    NSString *_yjNumber;
    UILabel *ztLab;
    QHView *qhView;
    UIView *bgView;
    MBProgressHUD *_hud;
    BOOL isUpImg;
}

@property (nonatomic,retain)EqunoTableView *equnoTableView;

@property (nonatomic,retain)FHModel *model;

@property(nonatomic, unsafe_unretained)CGFloat currentScale;

@property (nonatomic,retain)DevTableView *devTableView;
@property (nonatomic,retain)NSString *devCount;
@property (nonatomic,retain)NSArray *dataList;

@property (nonatomic,retain)NSArray *t1DataList;
@property (nonatomic,copy)NSString *devNum;
@property (nonatomic,copy)NSArray *numberArr;
@end
