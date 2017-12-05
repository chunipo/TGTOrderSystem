//
//  CalendarView.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/12.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView

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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 100-33, 135, 50, 50)];
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

    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(100, 150, KScreenWidth - 200, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self addSubview:calendar];
    self.calendar = calendar;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(15, 10, 90, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    [previousButton setTitleColor:calendar.appearance.headerTitleColor forState:UIControlStateNormal];
    [previousButton setTitle:@"上一月" forState:UIControlStateNormal];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calendar addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(calendar.frame)-90-25,10, 90, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    [nextButton setTitleColor:calendar.appearance.headerTitleColor forState:UIControlStateNormal];
    [nextButton setTitle:@"下一月" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calendar addSubview:nextButton];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(100, calendar.bottom, KScreenWidth - 200, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(10,10, bottomView.width - 20, 40);
    sureButton.backgroundColor = TITLE_COLOR;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureButton addTarget:self action:@selector(sureClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureButton];
}

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}
- (void)sureClicked:(id)sender {

    NSString *currentStr = [self.calendar stringFromDate:[NSDate date]];
    NSString *selectStr = _dateStr;
    if (selectStr == nil) {
        NSString *msg = [NSString stringWithFormat:@"请选择归还日期"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    int i = [self compareDate:currentStr withDate:selectStr];
//    if (i == -1) {
//        NSString *msg = [NSString stringWithFormat:@"选择日期：%@\n早于\n当前日期：%@",selectStr,currentStr];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择正确的日期" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if (i == 0) {
        NSString *msg = [NSString stringWithFormat:@"当前日期：%@\n选择日期：%@",currentStr,selectStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你选择了今天" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    self.selectBlock(selectStr);
    [self removeFromSuperview];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    _dateStr = [calendar stringFromDate:date];
}
- (int)compareDate:(NSString*)currentDate withDate:(NSString*)selectDate {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:currentDate];
    dt2 = [df dateFromString:selectDate];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

@end
