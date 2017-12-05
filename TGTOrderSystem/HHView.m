//
//  HHView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/7.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "HHView.h"

static HHView *share_hhView = nil;
@implementation HHView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        share_hhView = self;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
+ (HHView *)shareHHView {
    return share_hhView;
}
- (void)_loadData:(FHModel *)model {
    _model = model;
    _arr1 = @[@"订单号:",@"设备类型:",@"套餐:",@"渠道:",@"开始时间:",@"结束时间:",
              @"姓名:",@"电话:",@"押金收取方式:",@"设备订购数:"];
    NSString *depositmode = [NSString stringWithFormat:@"%@",model.depositmode];
    if ([depositmode isEqualToString:@"CSTCHANNELREC"]) {
        depositmode = @"渠道代收";
    } else if ([depositmode isEqualToString:@"CSTTGTRECEIVE"]) {
        depositmode = @"途鸽代收";
    }
    
    _rightArr = @[[NSString stringWithFormat:@"%@",model.orderno],
                  [NSString stringWithFormat:@"%@",model.t2t1flag],
                  [NSString stringWithFormat:@"%@",model.dptypeid],
                  [NSString stringWithFormat:@"%@",model.members],
                  [NSString stringWithFormat:@"%@",[model.start_time componentsSeparatedByString:@" "].firstObject],
                  [NSString stringWithFormat:@"%@",[model.end_time componentsSeparatedByString:@" "].firstObject],
                  [NSString stringWithFormat:@"%@",model.membername],
                  [NSString stringWithFormat:@"%@",model.membercellphone],
                  [NSString stringWithFormat:@"%@",depositmode],
                  [NSString stringWithFormat:@"%@",model.ticketcount]];
    [self _initViews:model];
}
- (void)btn1Action:(UIButton *)sender {

    NSString *deliverypath = [NSString stringWithFormat:@"%@",_model.deliverypath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    
    UIView *imgbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imgbgView.backgroundColor = [UIColor blackColor];
    [self.superview addSubview:imgbgView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, KScreenHeight - 240)];
    bgimageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [imgbgView addSubview:bgimageView];
    bgimageView.userInteractionEnabled = YES;
    
    if (deliveryData == nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // something
            [[GetOrderImage shareInstance] getOrderImageWithOrder_no:_model.orderno Type:@"delivery" ImgUrlBlock:^(NSString *imgurl) {
                NSLog(@"%@",imgurl);
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]]];
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSData *data = UIImageJPEGRepresentation(image,0.5);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
                    [data writeToFile:filePath atomically:YES];
                    
                    bgimageView.image = image;
                });
            }];
        });
    } else {
        bgimageView.image = [UIImage imageWithContentsOfFile:deliveryPath];
    }
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap:)];
    tap1.numberOfTapsRequired = 1;
    [imgbgView addGestureRecognizer:tap1];
}
- (void)btn2Action:(UIButton *)sender {
    
    NSString *receivedpath = [NSString stringWithFormat:@"%@",_model.receivedpath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    
    UIView *imgbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imgbgView.backgroundColor = [UIColor blackColor];
    [self.superview addSubview:imgbgView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, KScreenHeight - 240)];
    bgimageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [imgbgView addSubview:bgimageView];
    bgimageView.userInteractionEnabled = YES;
    
    if (receivedData == nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // something
            [[GetOrderImage shareInstance] getOrderImageWithOrder_no:_model.orderno Type:@"received" ImgUrlBlock:^(NSString *imgurl) {
                NSLog(@"%@",imgurl);
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]]];
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSData *data = UIImageJPEGRepresentation(image,0.5);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
                    [data writeToFile:filePath atomically:YES];
                    
                    bgimageView.image = image;
                });
            }];
        });
    } else {
        bgimageView.image = [UIImage imageWithContentsOfFile:receivedPath];
    }
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap:)];
    tap1.numberOfTapsRequired = 1;
    [imgbgView addGestureRecognizer:tap1];
}
- (void)popTap:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:.25 animations:^{
        tap.view .alpha = 0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}
