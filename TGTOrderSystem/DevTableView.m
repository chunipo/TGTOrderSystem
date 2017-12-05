//
//  DevTableView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/16.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "DevTableView.h"

@implementation DevTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *dic = _dataList[indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth - 15, 60)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = [NSString stringWithFormat:@"%@",dic[@"equno"]];
    [cell.contentView addSubview:label];
    
    UILabel *statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 15 - 90, 0, 90, 60)];
    statuslabel.font = [UIFont systemFontOfSize:16];
    statuslabel.textAlignment = NSTextAlignmentLeft;
    statuslabel.textColor = [UIColor darkGrayColor];
    NSString *str = [NSString stringWithFormat:@"%@",dic[@"status"]];
    NSString *number = [NSString stringWithFormat:@"%@",dic[@"number"]];
    NSString *equno = [NSString stringWithFormat:@"%@",dic[@"equno"]];
    if ([str isEqualToString:@"RECEIVED"]) {
        statuslabel.text = @"已发货";
    } else if ([str isEqualToString:@"待发货"]) {
        statuslabel.text = @"待发货";
    } else if ([str isEqualToString:@"PAID"] && equno.length != 0) {
        statuslabel.text = @"已发货";
    } else if ([str isEqualToString:@"CLOSED"]) {
        statuslabel.text = @"已关闭";
    } else {
        statuslabel.text = @"其他状态";
    }
    
    [cell.contentView addSubview:statuslabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59, KScreenWidth - 20, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell.contentView addSubview:line];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)  //----通过表视图是否处于编辑状态来选择是左滑删除还是多选删除。
    {
        //当表视图处于没有未编辑状态时选择多选删除
        return UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert;
    }
    else
    {
        NSDictionary *dic = _dataList[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"status"]];
        if ([str isEqualToString:@"待发货"]) {
            //当表视图处于没有未编辑状态时选择左滑删除
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleNone;
        }
    }
}
//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_dataList removeObjectAtIndex:indexPath.row];
       
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
        [_dataList writeToFile:filename atomically:YES];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_dataList forKey:@"devList"];
        [dic setObject:@"1" forKey:@"delete"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dev" object:nil userInfo:dic];
    }
    else if(editingStyle == (UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert))
    {
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
