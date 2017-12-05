//
//  CkSelectView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGGHttpsManager.h"

@interface CkSelectView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_arr;
}
@property (nonatomic,copy)NSString *fromPage;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)UIPickerView *picker;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,retain)NSArray *v1List;
@property (nonatomic,retain)NSString *selectStr;
@property (nonatomic,retain)NSString *firstNumber;
- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title formPage:(NSString *)page number:(NSString *)number;
+ (CkSelectView *)shareckSelectView;
@end
