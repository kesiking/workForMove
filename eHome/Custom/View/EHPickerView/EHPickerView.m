//
//  EHPickerView.m
//  9.23-test-timeSelector
//
//  Created by xtq on 15/9/23.
//  Copyright © 2015年 one. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

#import "EHPickerView.h"

@interface EHPickerView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *tableViewArray;

@property (nonatomic, strong)NSMutableArray *titleListArray;

@property (nonatomic, strong)NSMutableArray *unitTitleLabelArray;

@property (nonatomic, strong)NSMutableArray *selectedRowArray;

@property (nonatomic, strong)NSMutableArray *rowHeightArray;



@property (nonatomic, strong)UIView *upLineView;

@property (nonatomic, strong)UIView *downLineView;

@end

@implementation EHPickerView

#pragma mark - init
- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    for (NSInteger component = 0; component < componentsNumber; component++) {
        
        CGRect frame = self.bounds;
        frame.size.width /= componentsNumber;
        frame.origin.x = frame.size.width * component;
        UITableView *tableView = self.tableViewArray[component];
        tableView.frame = frame;
        
        UILabel *unitTitleLabel = self.unitTitleLabelArray[component];
        CGFloat unitTitleLabelX = [self titleMaxXPositionOfComponent:component] + CGRectGetWidth(frame) * component;
        CGSize unitTitleLabelSize = [unitTitleLabel.text sizeWithFontSize:self.unitTitleSize Width:(CGRectGetWidth(tableView.frame) - unitTitleLabelX)];
        CGFloat unitTitleLabelY = (CGRectGetHeight(self.frame) - unitTitleLabelSize.height)/2.0;
        CGRect unitTitleLabelFrame = CGRectMake(unitTitleLabelX, unitTitleLabelY,unitTitleLabelSize.width,unitTitleLabelSize.height);
        unitTitleLabel.frame = unitTitleLabelFrame;
    }
    
    CGFloat rowHeight = [self.rowHeightArray[0] floatValue];
    CGFloat upLineViewY = rowHeight + 19;
    CGFloat downLineViewY = CGRectGetHeight(self.frame) - rowHeight - 19;
    
    self.upLineView.frame = CGRectMake(0, upLineViewY, CGRectGetWidth(self.frame), 0.5);
    self.downLineView.frame = CGRectMake(0, downLineViewY, CGRectGetWidth(self.frame), 0.5);
}


#pragma mark - Private Methods
- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    
    self.tableViewArray = [[NSMutableArray alloc]init];
    self.titleListArray = [[NSMutableArray alloc]init];
    self.unitTitleLabelArray = [[NSMutableArray alloc]init];
    self.selectedRowArray = [[NSMutableArray alloc]init];
    self.rowHeightArray = [[NSMutableArray alloc]init];
    
    self.titleSize = EH_siz1;
    self.titleColor = EHCor4;
    self.selectedTitleSize = 21;
    self.selectedTitleColor = EHCor6;
    self.unitTitleSize = EH_siz2;
    self.unitTitleColor = EHCor6;
    self.displayedRowsNumber = 3;
    self.rowHeight = 44;
    
    [self addSubview:self.upLineView];
    [self addSubview:self.downLineView];
}

- (void)reloadData {
    [self configRowHeightArray];
    
    if (self.tableViewArray.count != 0) {
        for (NSInteger i = 0; i < self.tableViewArray.count; i++) {
            UITableView *tableView = self.tableViewArray[i];
            [tableView removeFromSuperview];
            
            UILabel *unitTitleLabel = self.unitTitleLabelArray[i];
            [unitTitleLabel removeFromSuperview];

        }
        [self.tableViewArray removeAllObjects];
        [self.unitTitleLabelArray removeAllObjects];
        [self.titleListArray removeAllObjects];
        [self.selectedRowArray removeAllObjects];
        [self.rowHeightArray removeAllObjects];
    }
 
    [self configTitleListArray];
    [self configTableViewArray];
    [self configUnitTitleLabelArray];
    [self configSelectedRowArray];
    [self resetPickerViewFrame];
    
    [self bringSubviewToFront:self.upLineView];
    [self bringSubviewToFront:self.downLineView];
    
    for (NSInteger i = 0; i < self.tableViewArray.count; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self highLightTitle:YES AtRow:0 inComponent:i];
        });
    }
}


- (void)resetPickerViewFrame {
    CGFloat rowHeight = [self.rowHeightArray[0] floatValue];
    CGRect frame = self.frame;
    frame.size.height = rowHeight * self.displayedRowsNumber + [self spaceHeight];
    self.frame = frame;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    NSInteger lastSelectedRow = [self.selectedRowArray[component] integerValue];
    
    
    [self highLightTitle:NO AtRow:lastSelectedRow inComponent:component];
    self.selectedRowArray[component] = @(row);
    UITableView *tableView = self.tableViewArray[component];
    CGFloat rowHeight = [self.rowHeightArray[component] floatValue];
    [tableView setContentOffset:CGPointMake(0, rowHeight *(row)) animated:animated];
}

- (void)highLightTitle:(BOOL)needHighLight AtRow:(NSInteger)row inComponent:(NSInteger)component{
    UITableView *tableView = self.tableViewArray[component];
    EHPickerViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(row + 1) inSection:0]];
    UILabel *titleLabel = cell.titleLabel;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (needHighLight) {
            titleLabel.textColor = self.selectedTitleColor;
            titleLabel.font = [UIFont systemFontOfSize:self.selectedTitleSize];
        }
        else {
            titleLabel.textColor = self.titleColor;
            titleLabel.font = [UIFont systemFontOfSize:self.titleSize];
        }
    } completion:^(BOOL finished) {}];
}

