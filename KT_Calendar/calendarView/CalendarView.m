//
//  CalendarView.m
//  SpeakHi
//
//  Created by Ki on 2017/12/8.
//  Copyright © 2017年 Ki. All rights reserved.
//

#import "CalendarView.h"
#import "DayCell.h"
#import "WeekCell.h"

@interface CalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIView * calendar_BaseV;//左边日历View
@property (nonatomic,strong)UIView * date_BaseV;//右边选中日期 view
//右侧 头部
@property (nonatomic,strong)UIView * dateHead_BV;
@property (nonatomic,strong)UIButton * lastMonthBtn;//上个月的点击的按钮
@property (nonatomic,strong)UIButton * nextMonthBtn;//下个月的点击的按钮
@property (nonatomic,strong)UILabel * dateLabel;//显示当天的时间
@property (nonatomic,strong)UIImageView * todayImgView ;

//右侧 下部
@property (nonatomic,strong)UILabel * selectDateLab;
@property (nonatomic,strong)UILabel * selectWeekLab;

@property (nonatomic,strong)NSArray * weekArr;

@property (nonatomic,copy)NSString * ymdString;//今天年月日
@property (nonatomic,copy)NSString * selectDayString;//当前日期


@end

@implementation CalendarView{
    UICollectionView *dateCollection;//显示日历的所有时间
    NSDate * nowDate;
    NSDate * calendarDate;
    NSString * dateCellIdentifier;
    NSString * calendarCellIdentifier;
    NSString * dateStr;
}

#pragma mark -  系统方法
- (instancetype)initWithFrame:(CGRect)frame{//w:860 645 215 h:380
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

        nowDate = [NSDate date];
        calendarDate = [NSDate date];
        dateCellIdentifier = @"dateIdentifier";
        calendarCellIdentifier = @"calendarIdentifier";
        
        self.selectDateLab.text = self.selectDayString;
        
        [self addSubview:self.calendar_BaseV];
        [self addSubview:self.date_BaseV];
        
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _calendar_BaseV.frame = CGRectMake(0, 0, 0.75 * CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
    
    _date_BaseV.frame = CGRectMake( 0.75 * CGRectGetWidth(self.frame), 0,  0.25 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    _dateHead_BV.frame = CGRectMake(0, -1, CGRectGetWidth(_date_BaseV.frame), CGRectGetHeight(_calendar_BaseV.frame) / 7);
    CGFloat lrBtnHeight = 15;
    CGFloat yPoint = (CGRectGetHeight(_calendar_BaseV.frame) / 7 - lrBtnHeight)/2;
    _lastMonthBtn.frame = CGRectMake(2,   yPoint,  12,lrBtnHeight);
    _nextMonthBtn.frame = CGRectMake(CGRectGetWidth(_date_BaseV.frame) - 14,yPoint, 12,lrBtnHeight);
    _dateLabel.frame = CGRectMake(CGRectGetMaxX(_lastMonthBtn.frame)+2,yPoint, CGRectGetWidth(_date_BaseV.frame) - 32, lrBtnHeight);
    _todayImgView.frame = CGRectMake(10, 50,  CGRectGetWidth(_date_BaseV.frame) - 20, 120);
    _selectDateLab.frame = CGRectMake(10, 15, CGRectGetWidth(_todayImgView.frame) - 20, 60);
    _selectWeekLab.frame = CGRectMake(10, 80,36, 14);
    
    dateCollection.frame = CGRectMake(0,-1,CGRectGetWidth(_calendar_BaseV.frame), CGRectGetHeight(_calendar_BaseV.frame));
}

#pragma mark - UI 懒加载
-(UIView *)calendar_BaseV{
    if (!_calendar_BaseV) {
        _calendar_BaseV = [[UIView alloc] init];
//        _calendar_BaseV.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        [flowLayOut setMinimumLineSpacing:0];
        [flowLayOut setMinimumInteritemSpacing:0];
        [flowLayOut setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayOut setItemSize:CGSizeMake(CGRectGetWidth(_calendar_BaseV.frame) / 7, CGRectGetHeight(_calendar_BaseV.frame) / 7)];
        

        dateCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_calendar_BaseV.frame), CGRectGetHeight(_calendar_BaseV.frame)) collectionViewLayout:flowLayOut];
//        dateCollection.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
        [dateCollection setBackgroundColor:[UIColor whiteColor]];
        
        dateCollection.delegate = self;
        dateCollection.dataSource = self;
        
        [dateCollection registerClass:[WeekCell class] forCellWithReuseIdentifier:dateCellIdentifier];
        [dateCollection registerClass:[DayCell class] forCellWithReuseIdentifier:calendarCellIdentifier];
        [_calendar_BaseV addSubview:dateCollection];
        
    }
    return _calendar_BaseV;
}

