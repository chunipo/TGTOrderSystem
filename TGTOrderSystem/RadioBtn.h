//
//  RadioBtn.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioBtn : UIView

@property (nonatomic,retain)UIButton *btn;
@property (nonatomic,retain)UILabel *titleLabel;

- (void)setBtnNormalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg title:(NSString *)title action:(SEL)sel;
@end
