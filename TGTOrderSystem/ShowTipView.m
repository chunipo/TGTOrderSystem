//
//  ShowTipView.m
//  TGTWiFi
//
//  Created by TGT-Tech on 15/11/30.
//  Copyright (c) 2015年 TGT. All rights reserved.
//

#import "ShowTipView.h"
#import "TipView.h"

@implementation ShowTipView

+ (void)showTipView:(UIView *)superView msg:(NSString *)msg {

    TipView *tip;
    if (tip != nil) {
        [tip removeFromSuperview];
    }
    tip = [[TipView alloc] init];
    [tip showTipIn:superView andTipMsg:msg];
}
@end