-(UIView *)date_BaseV{
    if (!_date_BaseV) {
        _date_BaseV = [[UIView alloc] init];
        _date_BaseV.backgroundColor = [UIColor orangeColor];
        
        [_date_BaseV addSubview:self.dateHead_BV];//上个月，下个月按钮和日期label
        [_date_BaseV addSubview:self.todayImgView];
    }
    return _date_BaseV;
}

-(UIView *)dateHead_BV{//头部view
    if (!_dateHead_BV) {
        _dateHead_BV = [[UIView alloc] init];
//        _dateHead_BV.backgroundColor = [UIColor colorWithHexString:@"149EFF"];
        
        [_dateHead_BV addSubview:self.dateLabel];
        [_dateHead_BV addSubview:self.lastMonthBtn];
        [_dateHead_BV addSubview:self.nextMonthBtn];
    }
    return _dateHead_BV;
}

-(UIImageView *)todayImgView{
    if (!_todayImgView) {
        _todayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_bg"]];
        
//        _todayImgView.layer.shadowColor = [UIColor colorWithHexString:@"149EFF"].CGColor;
        _todayImgView.layer.shadowOffset = CGSizeMake(0, 0);
        _todayImgView.layer.shadowOpacity = 0.2;
        
        UILabel * selectDateLab = [[UILabel alloc] init];
        selectDateLab.textAlignment = NSTextAlignmentCenter;
        selectDateLab.font = [UIFont boldSystemFontOfSize:30];
        selectDateLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
        selectDateLab.text = [NSString stringWithFormat:@"%ld",[self dayWithDate:calendarDate]];
        selectDateLab.text = self.selectDayString;
        selectDateLab.backgroundColor = [UIColor magentaColor];
        selectDateLab.textColor = [UIColor purpleColor];
        [_todayImgView addSubview:selectDateLab];
        _selectDateLab = selectDateLab;
        
        UILabel * weekLab = [[UILabel alloc] init];
        weekLab.textAlignment = NSTextAlignmentCenter;
        weekLab.font = [UIFont boldSystemFontOfSize:13];
        weekLab.font = [UIFont fontWithName:@"PingFang SC" size:13];
        weekLab.text = [NSString stringWithFormat:@"%@",[self weekWithToday]];
        weekLab.textColor = [UIColor cyanColor];
        weekLab.backgroundColor = UIColor.grayColor;
        [_todayImgView addSubview:weekLab];
        _selectWeekLab = weekLab;

    }
    return _todayImgView;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        //_dateLabel.backgroundColor = [UIColor orangeColor];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self yearWithDate:calendarDate],[self monthWithDate:calendarDate]]];
    }
    return _dateLabel;
}

