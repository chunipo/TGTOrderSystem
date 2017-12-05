//
//  HHView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/7.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHModel.h"
#import "TextFieldView.h"
#import "RadioBtn.h"
#import "CkSelectView.h"

@interface HHView : UIView<UITextFieldDelegate>
{
    CkSelectView *seleCtView;
}
@property (nonatomic,retain)NSArray *arr1;
@property (nonatomic,retain)NSArray *rightArr;
@property (nonatomic,retain)NSArray *arr2;
@property (nonatomic,retain)NSArray *arr3;
@property (nonatomic,retain)NSArray *arr4;
@property (nonatomic,retain)UILabel *leftLabel;
@property (nonatomic,retain)UIImageView *xpimageView;
@property (nonatomic,retain)UILabel *yjRightLabTitle;
@property (nonatomic,retain)UILabel *yjRightLabContent;

@property (nonatomic,retain)TextFieldView *ckTfView;        // 收货仓库
@property (nonatomic,retain)TextFieldView *fckTfView;        // 收货分仓库
@property (nonatomic,retain)RadioBtn *radioBtn2;            // 途鸽已收
@property (nonatomic,retain)RadioBtn *radioBtn3;            // 渠道代收
@property (nonatomic,copy)NSString *devNum;
@property (nonatomic,retain)FHModel *model;
- (void)_loadData:(FHModel *)model;

+ (HHView *)shareHHView;


@end
