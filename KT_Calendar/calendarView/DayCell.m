//
//  DayCell.m
//  SpeakHi
//
//  Created by Ki on 2017/12/8.
//  Copyright © 2017年 Ki. All rights reserved.
//

#import "DayCell.h"

@interface DayCell ()

@property (nonatomic,strong)UILabel * jtLabel;
@property (nonatomic,weak)CALayer * rLineLayer;
@property (nonatomic,weak)CALayer * bLineLayer;
@end

@implementation DayCell

#pragma mark - 系统方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellUI];
    }
    return self;
}

-(void)layoutSubviews{
    _dateLbl.frame = CGRectMake(CGRectGetWidth(self.frame) - 25, 7 , 20, 20);
    _jtLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 29, 27, 24, 12);
    _rLineLayer.frame = CGRectMake(CGRectGetWidth(self.frame)-1, 0, 1, CGRectGetHeight(self.frame));
    _bLineLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
    
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected{
    self.dateLbl.textColor = selected?UIColor.orangeColor:UIColor.blackColor;
}

#pragma mark - UI
- (void)createCellUI{
    _dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _dateLbl.layer.cornerRadius = 10;
    _dateLbl.layer.masksToBounds = YES;
    [_dateLbl setFont:[UIFont fontWithName:@"PingFang TC" size:14]];
    [_dateLbl setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_dateLbl];
    
    UILabel * jtLabel = [[UILabel alloc] init];
    jtLabel.text = @"今日";
    jtLabel.hidden = YES;
//    jtLabel.textColor = [UIColor colorWithHexString:@"149EFF"];
    jtLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    [self.contentView addSubview:jtLabel];
    _jtLabel = jtLabel;
    
    CALayer * rightLine = [[CALayer alloc] init];
    rightLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:rightLine];
    _rLineLayer = rightLine;
   
    CALayer * bottomLine = [[CALayer alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    _bLineLayer = bottomLine;
    
}

#pragma mark -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.1 animations:^{
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    } completion:^(BOOL finished) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - 时间
-(NSString*)getCurrentTimeDay {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"d"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(NSString*)getCurrentTimeMonth{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"M"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(NSString*)getCurrentTimeYear{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"yyyy"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//计算日期是几号
- (NSInteger)dayWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.day;
}

@end