-(UIButton *)lastMonthBtn{
    if (!_lastMonthBtn) {
        
        _lastMonthBtn = [[UIButton alloc] init];
//        _lastMonthBtn.backgroundColor = [UIColor yellowColor];
        [_lastMonthBtn setImage:[UIImage imageNamed:@"LastMonth"] forState:UIControlStateNormal];
        [_lastMonthBtn addTarget:self action:@selector(pressLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastMonthBtn;
}

-(UIButton *)nextMonthBtn{
    if (!_nextMonthBtn) {
        _nextMonthBtn = [[UIButton alloc] init];
//        _nextMonthBtn.backgroundColor = [UIColor yellowColor];
        [_nextMonthBtn setImage:[UIImage imageNamed:@"NextMonth"] forState:UIControlStateNormal];
        [_nextMonthBtn addTarget:self action:@selector(pressNextMonth:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextMonthBtn;
}

-(NSArray *)weekArr{
    if (!_weekArr) {
        _weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _weekArr;
}

#pragma mark - Noti-
- (void)orientChange:(NSNotification *)noti{
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    self.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300);
    [self layoutSubviews];
    [dateCollection reloadData];
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */
    switch (orient){
        case UIDeviceOrientationPortrait:
            NSLog(@"Home键在下");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"Home键在上");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"Home键在左");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"Home键在右");
            break;
            
        default:
            break;
    }
}

#pragma mark ---------------------------Action-----------------------
- (void)pressLastMonth:(UIButton *)sender{
    calendarDate = [self lastMonthWithDate:calendarDate];
    NSInteger yearInt = [self yearWithDate:calendarDate];
    NSInteger monthInt = [self monthWithDate:calendarDate];
    
    [_dateLabel setText:[NSString stringWithFormat:@"%ld年%ld月",yearInt,monthInt]];
    [dateCollection reloadData];
}

- (void)pressNextMonth:(UIButton *)sender{
    calendarDate = [self nextMonthWithDate:calendarDate];
    NSInteger yearInt = [self yearWithDate:calendarDate];
    NSInteger monthInt = [self monthWithDate:calendarDate];
    
    [_dateLabel setText:[NSString stringWithFormat:@"%ld年%ld月",yearInt,monthInt]];
   [dateCollection reloadData];
}

#pragma mark ---------------------------collectionDelegate-----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.weekArr.count;
    }else{
        return 42;// 6 行* 7 列
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        WeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateCellIdentifier forIndexPath:indexPath];
        [cell.dateLbl setText:self.weekArr[indexPath.row]];
        return cell;
    }else{
        DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:calendarCellIdentifier forIndexPath:indexPath];
        NSInteger daysInThisMonth = [self totalDaysInThisMonthWithDate:calendarDate];
        NSInteger firstWeekDay = [self firstWeekDayInThisMonthWithDate:calendarDate];
        NSInteger day = 0;
        
        NSInteger i = indexPath.row;
        if (i < firstWeekDay) {
            //上个月的最后几天
            cell.dateLbl.hidden = YES;
        }else if (i > firstWeekDay + daysInThisMonth - 1){
            //下个月的头几天
         cell.dateLbl.hidden = YES;
        }else{
            cell.dateLbl.hidden = NO;
            //这个月天数
            day = i - firstWeekDay + 1;
            cell.dateLbl.text = [NSString stringWithFormat:@"%ld",day];
            
            //给cell绑定标识符 格式：20171205
            NSInteger monthIntger = [self monthWithDate:calendarDate];
            NSString * month = (monthIntger<10)?[NSString stringWithFormat:@"0%ld",monthIntger]:[NSString stringWithFormat:@"%ld",(long)monthIntger];
            NSString * dayStr = cell.dateLbl.text;
            NSString * day = ([dayStr integerValue] < 10)?[NSString stringWithFormat:@"0%@",dayStr]:dayStr;
            cell.dateIdentifier = [NSString stringWithFormat:@"%ld%@%@",[self yearWithDate:calendarDate],month,day];
            
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)return;
    DayCell * cell = (DayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString * dayStr = cell.dateLbl.text;
    NSString * day = ([dayStr integerValue] < 10)?[NSString stringWithFormat:@"0%@",dayStr]:dayStr;
    
    NSInteger monthIntger = [self monthWithDate:calendarDate];
    NSString * month = (monthIntger<10)?[NSString stringWithFormat:@"0%ld",monthIntger]:[NSString stringWithFormat:@"%ld",(long)monthIntger];
   //选择的 年月日
    dateStr = [NSString stringWithFormat:@"%ld-%@-%@",[self yearWithDate:calendarDate],month,day];
   
    //右侧 显示选中的 日期&周几
    NSArray * dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.selectDateLab.text = [dateArr lastObject];
    self.selectDayString = self.selectDateLab.text;
    self.selectWeekLab.text = [self getWeekDay:dateStr];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        DayCell * dayCell = (DayCell *)cell;
        NSLog(@"kt-##:%@:%@",dayCell.dateLbl.text,self.selectDayString);
        if ([dayCell.dateLbl.text isEqualToString:self.selectDayString]) {
            NSLog(@"kt-#Success#:%@:%@",dayCell.dateLbl.text,self.selectDayString);
            [dateCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            dayCell.selected = YES;
            //[dayCell setSelected:YES];
        }else{
            dayCell.selected = NO;
            [dateCollection deselectItemAtIndexPath:indexPath animated:YES];
        }
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(_calendar_BaseV.frame) / 7, CGRectGetHeight(_calendar_BaseV.frame) / 7);
}

#pragma mark ---------------------------dateCalculate-----------------------
//计算日期是几号
- (NSInteger)dayWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.day;
}

