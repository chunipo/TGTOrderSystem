//
//  BottomView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/10.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setYCBtnActon:(SEL)ycSEL
              yctitle:(NSString *)yctitle
           qrBtnActon:(SEL)qrSEL
              qrtitle:(NSString *)qrtitle {

    _ycBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ycBtn.backgroundColor = TITLE_COLOR;
    _ycBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_ycBtn addTarget:self.superview action:ycSEL forControlEvents:UIControlEventTouchUpInside];
    _ycBtn.frame = CGRectMake((KScreenWidth/2 - 150)/2, 10, 150, 40);
    [_ycBtn setTitle:yctitle forState:UIControlStateNormal];
    [self addSubview:_ycBtn];
    
    _qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qrBtn.backgroundColor = TITLE_COLOR;
    _qrBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_qrBtn addTarget:self.superview action:qrSEL forControlEvents:UIControlEventTouchUpInside];
    _qrBtn.frame = CGRectMake((KScreenWidth/2 - 150)/2 + KScreenWidth/2, 10, 150, 40);
    [_qrBtn setTitle:qrtitle forState:UIControlStateNormal];
    [self addSubview:_qrBtn];
}

@end
