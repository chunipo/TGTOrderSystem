//
//  NavBarView.h
//  TGTWiFi
//
//  Created by TGT-Tech on 15/12/10.
//  Copyright (c) 2015年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavBarView : UIView

@property (nonatomic,retain)NSString *titleStr;
- (void)initWithTitleName:(NSString *)title;
@end
