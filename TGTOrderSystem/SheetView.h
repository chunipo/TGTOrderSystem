//
//  SheetView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/13.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SheetBlock)(UIButton *sender,NSInteger index);

@interface SheetView : UIView

@property (nonatomic,strong)SheetBlock sheetBlock;
@property (nonatomic,retain)UIView *bottomView;
- (void)setBtnWithTitle:(NSArray *)btnTitle clickbtn:(SheetBlock)sheetBlock;

@end
