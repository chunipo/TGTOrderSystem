//
//  HeaderView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        [self _initSubviews];
    }
    return self;
}

- (void)_initSubviews {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
//    imageView.backgroundColor = [UIColor colorWithRed:0.3137 green:0.5765 blue:0.8471 alpha:1];
    imageView.image = [UIImage imageNamed:@"IMG_0262.JPG"];
    [self addSubview:imageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 300, 40)];
    CGFloat fontSize = isPad ? 22 : 17;
    titleLab.font = [UIFont systemFontOfSize:fontSize];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"途鸽信息业务系统";// 途鸽信息业务系统
    [titleLab sizeToFit];
    titleLab.top = 40;
    titleLab.left = 20;
    [self addSubview:titleLab];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.right+20, 0, 0, 0)];
    version.font = [UIFont systemFontOfSize:17];
    version.textColor = [UIColor whiteColor];
    version.text = appVersion;
    [version sizeToFit];
    version.top = titleLab.top+5;
    [self addSubview:version];
    
    
    _logout = [UIButton buttonWithType:UIButtonTypeCustom];
    _logout.frame = CGRectMake(KScreenWidth - 60, 30, 50, 40);
    CGFloat fontSize1 = isPad ? 15 : 14;
    _logout.titleLabel.font = [UIFont systemFontOfSize:fontSize1];
    [_logout setTitle:@"退出" forState:UIControlStateNormal];
    [_logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logout setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:_logout];
    
    NSUserDefaults *login = [NSUserDefaults standardUserDefaults];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(_logout.left - 310, 30, 300, 40)];
    userName.font = [UIFont systemFontOfSize:fontSize1];
    userName.textColor = [UIColor whiteColor];
    userName.textAlignment = NSTextAlignmentRight;
    userName.text = [NSString stringWithFormat:@"当前登录：%@",[login objectForKey:@"TGTACOUNT"]];
    [self addSubview:userName];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 20 - 320, 160, 320, 250)];
    img1.image = [UIImage imageNamed:@"ewm_img.png"];
    [imageView addSubview:img1];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
    img.image = [UIImage imageNamed:@"zi"];
    [imageView addSubview:img];
}

@end
