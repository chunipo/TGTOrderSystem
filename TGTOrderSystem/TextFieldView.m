//
//  TextFieldView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "TextFieldView.h"

@implementation TextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setTextFieldPlaceholder:(NSString *)placeholder {

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.frame) - 5, CGRectGetHeight(self.frame))];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = placeholder;
    [self addSubview:_textField];
}

@end
