//
//  OrderView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/6/15.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)_loadData:(FHModel *)model {
    
    _arr1 = @[[@"订单号：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.orderno]]],
              [@"OTA订单：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.otaorderid]]],
              [@"订单状态：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.orderstatus]]],
              [@"T2T1标识：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.t2t1flag]]],
              [@"商业模式：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.salerentalflag]]],
              [@"渠道：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.members]]],
              [@"区域：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.area]]],
              [@"目的地：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.country_set]]],
              [@"套餐：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.dptypeid]]],
              [@"渠道组织：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.org]]],
              [@"结算人：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.settleman]]],
              [@"销售员：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.salesperson]]],
              [@"业务部门：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.bizorg]]],
              [@"开始时间：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",[model.start_time componentsSeparatedByString:@" "].firstObject]]],
              [@"结束时间：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",[model.end_time componentsSeparatedByString:@" "].firstObject]]]];
    
    _arr2 = @[[@"取货人姓名：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.membername]]],
              [@"取货人电话：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.membercellphone]]],
              [@"取货方式：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.carrytype]]],
              [@"订单所属者：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.use_members]]],
              [@"取件地点：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.takelocationname]]],
              [@"还件地点：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.returnlocationname]]],
              [@"快递号：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.expno]]],
              [@"预计发货日期：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",[model.expectdeliverytime componentsSeparatedByString:@" "].firstObject]]],
              [@"预计归还日期：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",[model.expectreturntime componentsSeparatedByString:@" "].firstObject]]],
              [@"备注：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.contactremark]]]];
    
    _arr3 = @[[@"押金收取方式：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.depositmode]]],
              [@"押金：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.deposit]]],
              [@"套餐支付方式：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.paynowpaylaterflag]]],
              [@"套餐金额：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.channelorderdptypefee]]],
              [@"取消费用：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",@"无"]]]];
    
    _arr4 = @[[@"设备订购数：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.ticketcount]]],
              [@"取消数量：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.cancelcount]]],
              [@"下单人：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.creator]]],
              [@"下单时间：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.created_time]]],
              [@"最近修改者：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.last_modifier]]],
              [@"最近修改时间：" stringByAppendingString:[self modelStrTostr:[NSString stringWithFormat:@"%@",model.last_modified_time]]]];
    
    
    
    NSString *deliverypath = [NSString stringWithFormat:@"%@",model.deliverypath];
    NSString *receivedpath = [NSString stringWithFormat:@"%@",model.receivedpath];
    if (![deliverypath isEqualToString:@"(null)"]) {
        deliverypath = [@"http://" stringByAppendingString:deliverypath];
    }
    if (![receivedpath isEqualToString:@"(null)"]) {
        receivedpath = [@"http://" stringByAppendingString:receivedpath];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *deliveryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",model.orderno]];
    NSString *receivedPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",model.orderno]];
    NSData *deliveryData = [NSData dataWithContentsOfFile:deliveryPath];
    NSData *receivedData = [NSData dataWithContentsOfFile:receivedPath];
    
    if (deliveryData == nil && receivedData == nil) {
        
        if ([deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
            _arr5 = @[];
            _arr6 = @[];
        } else if (![deliverypath isEqualToString:@"(null)"] && ![receivedpath isEqualToString:@"(null)"]) {
            _arr5 = @[@"小票图片",@"签字图片"];
            _arr6 = @[deliverypath,receivedpath];
        } else {
            if (![deliverypath isEqualToString:@"(null)"] && [receivedpath isEqualToString:@"(null)"]) {
                _arr5 = @[@"小票图片"];
                _arr6 = @[deliverypath];
            } else {
                _arr5 = @[@"签字图片"];
                _arr6 = @[receivedpath];
            }
        }
    } else if (deliveryData != nil && receivedData != nil) {
        _arr5 = @[@"小票图片",@"签字图片"];
        _arr6 = @[deliveryPath,receivedPath];
    } else {
        if (deliveryData != nil && receivedData == nil) {
            if ([receivedpath isEqualToString:@"(null)"]) {
                _arr5 = @[@"小票图片"];
                _arr6 = @[deliveryPath];
            } else {
                _arr5 = @[@"小票图片",@"签字图片"];
                _arr6 = @[deliveryPath,receivedpath];
            }
        } else {
            if ([deliverypath isEqualToString:@"(null)"]) {
                _arr5 = @[@"签字图片"];
                _arr6 = @[receivedPath];
            } else {
                _arr5 = @[@"小票图片",@"签字图片"];
                _arr6 = @[deliverypath,receivedPath];
            }
        }
    }
    
    [self _initViews:model];
}
- (NSString *)modelStrTostr:(NSString *)str {
    if ([str isEqualToString:@""]||[str isEqualToString:@"<null>"]||[str isEqualToString:@"(null)"]) {
        str = @"无";
    }
    // 订单状态
    if ([str isEqualToString:@"PAID"]) {
        str = @"已支付";
    }
    if ([str isEqualToString:@"RECEIVED"]) {
        str = @"已取件";
    }
    if ([str isEqualToString:@"CLOSED"]) {
        str = @"已关闭";
    }
    if ([str isEqualToString:@"SETTLED"]) {
        str = @"已结算";
    }
    if ([str isEqualToString:@"PARTIALCANCEL"]) {
        str = @"部分取消";
    }
    if ([str isEqualToString:@"CANCELFAIL"]) {
        str = @"取消（审核）失败";
    }
    if ([str isEqualToString:@"SAVE"]) {
        str = @"保存";
    }
    if ([str isEqualToString:@"NEW"]) {
        str = @"新建";
    }
    // 商业模式
    if ([str isEqualToString:@"CST8RENTAL"]) {
        str = @"租赁";
    }
    // 取货方式
    if ([str isEqualToString:@"CARRY"]) {
        str = @"自提";
    }
    if ([str isEqualToString:@"SEND"]) {
        str = @"邮寄";
    }
    if ([str isEqualToString:@"CSTCHANNELREC"]) {
        str = @"渠道代收";
    }
    if ([str isEqualToString:@"CSTTGTRECEIVE"]) {
        str = @"途鸽代收";
    }
    if ([str isEqualToString:@"CSTPANYLATER"]) {
        str = @"挂账";
    }
    if ([str isEqualToString:@"CSTPANYNOW"]) {
        str = @"现付";
    }
    return str;
}
- (void)_initViews:(FHModel *)model {
    
    CGFloat fontSize = isPad ? 14 : 12;
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
    
    for (int i = 0; i < _arr1.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%3*((KScreenWidth - 30)/3 +5), 45+i/3*(30), (KScreenWidth - 30)/3, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.numberOfLines = 0;
        contentLabel.text = _arr1[i];
        [self addSubview:contentLabel];
        
    }
    
     // 取货信息
     UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 180+30, 75, 25)];
     titleLab2.layer.cornerRadius = 2;
     titleLab2.layer.masksToBounds = YES;
     titleLab2.backgroundColor = TITLE_COLOR;
     titleLab2.textAlignment = NSTextAlignmentCenter;
     titleLab2.font = [UIFont systemFontOfSize:16];
     titleLab2.textColor = [UIColor whiteColor];
     titleLab2.text = @"取货信息";
     [self addSubview:titleLab2];
     UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 234, KScreenWidth - 25, 1)];
     line2.backgroundColor = TITLE_COLOR;
     [self addSubview:line2];
     
     for (int i = 0; i < _arr2.count; i ++) {
     
     UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%3*((KScreenWidth - 30)/3 +5), 240+i/3*(30), (KScreenWidth - 30)/3, 30)];
     contentLabel.font = [UIFont systemFontOfSize:fontSize];
     contentLabel.numberOfLines = 0;
     contentLabel.text = _arr2[i];
     if (i == _arr2.count - 1) {
         contentLabel.width = KScreenWidth - 20;
         contentLabel.height = 40;
         contentLabel.numberOfLines = 0;
//         contentLabel.textColor = [UIColor darkGrayColor];
        }
     [self addSubview:contentLabel];
     }
     
    // 押金及套餐费用
    UILabel *titleLab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 345+30, 120, 25)];
    titleLab3.layer.cornerRadius = 2;
    titleLab3.layer.masksToBounds = YES;
    titleLab3.backgroundColor = TITLE_COLOR;
    titleLab3.textAlignment = NSTextAlignmentCenter;
    titleLab3.font = [UIFont systemFontOfSize:16];
    titleLab3.textColor = [UIColor whiteColor];
    titleLab3.text = @"押金及套餐费用";
    [self addSubview:titleLab3];
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 369+30, KScreenWidth - 25, 1)];
    line3.backgroundColor = TITLE_COLOR;
    [self addSubview:line3];
    
    for (int i = 0; i < _arr3.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%2*((KScreenWidth - 30)/2 +5), 375+30+i/2*(30), (KScreenWidth - 30)/2, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.numberOfLines = 0;
        contentLabel.text = _arr3[i];
        [self addSubview:contentLabel];
    }
    // 设备
    UILabel *titleLab4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 480+30, 85, 25)];
    titleLab4.layer.cornerRadius = 2;
    titleLab4.layer.masksToBounds = YES;
    titleLab4.backgroundColor = TITLE_COLOR;
    titleLab4.textAlignment = NSTextAlignmentCenter;
    titleLab4.font = [UIFont systemFontOfSize:16];
    titleLab4.textColor = [UIColor whiteColor];
    titleLab4.text = @"设备订购数";
    [self addSubview:titleLab4];
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 534, KScreenWidth - 25, 1)];
    line4.backgroundColor = TITLE_COLOR;
    [self addSubview:line4];
    
    for (int i = 0; i < _arr4.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%2*((KScreenWidth - 30)/2 +5), 545+i/2*(30), (KScreenWidth - 30)/2, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.text = _arr4[i];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
    }
    
    for (int i = 0; i < _arr5.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%2*((KScreenWidth - 30)/2 +5), 645+i/2*(30), 60, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.text = _arr5[i];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentLabel.right + 5, contentLabel.top + 5 , 180, 200)];
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        NSString *pathStr = [NSString stringWithFormat:@"%@",_arr6[i]];
        if ([pathStr containsString:@"http:"]) {
            // 加载网络图片
            if ([pathStr containsString:@"received"]) {
                
                [[GetOrderImage shareInstance] getOrderImageWithOrder_no:model.orderno Type:@"received" ImgUrlBlock:^(NSString *imgurl) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageView.image = image;
                            // 此处保存图片
                            NSData *data = UIImageJPEGRepresentation(image,0.5);
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_received.png",model.orderno]];
                            [data writeToFile:filePath atomically:YES];
                        });
                    });
                }];
                
            } else if ([pathStr containsString:@"delivery"]) {
                
                [[GetOrderImage shareInstance] getOrderImageWithOrder_no:model.orderno Type:@"delivery" ImgUrlBlock:^(NSString *imgurl) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageView.image = image;
                            // 此处保存图片
                            NSData *data = UIImageJPEGRepresentation(image,0.5);
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_delivery.png",model.orderno]];
                            [data writeToFile:filePath atomically:YES];
                        });
                    });
                }];
            }
        } else {
            imageView.image = [UIImage imageWithContentsOfFile:pathStr];
        }
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
}

#pragma mark - 显示图片
- (void)tapAction: (UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    UIImage *image = imageView.image;
    
    UIView *imgbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imgbgView.backgroundColor = [UIColor blackColor];
    [self.superview addSubview:imgbgView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, KScreenHeight - 240)];
    bgimageView.image = image;
    [imgbgView addSubview:bgimageView];
    bgimageView.userInteractionEnabled = YES;
    
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
@end
