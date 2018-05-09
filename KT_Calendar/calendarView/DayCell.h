//
//  DayCell.h
//  SpeakHi
//
//  Created by Ki on 2017/12/8.
//  Copyright © 2017年 Ki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCell : UICollectionViewCell

@property (nonatomic,copy)NSString * dateIdentifier;
@property(nonatomic, retain)UILabel * dateLbl;//日期

@end
