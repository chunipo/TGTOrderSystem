//
//  YCDevStateSelectView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/6/16.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "YCDevStateSelectView.h"

@implementation YCDevStateSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _arr = @[@"设备屏幕",@"充电头",@"充电插口",@"数据线",@"皮套",@"设备/SIM卡",@"设备外壳"];
        _arrState = @[@"损毁"];
        
        [self initBtn];
        [self initPickerView];
    }
    return self;
}
- (void)initBtn {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width,50)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择设备异常情况";
    [self addSubview:titleLabel];
    
    NSArray *btnTitle = @[@"取消",@"确定"];
    for (int i = 0; i < 2; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i * (self.width - 50), 0, 50, 50);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:btnTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.1608 green:.5294 blue:.9412 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
- (void)initPickerView {
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 50, self.width - 100, 200)];
    _picker.backgroundColor = [UIColor whiteColor];
    [_picker selectRow:5 inComponent:1 animated:NO];
    _picker.dataSource = self;
    _picker.delegate = self;
    [self addSubview:_picker];
}

- (void)buttonAction:(UIButton *)sender {

    NSDictionary *dic;
    if (sender.tag == 0) {
        dic = @{@"btnTag":@"0"};
    } else {
        dic = @{@"btnTag":@"1"};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"daysPicker" object:nil userInfo:dic];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _arr.count;
    } else {
        return _arrState.count;
    }
}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _arr[row];
    } else {
        return _arrState[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    

}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
