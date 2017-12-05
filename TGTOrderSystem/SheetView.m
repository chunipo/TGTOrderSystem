//
//  SheetView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/13.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "SheetView.h"
#import "UIViewExt.h"

#define  KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  KScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  TITLE_COLOR    [UIColor colorWithRed:0.9176 green: 0.4000 blue:0.1647 alpha:1]
#define  BG_COLOR       [UIColor colorWithRed:0.9412 green:0.9412 blue:0.9412 alpha:1]

@implementation SheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setBtnWithTitle:(NSArray *)btnTitle clickbtn:(SheetBlock)sheetBlock {

    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,KScreenHeight, KScreenWidth, 44 * btnTitle.count + btnTitle.count - 1 + 44 + 5)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomView];
    
    UIView *btBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44 * btnTitle.count + btnTitle.count - 1)];
    btBgView.backgroundColor = BG_COLOR;
    [_bottomView addSubview:btBgView];
    
    for (int i = 0; i < btnTitle.count; i ++) {
        
        UIButton *titleBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor whiteColor];
        titleBtn.frame = CGRectMake(0,i * (45), KScreenWidth, 44);
        titleBtn.tag = i;
        [titleBtn setTitle:btnTitle[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btBgView addSubview:titleBtn];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.frame = CGRectMake(0, _bottomView.height - 44, KScreenWidth, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelBtn];
    
    [UIView animateWithDuration:.2 animations:^{
        _bottomView.top = KScreenHeight - (44 * btnTitle.count + btnTitle.count - 1 + 5 + 44) - 10;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            _bottomView.top = KScreenHeight - (44 * btnTitle.count + btnTitle.count - 1 + 5 + 44);
        }];
    }];
    self.sheetBlock = ^(UIButton *sender,NSInteger index) {
        sheetBlock(sender,index);
    };
}

- (void)titleBtnAction:(UIButton *)sender {
    
    self.sheetBlock(sender,sender.tag);
    [self cancelAction];
}

- (void)cancelAction {

    [UIView animateWithDuration:.15 animations:^{
        _bottomView.top = KScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
