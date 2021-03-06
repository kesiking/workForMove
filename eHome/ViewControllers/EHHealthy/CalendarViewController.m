//
//  BasicViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "CalendarViewController.h"
#import "UIMacro.h"




@interface CalendarViewController (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_beginDate;
    NSDate *_maxDate;
    NSDate *_endDate;
    NSDate *_dateSelected;
}

@end

@implementation CalendarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"Basic";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topSpace.constant = 20.5*SCREEN_SCALE;
    self.calendarContentViewHeight.constant = 306*SCREEN_SCALE;
    self.calendarMenuViewHeight.constant = 48*SCREEN_SCALE;
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
//    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    if (_selectedDate!=nil) {
        [_calendarManager setDate:_selectedDate];
    }else
    {
         [_calendarManager setDate:_todayDate];
    }
    [_calendarManager reload];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self createMinAndMaxDate];
    NSDateFormatter *formater1=[[NSDateFormatter alloc]init];
    formater1.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    if (_selectedDate!=nil) {
        NSLog(@"%@",_selectedDate); //结果：2015-07-16 15:25:28
        [_calendarManager setDate:_selectedDate];
        _dateSelected = _selectedDate;
    }
    [_calendarManager reload];
   
}

- (void)returnDateText:(ReturnSelectedDateBlock)block {
    self.returnSelectedDateBlock = block;
}

#pragma mark - Buttons callback

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.textLabel.font = [UIFont systemFontOfSize:EHSiz2];
    // Today
    if([_calendarManager.dateHelper date:_todayDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // 注释掉了以后就不单独设置selected的样式了
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = EHCor6;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = EH_cor12;
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = EH_cor10;
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *displayDateString=[dateFormatter stringFromDate:dayView.date];
 
    if (self.returnSelectedDateBlock != nil) {
        self.returnSelectedDateBlock(displayDateString);
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_beginDate andEqualOrBefore:_endDate];

}

//重新写一个setDate的区间判断


- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
//        NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
//        NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
//    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    //开始佩戴手表
    _minDate = self.babyStartDate;
    // Max date will be 2 month after today
    //当前
    _maxDate = _todayDate;
   
    double ainterval = 0;
    NSDate *abeginDate = nil;
    NSDate *aendDate = nil;
    NSCalendar *nsCalendar = [NSCalendar currentCalendar];
    [nsCalendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [nsCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&abeginDate interval:&ainterval forDate:_maxDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        aendDate = [abeginDate dateByAddingTimeInterval:ainterval-1];
    }else {
        
    }
    _endDate = aendDate;
    
    ainterval = 0;
    abeginDate = nil;
    aendDate = nil;
    ok = [nsCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&abeginDate interval:&ainterval forDate:_minDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        aendDate = [abeginDate dateByAddingTimeInterval:ainterval-1];
    }else {
        
    }
    _beginDate = abeginDate;


}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
//    _eventsByDate = [NSMutableDictionary new];
//    
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//        
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//        
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//        
//        [_eventsByDate[key] addObject:randomDate];
//    }
}

@end
