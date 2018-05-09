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

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalendarView * calendarV = [[CalendarView alloc] init];
    calendarV.frame = CGRectMake(0, 50, ScreenW, 300);
    [self.view addSubview:calendarV];
    
  
    
}





@end
