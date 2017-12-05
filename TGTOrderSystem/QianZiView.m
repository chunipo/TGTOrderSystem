//
//  QianZiView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/3.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "QianZiView.h"

@implementation QianZiView

- (void)initViewsWithSaveImageBlock:(SaveImage)saveImage {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *tipLabel_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, 50)];
    tipLabel_bg.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:tipLabel_bg];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, 50)];
    tipLabel.text = @"收货完成后，请签字确认";
    [tipLabel sizeToFit];
    tipLabel.top = (50 - tipLabel.height)/2;
    tipLabel.left = (KScreenWidth - tipLabel.width)/2;
    [tipLabel_bg addSubview:tipLabel];
    
    _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 200, self.bounds.size.width, self.bounds.size.height - 350-50)];
    _drawView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _drawView.pathColor = [UIColor blackColor];
    _drawView.lineWidth = 7;
    _drawView.alpha = 1;
    [self addSubview:_drawView];
    
    UIView *bottomBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, _drawView.bottom, KScreenWidth, 50)];
    bottomBtnView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:bottomBtnView];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.frame = CGRectMake((KScreenWidth/3 - 200)/2, 0, 200, 40);
    _clearButton.backgroundColor = [UIColor whiteColor];
    [_clearButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _clearButton.layer.cornerRadius = 5;
    _clearButton.layer.masksToBounds = YES;
    _clearButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _clearButton.layer.borderWidth = 1;
    [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_clearButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_clearButton];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((KScreenWidth/3 - 200)/2 + KScreenWidth/3, 0, 200, 40);
    saveBtn.backgroundColor = [UIColor whiteColor];
    [saveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    saveBtn.layer.borderWidth = 1;
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:saveBtn];
    
    _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _undoButton.frame = CGRectMake((KScreenWidth/3 - 200)/2 + KScreenWidth * 2/3, 0, 200, 40);
    _undoButton.backgroundColor = [UIColor whiteColor];
    _undoButton.layer.cornerRadius = 5;
    _undoButton.layer.masksToBounds = YES;
    _undoButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _undoButton.layer.borderWidth = 1;
    [_undoButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_undoButton setTitle:@"关闭" forState:UIControlStateNormal];
    _undoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_undoButton addTarget:self action:@selector(undoAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_undoButton];
    
    self.saveImageBlock = ^(UIImage *image) {
        saveImage(image);
    };
}

- (void)undoAction:(UIButton *)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}
- (void)btnAction:(UIButton *)sender {
    
    [_drawView clear];
}
- (void)saveAction:(UIButton *)sender {
    
    // 保存
    if (_drawView.pathArr.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先签字" delegate: nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self save];
}

- (void)save {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        // 获取上下文
        UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 把控件上的图层渲染到上下文
        [_drawView.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        // 保存回调（image）
        self.saveImageBlock(image);
        
    }];
}

@end
