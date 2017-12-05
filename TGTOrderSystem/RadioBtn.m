//
//  RadioBtn.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "RadioBtn.h"

@implementation RadioBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setBtnNormalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg title:(NSString *)title action:(SEL)sel {

    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(5, (self.height - 25)/2, 25, 25);
    _btn.selected = NO;
    [_btn setImage:normalImg forState:UIControlStateNormal];
    [_btn setImage:selectImg forState:UIControlStateSelected];
    [_btn addTarget:self.superview action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btn.right + 3, 0, 60, self.height)];
    [_titleLabel setUserInteractionEnabled:YES];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
    
}
@end
