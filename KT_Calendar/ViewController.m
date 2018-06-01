//
//  ViewController.m
//  KT_Calendar
//
//  Created by Ki on 2018/5/9.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CalendarViewDelegate>
@property (nonatomic,strong)CalendarView * calendarV;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.calendarV];
}

-(CalendarView *)calendarV{
    if (!_calendarV) {
        CalendarView * calendarView = [[CalendarView alloc] init];
        calendarView.frame = CGRectMake(0, 50, ScreenW, 300);
        calendarView.delegate = self;
        _calendarV = calendarView;
    }
    return _calendarV;
}

#pragma mark - <CalendarViewDelegate>
-(void)calendarDidSelectWithTime:(NSString *)yearMonthStr{
    NSLog(@"选中~%@",yearMonthStr);
}


@end
