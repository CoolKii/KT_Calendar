//


#import <UIKit/UIKit.h>

@protocol CalendarViewDelegate <NSObject>
@optional
- (void)calendarDidSelectWithTime:(NSString *)yearMonthStr;
@end


@interface CalendarView : UIView

@property (nonatomic,weak)id <CalendarViewDelegate>delegate;

@end




