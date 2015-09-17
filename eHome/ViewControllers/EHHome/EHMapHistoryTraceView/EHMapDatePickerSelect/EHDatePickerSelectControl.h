//
//  EHDatePickerSelectControl.h
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"

@class EHDatePickerSelectControl;

typedef void(^datePickerSelectControlBlock) (EHDatePickerSelectControl* datePickerSelectControl, NSDate* date);

typedef void(^datePickerCancelBlock) (void);

@interface EHDatePickerSelectControl : KSView

- (void)showDatePickerSelectView;

- (void)showDatePickerSelectViewWithDate:(NSDate*)date;

- (void)showDatePickerSelectViewWithDate:(NSDate*)date andTitle:(NSString *)selectTitle;

@property (nonatomic, strong) UIViewController            *popViewController;

@property (nonatomic, copy)   datePickerSelectControlBlock datePickerSelectControlBlock;


@property (nonatomic, copy)   datePickerCancelBlock        datePickerCancelBlock;

@end