- (void)_initViews:(FHModel *)model {
    
    // 订单信息
    UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 75, 25)];
    titleLab1.layer.cornerRadius = 2;
    titleLab1.layer.masksToBounds = YES;
    titleLab1.backgroundColor = TITLE_COLOR;
    titleLab1.textAlignment = NSTextAlignmentCenter;
    titleLab1.font = [UIFont systemFontOfSize:16];
    titleLab1.textColor = [UIColor whiteColor];
    titleLab1.text = @"订单信息";
    [self addSubview:titleLab1];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, KScreenWidth - 25, 1)];
    line1.backgroundColor = TITLE_COLOR;
    [self addSubview:line1];
    
    NSString *deliverypath = [NSString stringWithFormat:@"%@",model.deliverypath];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",model.receivedpath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",_model.orderno]];
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",_model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    NSArray *arr;
    if (deliveryData == nil && receivedData == nil) {
        
        if ([deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
            
        } else if (![deliverypath isEqualToString:@"(null)"] && ![receivedpath isEqualToString:@"(null)"]) {
            arr = @[@"点击查看小票",@"点击查看签字"];
        } else {
            if (![deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
                arr = @[@"点击查看小票"];
            } else {
                arr = @[@"点击查看签字"];
            }
        }
    } else if (deliveryData != nil && receivedData != nil) {
        arr = @[@"点击查看小票",@"点击查看签字"];
    } else {
        if (deliveryData != nil && receivedData == nil) {
            if ([receivedpath isEqualToString:@"(null)"]) {
                arr = @[@"点击查看小票"];
            } else {
                arr = @[@"点击查看小票",@"点击查看签字"];
            }
        } else {
            if ([deliverypath isEqualToString:@"(null)"]) {
                arr = @[@"点击查看签字"];
            } else {
                arr = @[@"点击查看小票",@"点击查看签字"];
            }
        }
    }
    for (int i = 0 ; i < arr.count;  i ++) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn1.frame = CGRectMake(20 + i * 120, 250, 120, 40);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:arr[i]];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [btn1 setAttributedTitle:str forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:17];
//        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([[NSString stringWithFormat:@"%@",arr[i]] isEqualToString:@"点击查看小票"]) {
            [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([[NSString stringWithFormat:@"%@",arr[i]] isEqualToString:@"点击查看签字"]) {
            [btn1 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:btn1];
    }
    
    
    for (int i = 0; i < _arr1.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i%2*(KScreenWidth / 2), 45+i/2*(40),140, 40)];
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text = _arr1[i];
        [self addSubview:contentLabel];
        
        if (i < _arr1.count) {
         
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(145 + i%2*(KScreenWidth / 2), 45+i/2*(40),(KScreenWidth / 2 - 155), 40)];
            rightLabel.font = [UIFont systemFontOfSize:17];
            rightLabel.numberOfLines = 0;
            rightLabel.textColor = [UIColor darkGrayColor];
            NSString *rightText = [NSString stringWithFormat:@"%@",_rightArr[i]];
            if ([rightText isEqualToString:@""]||[rightText isEqualToString:@"<null>"] ||[rightText isEqualToString:@"(null)"]) {
                rightText = @"无";
            }
            rightLabel.text = rightText;
            [self addSubview:rightLabel];
            
            if ([_arr1[i] isEqualToString:@"设备类型:"]||[_arr1[i] isEqualToString:@"押金收取方式:"]||[_arr1[i] isEqualToString:@"设备订购数:"]) {
//                rightLabel.font = [UIFont boldSystemFontOfSize:17];
                rightLabel.textColor = [UIColor redColor];
                if ([_arr1[i] isEqualToString:@"设备订购数:"]) {
                    rightLabel.text = [NSString stringWithFormat:@"%@ 台",rightText];
                }
            }
        } else {
            
            if (i == _arr1.count - 3) {
                
                _ckTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(145 + i%2*(KScreenWidth / 2), 45+i/2*(40) + 7.5,(KScreenWidth / 2 - 180), 25)];
                [_ckTfView setTextFieldPlaceholder:@"收货仓库"];
                _ckTfView.textField.delegate = self;
                [self addSubview: _ckTfView];
            } else if (i == _arr1.count - 2) {
                
                _radioBtn2 = [[RadioBtn alloc] initWithFrame:CGRectMake(145 + i%2*(KScreenWidth / 2), 45+i/2*(40),80, 40)];
                [_radioBtn2 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"途鸽已收" action:@selector(t2Action:)];
                _radioBtn2.btn.selected = YES;
                _radioBtn3 = [[RadioBtn alloc] initWithFrame:CGRectMake(145 + i%2*(KScreenWidth / 2), 45+i/2*(40),80, 40)];
                [_radioBtn3 setBtnNormalImg:[UIImage imageNamed:@"qitafuwu2@2x_03"] selectImg:[UIImage imageNamed:@"qitafuwu1@2x_03"] title:@"渠道代收" action:@selector(t2Action:)];
//                [self addSubview:_radioBtn2];
                [self addSubview:_radioBtn3];
                
            } else {
                
                if ([model.t2t1flag isEqualToString:@"T2"]||[model.t2t1flag isEqualToString:@"SCP"]) {
                    _fckTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(145 + i%2*(KScreenWidth / 2), 45+i/2*(40) + 7.5,(KScreenWidth / 2 - 180), 25)];
                    [_fckTfView setTextFieldPlaceholder:@"收货分仓库"];
                    _fckTfView.textField.delegate = self;
                    [self addSubview: _fckTfView];

                } else {
                    contentLabel.hidden = YES;
                }
            }
        }
    }
    
    
}
- (void)t2Action:(UIButton *)sender {
    
    if (sender == _radioBtn2.btn) {
        _radioBtn2.btn.selected = YES;
        _radioBtn3.btn.selected = NO;
    } else {
        _radioBtn3.btn.selected = YES;
        _radioBtn2.btn.selected = NO;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField == _ckTfView.textField) {
        [seleCtView removeFromSuperview];
        seleCtView = [[CkSelectView alloc] initWithFrame:CGRectMake(0, self.superview.height - 250, self.superview.width, 250) WithTitle:@"收货仓库" formPage:@"zcsh" number:@""];
        [self.superview addSubview:seleCtView];
    } else if (textField == _fckTfView.textField) {
        [seleCtView removeFromSuperview];
        seleCtView = [[CkSelectView alloc] initWithFrame:CGRectMake(0, self.superview.height - 250, self.superview.width, 250) WithTitle:@"收货分仓库" formPage:@"zcsh" number:@""];
        [self.superview addSubview:seleCtView];
    }
    return NO;
}
@end
