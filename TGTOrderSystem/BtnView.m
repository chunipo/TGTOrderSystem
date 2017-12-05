//
//  BtnView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "BtnView.h"

@implementation BtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self _initViews];
    }
    return self;
}

- (void)_initViews {

    _view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    _view1.layer.cornerRadius = self.width/2;
    _view1.layer.masksToBounds = YES;
    [self addSubview:_view1];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ADAPTER(40), ADAPTER(40))];
    _imgView.layer.cornerRadius = ADAPTER(20);
    _imgView.layer.masksToBounds = YES;
    _imgView.center = _view1.center;
    _imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.width+5, self.width, 30)];
    CGFloat fontSize = isPad ? 16 : 14;
    _titleLab.textColor = [UIColor darkGrayColor];
    _titleLab.font = [UIFont systemFontOfSize:fontSize];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
}
@end
