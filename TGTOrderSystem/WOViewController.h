//
//  WOViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/23.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTopView.h"

@interface WOViewController : UIViewController
{
    HHTopView *_hhtopView;
}
@property (nonatomic,retain)NSArray *leftArr;
@property (nonatomic,retain)NSArray *rightArr;
@property (nonatomic,copy)NSString *devNumber;
@end
