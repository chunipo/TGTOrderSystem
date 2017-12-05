//
//  TextFieldView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/11.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldView : UIView

@property (nonatomic,retain)UITextField *textField;

- (void)setTextFieldPlaceholder:(NSString *)placeholder;
@end
