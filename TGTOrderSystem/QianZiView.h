//
//  QianZiView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/3.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

typedef void (^SaveImage)(UIImage *image);

@interface QianZiView : UIView

@property (nonatomic,copy)SaveImage saveImageBlock;
@property (nonatomic,retain)DrawView *drawView;
@property (nonatomic,retain)UIButton *clearButton;
@property (nonatomic,retain)UIButton *undoButton;

- (void)initViewsWithSaveImageBlock:(SaveImage)saveImage;
@end
