//
//  DevListView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/23.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "DevListView.h"

@implementation DevListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        
        [self _initView];
        [self _initCloseBtn];
    }
    return self;
}

- (void)_initCloseBtn {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 150-33, 135, 50, 50)];
    //    imgView.backgroundColor = [UIColor orangeColor];
    imgView.image = [UIImage imageNamed:@"guanbi@2x"];
    imgView.layer.cornerRadius = 25;
    imgView.layer.masksToBounds = YES;
    [self addSubview:imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap];
}
#pragma mark - hideView
- (void)hideView {
    [self removeFromSuperview];
}

- (void)_initView {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(150, 150, KScreenWidth - 300, KScreenHeight - 400)];
    bgView.backgroundColor = BG_COLOR;
    [self addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgView.width, 50)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.backgroundColor = BG_COLOR;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.text = @"请选择异常设备";
    [bgView addSubview:titleLab];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, bgView.width, bgView.height - 60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [bgView addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"TGT2116030002%ld",(long)indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *devStr =  [NSString stringWithFormat:@"TGT2116030002%ld",(long)indexPath.row];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ycDev" object:nil userInfo:@{@"dev":devStr}];
}


@end
