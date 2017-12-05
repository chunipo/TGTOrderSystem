//
//  QHView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/6.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "QHView.h"
#import "FHModel.h"

@implementation QHView

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
// ,@"收货仓库",@"收货分仓库"
    _arr1 = @[@"订单号:",@"设备类型:",@"套餐:",@"渠道:",@"开始时间:",@"结束时间:",
              @"姓名:",@"电话:",@"押金收取方式:",@"设备订购数:"];
    
//    （渠道代收CSTCHANNELREC，途鸽代收CSTTGTRECEIVE）
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
    [self _initViews];
}

- (void)_initViews {

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
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i%2*(KScreenWidth / 2), 45+i/2*(40),140, 40)];
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text = _arr1[i];
        [self addSubview:contentLabel];
        
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
            rightLabel.textColor = [UIColor redColor];
            if ([_arr1[i] isEqualToString:@"设备订购数:"]) {
                rightLabel.text = [NSString stringWithFormat:@"%@ 台",rightText];
            }
        }
    }
    
    /*
    // 取货信息
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 75, 25)];
    titleLab2.layer.cornerRadius = 2;
    titleLab2.layer.masksToBounds = YES;
    titleLab2.backgroundColor = TITLE_COLOR;
    titleLab2.textAlignment = NSTextAlignmentCenter;
    titleLab2.font = [UIFont systemFontOfSize:16];
    titleLab2.textColor = [UIColor whiteColor];
    titleLab2.text = @"取货信息";
    [self addSubview:titleLab2];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 204, KScreenWidth - 25, 1)];
    line2.backgroundColor = TITLE_COLOR;
    [self addSubview:line2];
    
    for (int i = 0; i < _arr2.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%3*((KScreenWidth - 30)/3 +5), 210+i/3*(30), (KScreenWidth - 30)/3, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.numberOfLines = 0;
        contentLabel.text = _arr2[i];
        if (i == _arr2.count - 1) {
            contentLabel.width = KScreenWidth - 20;
        }
        [self addSubview:contentLabel];
    }
    
    // 押金及套餐费用
    UILabel *titleLab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 345, 120, 25)];
    titleLab3.layer.cornerRadius = 2;
    titleLab3.layer.masksToBounds = YES;
    titleLab3.backgroundColor = TITLE_COLOR;
    titleLab3.textAlignment = NSTextAlignmentCenter;
    titleLab3.font = [UIFont systemFontOfSize:16];
    titleLab3.textColor = [UIColor whiteColor];
    titleLab3.text = @"押金及套餐费用";
    [self addSubview:titleLab3];
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 369, KScreenWidth - 25, 1)];
    line3.backgroundColor = TITLE_COLOR;
    [self addSubview:line3];
    
    for (int i = 0; i < _arr3.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%2*((KScreenWidth - 30)/2 +5), 375+i/2*(30), (KScreenWidth - 30)/2, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.numberOfLines = 0;
        contentLabel.text = _arr3[i];
        [self addSubview:contentLabel];
    }
    // 设备
    UILabel *titleLab4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 85, 25)];
    titleLab4.layer.cornerRadius = 2;
    titleLab4.layer.masksToBounds = YES;
    titleLab4.backgroundColor = TITLE_COLOR;
    titleLab4.textAlignment = NSTextAlignmentCenter;
    titleLab4.font = [UIFont systemFontOfSize:16];
    titleLab4.textColor = [UIColor whiteColor];
    titleLab4.text = @"设备订购数";
    [self addSubview:titleLab4];
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 504, KScreenWidth - 25, 1)];
    line4.backgroundColor = TITLE_COLOR;
    [self addSubview:line4];
    
    for (int i = 0; i < _arr4.count; i ++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+i%2*((KScreenWidth - 30)/2 +5), 515+i/2*(30), (KScreenWidth - 30)/2, 30)];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.text = _arr4[i];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
    }
    */
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 140, 40)];
    _leftLabel.font = [UIFont systemFontOfSize:17];
    _leftLabel.text = @"小票凭证照片:";
    _leftLabel.textAlignment = NSTextAlignmentRight;
    _leftLabel.hidden = YES;
    _leftLabel.numberOfLines = 0;
    [self addSubview:_leftLabel];
    
    _xpimageView = [[UIImageView alloc] initWithFrame:CGRectMake(50+100, 260, 160, 180)];
    _xpimageView.backgroundColor = [UIColor orangeColor];
    _xpimageView.hidden = YES;
    [self addSubview:_xpimageView];
    
    _yjRightLabTitle = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2, 250, 140, 40)];
    _yjRightLabTitle.font = [UIFont boldSystemFontOfSize:17];
    _yjRightLabTitle.text = @"现场已收取:";
    _yjRightLabTitle.textAlignment = NSTextAlignmentRight;
    _yjRightLabTitle.textColor = [UIColor redColor];
    _yjRightLabTitle.hidden = YES;
    _yjRightLabTitle.numberOfLines = 0;
    [self addSubview:_yjRightLabTitle];
    
    _yjRightLabContent = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2 + 145, 250, (KScreenWidth/2 - 145), 40)];
    _yjRightLabContent.font = [UIFont boldSystemFontOfSize:17];
    _yjRightLabContent.hidden = YES;
    _yjRightLabContent.textColor = [UIColor redColor];
    _yjRightLabContent.numberOfLines = 0;
    [self addSubview:_yjRightLabContent];
    
}
@end
