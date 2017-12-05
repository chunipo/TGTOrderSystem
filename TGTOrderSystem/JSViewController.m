//
//  JSViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/23.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "JSViewController.h"
#import "DrawView.h"

@interface JSViewController ()
{
    DrawView *_drawView;
}
@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [navView initWithTitleName:@"确认结算"];
    [self.view addSubview:navView];
    
    [self _initView];
}

- (void)_initView {
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    if ([_devNumber hasPrefix:@"TGT0"]) {
        
        _leftArr = @[@"发货仓库",@"预计发货时间",@"预计归还时间",@"套餐类型",
                     @"出行国家",@"套餐开始时间",@"套餐结束时间",@"已收取套餐金额",
                     @"已收押金金额",@"押金消费",@"延迟归还扣费",@"设备损坏扣费",
                     @"其他费用扣费",@"扣费合计",@"押金退款金额",@"结算备注",@"签字确认"];
        _rightArr = @[@"日本羽田机场",@"2016-05-20 00:00",@"2016-05-31 00:00",@"无限量10天",
                      @"中国大陆",@"2016-05-20 00:00",@"2016-05-30 00:00",@"400",
                      @"0",@"",@"",@"",
                      @"",@"0",@"0",@"",@""];
    } else {
        _leftArr = @[@"编号",@"设备号",@"预计发货时间",@"预计归还时间",
                     @"已收押金金额",@"套餐",@"金额",@"开始时间",
                     @"结束时间",@"取消费用",@"延期未使用费用",@"设备损坏扣费",
                     @"延单费用",@"结算备注",@"签字确认"];
        _rightArr = @[@"16042000617",_devNumber,@"2016-05-20",@"2016-05-31",@"0.01元",@"中国日租",@"550.00元",@"2016-05-20",@"2016-05-31",@"",@"",@"",@"0.00",@"",@""];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _leftArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_devNumber hasPrefix:@"TGT0"]) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, cell.height)];
        leftLab.font = [UIFont systemFontOfSize:18];
        leftLab.textAlignment = NSTextAlignmentRight;
        leftLab.text = _leftArr[indexPath.row];
        [cell.contentView addSubview:leftLab];
        
        // 10 11 12
        if (indexPath.row == 10) {
            _ycghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_ycghTfView setTextFieldPlaceholder:@"延迟归还扣费"];
            [cell.contentView addSubview: _ycghTfView];
        } else if (indexPath.row == 11) {
            _shkfTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_shkfTfView setTextFieldPlaceholder:@"设备损坏扣费"];
            [cell.contentView addSubview: _shkfTfView];
        } else if (indexPath.row == 12) {
            _qtfyTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_qtfyTfView setTextFieldPlaceholder:@"其他费用扣费"];
            [cell.contentView addSubview: _qtfyTfView];
        } else if(indexPath.row == _leftArr.count - 2) {
            leftLab.height = 100;
            _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(210, 10, KScreenWidth - 210 - 10 - 150, 80)];
            _myTextView.layer.cornerRadius = 10;
            _myTextView.layer.masksToBounds = YES;
            _myTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _myTextView.layer.borderWidth = 1;
            [cell.contentView addSubview: _myTextView];
        } else if(indexPath.row == _leftArr.count - 1) {
            leftLab.height = 100;
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 5, 120, 90)];
            _imgView.backgroundColor = TITLE_COLOR;
            [cell.contentView addSubview:_imgView];
            
        } else {
        
            UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(210, 0,KScreenWidth - 210-10, cell.height)];
            rightLab.font = [UIFont systemFontOfSize:17];
            rightLab.textColor = [UIColor darkGrayColor];
            rightLab.text = _rightArr[indexPath.row];
            [cell.contentView addSubview:rightLab];
        }
        return cell;
        
    } else {
    
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, cell.height)];
        leftLab.font = [UIFont systemFontOfSize:18];
        leftLab.textAlignment = NSTextAlignmentRight;
        leftLab.text = _leftArr[indexPath.row];
        [cell.contentView addSubview:leftLab];
        
        // 10 11 12
        if (indexPath.row == 10) {
            _ycghTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_ycghTfView setTextFieldPlaceholder:@"延迟归还扣费"];
            [cell.contentView addSubview: _ycghTfView];
        } else if (indexPath.row == 11) {
            _shkfTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_shkfTfView setTextFieldPlaceholder:@"设备损坏扣费"];
            [cell.contentView addSubview: _shkfTfView];
        } else if (indexPath.row == 9) {
            _qtfyTfView = [[TextFieldView alloc] initWithFrame:CGRectMake(210, 5,KScreenWidth - 210-10 - 200, cell.height - 10)];
            [_qtfyTfView setTextFieldPlaceholder:@"取消费用"];
            [cell.contentView addSubview: _qtfyTfView];
        } else if(indexPath.row == _leftArr.count - 2) {
            leftLab.height = 100;
            _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(210, 10, KScreenWidth - 210 - 10 - 150, 80)];
            _myTextView.layer.cornerRadius = 10;
            _myTextView.layer.masksToBounds = YES;
            _myTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _myTextView.layer.borderWidth = 1;
            [cell.contentView addSubview: _myTextView];
        } else if(indexPath.row == _leftArr.count - 1) {
            leftLab.height = 100;
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 5, 120, 90)];
            _imgView.backgroundColor = TITLE_COLOR;
            [cell.contentView addSubview:_imgView];
            
        } else {
            
            UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(210, 0,KScreenWidth - 210-10, cell.height)];
            rightLab.font = [UIFont systemFontOfSize:17];
            rightLab.textColor = [UIColor darkGrayColor];
            rightLab.text = _rightArr[indexPath.row];
            [cell.contentView addSubview:rightLab];
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == _leftArr.count - 1 || indexPath.row == _leftArr.count - 2) {
        return 100.0f;
    } else {
        return 44;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
     
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
        bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, 50, KScreenWidth - 100, 45);
        button.backgroundColor = TITLE_COLOR;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:@"确认结算" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        return bgView;
    } else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == _leftArr.count - 1) {
        
        _imgBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _imgBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
        [self.view addSubview:_imgBgView];
        
        _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight - 400)];
        _drawView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _drawView.pathColor = [UIColor blackColor];
        _drawView.lineWidth = 5;
        [_imgBgView addSubview:_drawView];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(KScreenWidth - 80 *2, 20, 50, 30);
        clearButton.backgroundColor = [UIColor orangeColor];
        [clearButton setTitle:@"清除" forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [clearButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawView addSubview:clearButton];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(KScreenWidth - 80 * 3, 20, 50, 30);
        saveBtn.backgroundColor = [UIColor orangeColor];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawView addSubview:saveBtn];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(KScreenWidth - 80, 20, 50, 30);
        closeBtn.backgroundColor = [UIColor orangeColor];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawView addSubview:closeBtn];
    }
}

- (void)btnAction:(UIButton *)sender {
    
    [_drawView clear];
}
- (void)saveAction:(UIButton *)sender {
    
    [self save];
    [_drawView removeFromSuperview];
    [_imgBgView removeFromSuperview];
}
- (void)closeAction:(UIButton *)sender {
    
    [_drawView removeFromSuperview];
    [_imgBgView removeFromSuperview];
}

- (void)save {
    
    NSArray *arr = [_drawView subviews];
    for (UIView *view in arr) {
        [view removeFromSuperview];
    }
    [UIView animateWithDuration:0.15 animations:^{
        
        //保存当前画板上的内容
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
        //获取位图上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //把控件上的图层渲染到上下文
        [_drawView.layer renderInContext:ctx];
        //获取上下文中的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        _imgView.image = image;
        
    } completion:^(BOOL finished) {
       [_drawView clear];
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"保存成功");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate: nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)buttonAction:(UIButton *)sender {
    
    NSLog(@"确认结算");
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}


- (void)didReceiveMemoryWarning {

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
