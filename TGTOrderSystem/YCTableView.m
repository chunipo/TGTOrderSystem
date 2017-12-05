//
//  YCTableView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/17.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "YCTableView.h"
#import "YCDevStateSelectView.h"
#import "YCSHView.h"

@interface YCTableView ()
{
    YCDevStateSelectView *_selectView;
}
@end

@implementation YCTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
      
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayPickerAction:) name:@"daysPicker" object:nil];
        _dataList = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"daysPicker" object:nil];
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
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,50, cell.height)];
    number.font = [UIFont systemFontOfSize:16];
    number.textAlignment = NSTextAlignmentCenter;
    number.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [cell.contentView addSubview:number];
    
    float width = (self.width - 100)/3;
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0,width, cell.height)];
    desLab.font = [UIFont systemFontOfSize:16];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.text = [NSString stringWithFormat:@"%@",dic[@"des"]];
    [cell.contentView addSubview:desLab];
    
    UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(50+width, 0,width, cell.height)];
    stateLab.font = [UIFont systemFontOfSize:16];
    stateLab.textAlignment = NSTextAlignmentCenter;
    stateLab.text = [NSString stringWithFormat:@"%@",dic[@"state"]];
    [cell.contentView addSubview:stateLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(50+2*width, 0,width, cell.height)];
    priceLab.font = [UIFont systemFontOfSize:16];
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.text = [NSString stringWithFormat:@"%@",dic[@"price"]];
    [cell.contentView addSubview:priceLab];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    numberLab.font = [UIFont systemFontOfSize:16];
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.text = @"序号";
    [bgView addSubview:numberLab];
    
    float width = (self.width - 100)/3;
    UILabel *sbshLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, width, 40)];
    sbshLab.font = [UIFont systemFontOfSize:16];
    sbshLab.textAlignment = NSTextAlignmentCenter;
    sbshLab.text = @"设备损毁情况";
    [bgView addSubview:sbshLab];
    
    UILabel *sbztLab = [[UILabel alloc] initWithFrame:CGRectMake(50+width, 0, width, 40)];
    sbztLab.font = [UIFont systemFontOfSize:16];
    sbztLab.textAlignment = NSTextAlignmentCenter;
    sbztLab.text = @"设备状态";
    [bgView addSubview:sbztLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(50 + 2*width, 0, width, 40)];
    priceLab.font = [UIFont systemFontOfSize:16];
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.text = @"价格";
    [bgView addSubview:priceLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = TITLE_COLOR;
    button.frame = CGRectMake(self.width - 65, 2.5, 60, 35);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    return bgView;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_dataList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *str = @"";
        NSInteger price_intger = 0;
        for (NSDictionary *dic in _dataList) {
            str = [NSString stringWithFormat:@"%@%@%@%@；",str,dic[@"des"],dic[@"state"],dic[@"price"]];
            NSString *price_str = dic[@"price"];
            price_intger = price_intger + [price_str integerValue];
        }
        [YCSHView shareYCSHView].shReasonTfView.text = str;
        [YCSHView shareYCSHView].shKFTfView.textField.text = [NSString stringWithFormat:@"%.2f",(float)price_intger];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (void)btnAction:(UIButton *)sender {

    [_selectView removeFromSuperview];
    _selectView = [[YCDevStateSelectView alloc] initWithFrame:CGRectMake(0, self.superview.height - 250, self.superview.width, 250)];
    _selectView.backgroundColor = [UIColor whiteColor];
    [self.superview addSubview:_selectView];
}

- (void)dayPickerAction:(NSNotification *)sender {
    
    NSString *tag = [NSString stringWithFormat:@"%@",sender.userInfo[@"btnTag"]];
    if ([tag isEqualToString:@"0"]) {
       
        [_selectView removeFromSuperview];
    } else if ([tag isEqualToString:@"1"]) {
        
        [_selectView removeFromSuperview];
        
        NSInteger row1 = [_selectView.picker selectedRowInComponent:0];
        NSString *leftStr = [NSString stringWithFormat:@"%@",_selectView.arr[row1]];
        
        NSInteger row2 = [_selectView.picker selectedRowInComponent:1];
        NSString *rightStr = [NSString stringWithFormat:@"%@",_selectView.arrState[row2]];

        NSString *price;
        if ([leftStr isEqualToString:@"设备屏幕"]) {
            price = @"200.00";
        } else if ([leftStr isEqualToString:@"充电头"]) {
            price = @"25.00";
        } else if ([leftStr isEqualToString:@"充电插口"]) {
            price = @"200.00";
        } else if ([leftStr isEqualToString:@"数据线"]) {
            price = @"25.00";
        } else if ([leftStr isEqualToString:@"皮套"]) {
            price = @"50.00";
        } else if ([leftStr isEqualToString:@"设备/SIM卡"]) {
            price = @"500.00";
        } else if ([leftStr isEqualToString:@"设备外壳"]) {
            price = @"100.00";
        }
        
        [_dataList addObject:@{@"des":leftStr,@"state":rightStr,@"price":price}];
        
        NSString *str = @"";
        NSInteger price_intger = 0;
        for (NSDictionary *dic in _dataList) {
            str = [NSString stringWithFormat:@"%@%@%@%@；",str,dic[@"des"],dic[@"state"],dic[@"price"]];
            NSString *price_str = dic[@"price"];
            price_intger = price_intger + [price_str integerValue];
        }
        [YCSHView shareYCSHView].shReasonTfView.text = str;
        [YCSHView shareYCSHView].shKFTfView.textField.text = [NSString stringWithFormat:@"%.2f",(float)price_intger];
        [self reloadData];
    }
}
@end
