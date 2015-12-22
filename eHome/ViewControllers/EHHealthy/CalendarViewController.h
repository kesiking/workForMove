//
//  BasicViewController.h
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"

typedef void (^ReturnSelectedDateBlock)(NSString *showSelectedDate);

@interface CalendarViewController : KSViewController<JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarMenuViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (nonatomic, copy) ReturnSelectedDateBlock returnSelectedDateBlock;

@property(strong,nonatomic)NSDate* babyStartDate;

@property(strong,nonatomic)NSDate*  selectedDate;

- (void)returnDateText:(ReturnSelectedDateBlock)block;

@end
