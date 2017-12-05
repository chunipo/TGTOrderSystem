//
//  ScanViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V1HttpTool.h"

@interface ScanViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSArray *arr1;
    UILabel *_emptyTipLab;
}
@property (nonatomic,retain)NSString *devCount;
@property (nonatomic,retain)NSString *orderno;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,retain)NSString *flag;
@end
