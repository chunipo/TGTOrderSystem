//
//  TipView.m
//  TipsDemo
//
//  Created by TGT-Tech on 14-11-28.
//  Copyright (c) 2014年 TGT-Tech. All rights reserved.
//

#import "TipView.h"

@implementation TipView
{
    UIImageView *showView;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)showTipIn:(UIView *)parentView andTipMsg:(NSString *)tipStr
{
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    tipLab.text = tipStr;
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor whiteColor];
    [tipLab sizeToFit];
    tipLab.top = (35 - tipLab.height)/2;
    showView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tipLab.width + 20, 35)];
    showView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2 + 100);
    UIImage *image = [UIImage imageNamed:@"tipsBackImg"];
    showView.image = [image stretchableImageWithLeftCapWidth:100 topCapHeight:50];
    [showView addSubview:tipLab];
    showView.alpha = 0;
    
    CGRect oldFrame = showView.frame;
    [parentView addSubview:showView];
    
    [UIView animateWithDuration:.5 animations:^{
        
        showView.frame = oldFrame;
        showView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(ss) withObject:nil afterDelay:1.5];
    }];
}
- (void)ss {

    [UIView animateWithDuration:.5 animations:^{
        showView.alpha = 0;
        showView = nil;
    }];
}
@end
