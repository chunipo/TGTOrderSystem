//
//  LoginView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
        [self _initView];
    }
    return self;
}

- (void)_initView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.width, self.height - 35)];
    bgView.layer.cornerRadius = 20;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor colorWithRed:0.8980 green:0.8980 blue:0.8980 alpha:1].CGColor;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];

    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(30, bgView.top - 35, 90, 90)];
    logoView.layer.cornerRadius = 45;
    logoView.layer.masksToBounds = YES;
    logoView.image = [UIImage imageNamed:@"about_icon_iphone6"];
    logoView.backgroundColor = [UIColor orangeColor];
    [self addSubview:logoView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(logoView.right+10, 10, 200, 50)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = TITLE_COLOR;
    CGFloat fontSize = isPad ? 17 : 16;
    titleLab.font = [UIFont systemFontOfSize:fontSize];
    titleLab.text = @"途鸽业务系统登录";
    [bgView addSubview:titleLab];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, self.width, 1)];
    line1.backgroundColor = [UIColor colorWithRed:0.8980 green:0.8980 blue:0.8980 alpha:1];
    [bgView addSubview:line1];
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, self.width-40, 45)];
//    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.backgroundColor = [UIColor clearColor];
    CGFloat fontSize1 = isPad ? 17 : 15;
    _userName.font = [UIFont systemFontOfSize:fontSize1];
    _userName.placeholder = @"用户名";
    [bgView addSubview:_userName];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 69+45, self.width, 1)];
    line2.backgroundColor = [UIColor colorWithRed:0.8980 green:0.8980 blue:0.8980 alpha:1];
    [bgView addSubview:line2];
    _password = [[UITextField alloc] initWithFrame:CGRectMake(20, _userName.bottom, self.width-40, 45)];
//    _password.textAlignment = NSTextAlignmentCenter;
    _password.font = [UIFont systemFontOfSize:fontSize1];
    _password.backgroundColor = [UIColor clearColor];
    _password.placeholder = @"密码";
    [bgView addSubview:_password];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 69+90, self.width, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.8980 green:0.8980 blue:0.8980 alpha:1];
    [bgView addSubview:line3];
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(0, _password.bottom, self.width, 45);
    _loginBtn.backgroundColor = [UIColor clearColor];
    _loginBtn.layer.cornerRadius = 20;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize1];
    [_loginBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [bgView addSubview:_loginBtn];
}



@end
