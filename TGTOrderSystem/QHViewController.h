//
//  QHViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevTableView.h"
#import "FHModel.h"

@interface QHViewController : UIViewController<UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    NSString *_qrString;
}
@property (nonatomic,retain)NSMutableArray *orderList;
@end
