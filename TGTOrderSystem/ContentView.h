//
//  ContentView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/5.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BtnView.h"
#import "RadioBtn.h"

@interface ContentView : UIView

@property (nonatomic,retain)RadioBtn *radioBtn1;
@property (nonatomic,retain)RadioBtn *radioBtn2;

@property (nonatomic,retain)NSArray *title;
@end
