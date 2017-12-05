//
//  YCDevStateSelectView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/6/16.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCDevStateSelectView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain)UIPickerView *picker;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSArray *arrState;
@property (nonatomic,retain)NSDictionary *dataDic;
@end