//计算日期是几月
- (NSInteger)monthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.month;
}

//计算日期是哪年
- (NSInteger)yearWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.year;
}

//今天是周几
- (NSString *)weekWithToday{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday] - 1;
    
    switch (week) {
        case 0:
            return @"周日";
            break;
        case 1:
            return @"周一";
            break;
        case 2:
            return @"周二";
            break;
        case 3:
            return @"周三";
            break;
        case 4:
            return @"周四";
            break;
        case 5:
            return @"周五";
            break;
        case 6:
            return @"周六";
            break;
        case 7:
            return @"周日";
            break;
            
        default:
            break;
    }
    
    return nil;
}

//计算每个月1号对应周几
- (NSInteger)firstWeekDayInThisMonthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    calendar.firstWeekday = 1;
    component.day = 1;
    
    NSDate *firstDate = [calendar dateFromComponents:component];
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate] - 1;
}

//计算当前月份天数
- (NSInteger)totalDaysInThisMonthWithDate:(NSDate *)date{
    return [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//计算指定月天数
- (NSInteger)getDaysInMonthWithYearAndMonth:(NSInteger)year month:(NSInteger)month{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString *monthStr = @"";
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%@",year,monthStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //NSCalendarIdentifierGregorian公历日历的意思
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//上一个月
- (NSDate *)lastMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = -1;
    /*
     NSCalendarWrapComponents
     Specifies that the components specified for an NSDateComponents object should be incremented and wrap around to zero/one on overflow, but should not cause higher units to be incremented.
     指定为NSDateComponents对象指定的组件应该递增，并在溢出时循环为零/ 1，但不应导致更高的单位增加。
     NSCalendarMatchStrictly
     Specifies that the operation should travel as far forward or backward as necessary looking for a match.
     指定操作应该根据需要前进或后退，寻找匹配。
     NSCalendarSearchBackwards
     Specifies that the operation should travel backwards to find the previous match before the given date.
     指定操作向后移动以在给定日期之前找到先前的匹配。
     NSCalendarMatchPreviousTimePreservingSmallerUnits
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the previous existing value of the missing unit and preserves the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺失单元的先前存在的值，并保留较低单位的值。
     NSCalendarMatchNextTimePreservingSmallerUnits
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and preserves the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值并保留较低单位的值。
     NSCalendarMatchNextTime
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and does not preserve the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值，并且不保留较低单位的值。
     NSCalendarMatchFirst
     Specifies that, if there are two or more matching times, the operation should return the first occurrence.
     指定如果有两个或更多匹配的时间，操作应该返回第一个出现的。
     NSCalendarMatchLast
     Specifies that, if there are two or more matching times, the operation should return the last occurrence.
     指定如果有两个或更多匹配的时间，则操作应返回最后一次出现的。
     */
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}

//下一个月
- (NSDate *)nextMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = +1;
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}

#pragma mark - 时间戳转换成时间
- (NSString *)dateFromTimeStamp:(NSString *)stampStr{
    
    NSTimeInterval time = [stampStr doubleValue] +28800;//因为时差问题要加8小时 == 28800 sec
    NSDate * detaildate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

#pragma mark  - 年月日 转换为 周几
- (NSString*)getWeekDay:(NSString*)currentStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate*date =[dateFormat dateFromString:currentStr];
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    NSCalendar* calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    NSDateComponents* theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}







@end
