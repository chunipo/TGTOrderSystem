//
//  HHOrderViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/9.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTopView.h"
#import "FHModel.h"

@interface HHOrderViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scrollView;
    HHTopView *_hhtopView;
    NSString *_devNum;
    NSInteger *index;
    UIButton *_btn;
    BOOL isUpImg;
    UIButton *qzBtn;
}
@property (nonatomic,retain)NSString *inputStr;
@property (nonatomic,retain)FHModel *model;
@end
