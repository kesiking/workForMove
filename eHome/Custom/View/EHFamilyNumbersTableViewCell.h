//
//  EHFamilyNumbersTableViewCell.h
//  eHome
//
//  Created by jinmiao on 15/7/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHBabyFamilyPhone.h"
#import "TBDetailUITools.h"


//typedef void(^selectedBlock)(BOOL selected);

@interface EHFamilyNumbersTableViewCell : UITableViewCell

@property (strong,nonatomic) UIView *cellSeparator;


@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage;
@property (weak, nonatomic) IBOutlet UIImageView *colorfulRankImage;

@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (weak, nonatomic) IBOutlet UIImageView *relationImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (assign,nonatomic) BOOL isCellSelected;


//@property (weak, nonatomic) IBOutlet UIButton *markButton;

//@property (copy, nonatomic) selectedBlock selectedComplete;

//- (IBAction)selectAction:(id)sender;

//- (void)SetContentToCell:(id)data;
- (void)SetContentToCell:(id)data markHide:(BOOL)hide;


@end
