//
//  EqunoTableView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/9/19.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "EqunoTableView.h"

@implementation EqunoTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}
- (void)setDataList:(NSArray *)dataList {

    if (dataList.count <= 10) {
        _dataList = dataList;
    } else {
        NSMutableArray *marr = [NSMutableArray array];
        for (int i = 0; i < 10; i ++) {
            [marr addObject:dataList[i]];
        }
        _dataList = marr;
    }
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic= _dataList[indexPath.row];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, self.width - 1, 59)];
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"equipmentcode"]];
    [cell.contentView addSubview:contentLabel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic= _dataList[indexPath.row];
    NSString *equipmentcode = [NSString stringWithFormat:@"%@",dic[@"equipmentcode"]];
    
    if ([equipmentcode hasPrefix:@"TGT"]) {
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filename];
        
        if (arr.count < [_devCount integerValue]) {
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已添加完成" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSMutableArray *dev_arr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [dev_arr addObject:dic[@"equno"]];
        }
        if ([dev_arr containsObject:equipmentcode]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请勿重复添加同一设备" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag = 107;
            [alert show];
            return;
        }
        [arr addObject:@{@"equno":equipmentcode,@"status":@"待发货",@"number":@""}];
        
        [arr writeToFile:filename atomically:YES];
        NSArray *arr1 = [NSArray arrayWithContentsOfFile:filename];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr1 forKey:@"devList"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
        
    }
}
@end
