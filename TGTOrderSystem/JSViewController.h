//
//  JSViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/23.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldView.h"

@interface JSViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSArray *leftArr;
@property (nonatomic,retain)NSArray *rightArr;
@property (nonatomic,copy)NSString *devNumber;

@property (nonatomic,retain)TextFieldView *ycghTfView;
@property (nonatomic,retain)TextFieldView *shkfTfView;
@property (nonatomic,retain)TextFieldView *qtfyTfView;
@property (nonatomic,retain)UITextView *myTextView;

@property (nonatomic,retain)UIView *imgBgView;
@property (nonatomic,retain)UIImageView *imgView;
@end
