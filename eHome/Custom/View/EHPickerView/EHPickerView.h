//
//  EHPickerView.h
//  9.23-test-timeSelector
//
//  Created by xtq on 15/9/23.
//  Copyright © 2015年 one. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHPickerViewCell.h"
#import "NSString+StringSize.h"

@protocol EHPickerViewDataSource, EHPickerViewDelegate;

@interface EHPickerView : UIView


@property(nullable,nonatomic,weak) id<EHPickerViewDataSource> dataSource;

@property(nullable,nonatomic,weak) id<EHPickerViewDelegate>   delegate;

@property (nonatomic,assign)           CGFloat                rowHeight;            //default:44

@property (nonatomic, assign)          CGFloat                titleSize;            //default:EH_siz1

@property (nullable,nonatomic, strong) UIColor                *titleColor;          //default:EHCor4

@property (nonatomic, assign)          CGFloat                selectedTitleSize;    //default:21

@property (nullable, nonatomic, strong)UIColor                *selectedTitleColor;  //default:EHCor6

@property (nonatomic, assign)          CGFloat                unitTitleSize;        //default:EH_siz2

@property (nullable, nonatomic, strong)UIColor                *unitTitleColor;      //default:EHCor6

@property (nonatomic, assign)          NSInteger              displayedRowsNumber;  //default:3.

- (void)reloadData;     //重载。同时EHPickerView的高度会根据设定的rowHeight乘以displayedRowsNumber显示的行数，再加上底部留白进行重设定

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end





#pragma mark - EHPickerViewDataSource
@protocol EHPickerViewDataSource<NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(nonnull EHPickerView *)pickerView;

- (NSInteger)pickerView:(nonnull EHPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

#pragma mark - EHPickerViewDelegate
@protocol EHPickerViewDelegate<NSObject>
@optional

- (void)pickerView:(nonnull EHPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (CGFloat)pickerView:(nonnull EHPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (nullable NSString *)pickerView:(nonnull EHPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (nullable NSString *)pickerView:(nonnull EHPickerView *)pickerView unitTitleForComponent:(NSInteger)component;

@end