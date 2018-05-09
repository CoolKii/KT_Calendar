//
//  WeekCell.m
//  SpeakHi
//
//  Created by Ki on 2017/12/8.
//  Copyright © 2017年 Ki. All rights reserved.
//

#import "WeekCell.h"

@implementation WeekCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellUI];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor colorWithHexString:@"149EFF"].CGColor;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _dateLbl.frame = self.bounds;
}

- (void)createCellUI{
    UILabel * weekLab = [[UILabel alloc] init];
    weekLab.textColor = [UIColor whiteColor];
    [weekLab setTextAlignment:NSTextAlignmentCenter];
//    [_dateLbl setBackgroundColor:[UIColor colorWithHexString:@"149EFF"]];
    weekLab.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:weekLab];
    _dateLbl = weekLab;
    
    UIView * rightLineV = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 1, self.frame.size.height)];
//    rightLineV.backgroundColor = [UIColor colorWithHexString:@"149EFF"];
    
    [self.contentView addSubview:rightLineV];
}


@end
