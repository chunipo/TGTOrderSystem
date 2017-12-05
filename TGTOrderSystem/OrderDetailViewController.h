//
//  OrderDetailViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/2.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHModel.h"

@interface OrderDetailViewController : UIViewController
{
    UIScrollView *_scrollView;
}
@property (nonatomic,retain)FHModel *model;
@end
