//
//  OrderView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/6/15.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHModel.h"

@interface OrderView : UIView

@property (nonatomic,retain)NSArray *arr1;
@property (nonatomic,retain)NSArray *rightArr;
@property (nonatomic,retain)NSArray *arr2;
@property (nonatomic,retain)NSArray *arr3;
@property (nonatomic,retain)NSArray *arr4;
@property (nonatomic,retain)NSArray *arr5;
@property (nonatomic,retain)NSArray *arr6;
@property (nonatomic,retain)UILabel *leftLabel;
@property (nonatomic,retain)UIImageView *xpimageView;
@property (nonatomic,retain)UILabel *yjRightLabTitle;
@property (nonatomic,retain)UILabel *yjRightLabContent;

@property (nonatomic,copy)NSString *devNum;

- (void)_loadData:(FHModel *)model;

@end
