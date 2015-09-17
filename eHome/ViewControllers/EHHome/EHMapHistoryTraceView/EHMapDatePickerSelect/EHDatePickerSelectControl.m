//
//  EHDatePickerSelectControl.m
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHDatePickerSelectControl.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "EHGetBabyDeviceStartUserService.h"
#import "JTCalendar.h"
#import "CalendarViewController.h"

@interface EHDatePickerSelectControl(){
    RMDateSelectionViewController       *_dateSelectionController;
}

@property (nonatomic, strong) RMDateSelectionViewController*    dateSelectionController;

@property (nonatomic, strong) EHGetBabyDeviceStartUserService*  getBabyDeviceStartUserService;

@property(strong,nonatomic)UIView* calendarView;
@property(strong,nonatomic)UIView* bgView;
@property(strong,nonatomic)CalendarViewController *calendarVC;



@end

@implementation EHDatePickerSelectControl


-(void)setupView{
    [super setupView];
    if ([[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay == nil) {
        [self.getBabyDeviceStartUserService getBabyDeviceStartUserDayWithBabyId:[[EHBabyListDataCenter sharedCenter] currentBabyId]];
    }
}

- (void)showDatePickerSelectView
{
    [self showDatePickerSelectViewWithDate:[NSDate date]];
}

-(void)showDatePickerSelectViewWithDate:(NSDate*)date{
    
    [self showDatePickerSelectViewWithDate:date andTitle:@"确定"];
}
-(void)showDatePickerSelectViewWithDate:(NSDate*)date andTitle:(NSString *)selectTitle{
    
    if (date == nil) {
        date = [NSDate date];
    }
    if (selectTitle==nil) {
        selectTitle=@"确定";
    }
    UIViewController* popViewController = self.popViewController ? : self.viewController;
    
 
    if (!_calendarVC) {
        _calendarVC = [CalendarViewController new];
    }
       _calendarVC.babyStartDate = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay;
    
    
  
    WEAKSELF
    [_calendarVC returnDateText:^(NSString *showSelectedDate){
        STRONGSELF
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *sdate=[format dateFromString:showSelectedDate];
        
        if (strongSelf.datePickerSelectControlBlock) {
            strongSelf.datePickerSelectControlBlock(strongSelf, sdate);
            [_bgView removeFromSuperview];
            [_calendarView removeFromSuperview];
        }

        
    }];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];

    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    }
    
    _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
    if (!_calendarView) {
        _calendarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,window.bounds.size.width, 374.5*SCREEN_SCALE+16.5*SCREEN_SCALE)];
    }
   
    _calendarView.backgroundColor = [UIColor whiteColor];
    [_calendarVC.view setFrame:CGRectMake(0, 0, popViewController.view.width, 374.5*SCREEN_SCALE)];
    UIView *canldara = _calendarVC.view;
  
    [self.calendarView addSubview:canldara];
    
    
    _calendarView.alpha = 0;
    [popViewController.view addSubview:_bgView];
    [popViewController.view addSubview:_calendarView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(atap)];
    [_bgView addGestureRecognizer:tap];
    
    CGRect rect = self.calendarView.frame;
    rect.origin.y = 0;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [self.calendarView setFrame:rect];
        self.calendarView.alpha = (NSUInteger)(1);
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        
    } completion:nil];
    
}





- (void)atap{
    [self ahide];
}

- (void)ahide{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];
        _calendarView.layer.transform = CATransform3DMakeTranslation(0, -CGRectGetHeight(_calendarView.frame), 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_calendarView removeFromSuperview];
        //        _bgView = nil;
        //        _calendarView = nil;
    }];
}


-(EHGetBabyDeviceStartUserService *)getBabyDeviceStartUserService{
    if (_getBabyDeviceStartUserService == nil) {
        _getBabyDeviceStartUserService = [EHGetBabyDeviceStartUserService new];
        WEAKSELF
        _getBabyDeviceStartUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service.objectValue && [service.objectValue isKindOfClass:[NSString class]]) {
                NSDateFormatter* inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate* inputDate = [inputFormatter dateFromString:service.objectValue];
                if (inputDate) {
                    [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo].babyDeviceStartUserDay = inputDate;
                    strongSelf.dateSelectionController.datePicker.minimumDate = inputDate;
                }
            }
        };
    }
    return _getBabyDeviceStartUserService;
}

-(void)dealloc{
    if (_dateSelectionController) {
        [_dateSelectionController dismissActionController];
    }
}

@end
