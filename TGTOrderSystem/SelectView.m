//
//  SelectView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/12.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView

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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 185, 115, 50, 50)];
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

#pragma mark- layoutSubviews
- (void)layoutSubviews {
    
    [_tableView reloadData];
}

#pragma mark - 创建视图
- (void)_initView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(150, 130, KScreenWidth - 300, KScreenHeight - 400) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%ld",_dataList[indexPath.row],(long)indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 50)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 50)];
    titleLab.backgroundColor = BG_COLOR;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = _titleName;
    [bgView addSubview:titleLab];
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = [NSString stringWithFormat:@"%@%ld",_dataList[indexPath.row],(long)indexPath.row];
    self.selectBlock(str);
    [self removeFromSuperview];
}
@end
