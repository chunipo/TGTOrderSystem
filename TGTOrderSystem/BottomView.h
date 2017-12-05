//
//  BottomView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/10.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BottomView : UIView

@property (nonatomic,retain)UIButton *ycBtn;
@property (nonatomic,retain)UIButton *qrBtn;

- (void)setYCBtnActon:(SEL)ycSEL
              yctitle:(NSString *)yctitle
           qrBtnActon:(SEL)qlSEL
              qrtitle:(NSString *)qltitle;
@end
