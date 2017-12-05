//
//  CalendarView.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/5/12.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
typedef void (^SelectBlock)(NSString *selectStr);

@interface CalendarView : UIView<FSCalendarDataSource,FSCalendarDelegate>

@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,strong)SelectBlock selectBlock;
@property (weak, nonatomic) FSCalendar *calendar;
@end
