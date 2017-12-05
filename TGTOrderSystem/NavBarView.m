//
//  NavBarView.m
//  TGTWiFi
//
//  Created by TGT-Tech on 15/12/10.
//  Copyright (c) 2015年 TGT. All rights reserved.
//

#import "NavBarView.h"

@implementation NavBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:0.1176 green:0.6784 blue:0.9255 alpha:1];
    }
    return self;
}
- (void)initWithTitleName:(NSString *)title {
    
    _titleStr = title;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    if ([title isEqualToString:@"登录"]) {
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 20, 44, 44);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"back_iphone6"] forState:UIControlStateNormal];
    [button.imageView setContentMode:UIViewContentModeScaleToFill];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIButton *button_gotoHome = [UIButton buttonWithType:UIButtonTypeCustom];
    button_gotoHome.frame = CGRectMake(120, 20, 60, 44);
    button_gotoHome.backgroundColor = [UIColor clearColor];
    [button_gotoHome setTitle:@"回首页" forState:UIControlStateNormal];
    button_gotoHome.titleLabel.font = [UIFont systemFontOfSize:18];
    [button_gotoHome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_gotoHome addTarget:self action:@selector(gotoHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button_gotoHome];
}
- (void)popAction {
    
    [self.ViewController.navigationController popViewControllerAnimated:YES];
}
- (void)gotoHomeAction {
    [self.ViewController.navigationController popToRootViewControllerAnimated:YES];
}
@end