- (CGFloat)titleMaxXPositionOfComponent:(NSInteger)component {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    
    NSArray *titleList = self.titleListArray[component];
    CGFloat maxWidth = 0;
    for (NSInteger row = 0; row < titleList.count; row++) {
        NSString *title = titleList[row];
        CGFloat width = [title sizeWithFontSize:self.selectedTitleSize Width:MAXFLOAT].width;
        if (width > maxWidth) {
            maxWidth = width;
        }
    }
    CGFloat width = (CGRectGetWidth(self.frame) / componentsNumber - maxWidth) / 2.0 + maxWidth + 6;
    
    return width;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [self.tableViewArray indexOfObject:tableView];
    NSArray *titleArray = self.titleListArray[index];
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"cellID";
    EHPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[EHPickerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSInteger index = [self.tableViewArray indexOfObject:tableView];
    NSArray *titleArray = self.titleListArray[index];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.titleLabel.font = [UIFont systemFontOfSize:self.titleSize];
    cell.titleLabel.textColor = self.titleColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self spaceHeight];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSInteger component = [self.tableViewArray indexOfObject:(UITableView *)scrollView];
    NSInteger lastSelectedRow = [self.selectedRowArray[component] integerValue];
    [self highLightTitle:NO AtRow:lastSelectedRow inComponent:component];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    NSInteger component = [self.tableViewArray indexOfObject:(UITableView *)scrollView];
    CGFloat rowHeight = [self.rowHeightArray[component] floatValue];
    CGFloat result = targetContentOffset->y / rowHeight;
    NSInteger num = floor(result);
    
    if((result - num) > 0.5) {
        num++;
    }
    targetContentOffset->y = rowHeight * num;

    self.selectedRowArray[component] = @(num);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger component = [self.tableViewArray indexOfObject:(UITableView *)scrollView];
    NSInteger row = [self.selectedRowArray[component] integerValue];
    [self highLightTitle:YES AtRow:row inComponent:component];

    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:[self.selectedRowArray[component] integerValue] inComponent:component];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger component = [self.tableViewArray indexOfObject:(UITableView *)scrollView];
    NSInteger row = [self.selectedRowArray[component] integerValue];
    [self highLightTitle:YES AtRow:row inComponent:component];

}

- (CGFloat)spaceHeight {
    CGFloat rowHeight = [self.rowHeightArray[0] floatValue];
    CGFloat titleHeight = [@"text" sizeWithFontSize:self.titleSize Width:MAXFLOAT].height;
    return rowHeight - titleHeight;
}

#pragma mark - Getters And Setters

- (void)configTitleListArray {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    
    for (NSInteger component = 0; component < componentsNumber; component++) {
        
        NSMutableArray *titleList = [[NSMutableArray alloc]init];
        NSInteger rowNumber = [self.dataSource pickerView:self numberOfRowsInComponent:component];
        for (NSInteger row = 0; row < rowNumber; row++) {
            
            if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                [titleList addObject:[self.delegate pickerView:self titleForRow:row forComponent:component]];
            }
            else {
                [titleList addObject:@""];
            }
        }
        [titleList insertObject:@"" atIndex:0];
        [titleList addObject:@""];
        [self.titleListArray addObject:titleList];
    }
}

- (void)configTableViewArray {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    
    for (NSInteger component = 0; component < componentsNumber; component++) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = [self.rowHeightArray[component] floatValue];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.tableViewArray addObject:tableView];
        [self addSubview:tableView];
        [tableView reloadData];
    }
}

- (void)configUnitTitleLabelArray {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    
    for (NSInteger component = 0; component < componentsNumber; component++) {
        UILabel *unitTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        unitTitleLabel.font = [UIFont systemFontOfSize:self.unitTitleSize];
        unitTitleLabel.textColor = self.unitTitleColor;
        unitTitleLabel.backgroundColor = [UIColor clearColor];
        
        NSString *text;
        if ([self.delegate respondsToSelector:@selector(pickerView:unitTitleForComponent:)]) {
            text = [self.delegate pickerView:self unitTitleForComponent:component];
        }
        else {
            text = @"";
        }
        unitTitleLabel.text = text;
        [self.unitTitleLabelArray addObject:unitTitleLabel];
        [self addSubview:unitTitleLabel];
    }
}

- (void)configSelectedRowArray {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];
    
    for (NSInteger component = 0; component < componentsNumber; component++) {
        [self.selectedRowArray addObject:@(0)];
    }
}

- (void)configRowHeightArray {
    NSInteger componentsNumber = [self.dataSource numberOfComponentsInPickerView:self];

    for (NSInteger component = 0; component < componentsNumber; component++) {
        CGFloat rowHeight;
        if ([self.delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
            rowHeight = [self.delegate pickerView:self rowHeightForComponent:component];
        }
        else {
            rowHeight = self.rowHeight;
        }
        [self.rowHeightArray addObject:@(rowHeight)];
    }
}

- (UIView *)upLineView {
    if (!_upLineView) {
        _upLineView = [[UIView alloc]init];
        _upLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    }
    return _upLineView;
}

- (UIView *)downLineView {
    if (!_downLineView) {
        _downLineView = [[UIView alloc]init];
        _downLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    }
    return _downLineView;
}

@end
