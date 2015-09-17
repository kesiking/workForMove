//
//  EHBabyButton.h
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "EHGetBabyListRsp.h"

@class EHBabyButton;

typedef void (^doBabyButtonClicedBlock)        (EHBabyButton* babyButton);

@interface EHBabyButton : KSView

@property (nonatomic, copy  ) doBabyButtonClicedBlock babyButtonClicedBlock;

@property (nonatomic, strong) WeAppComponentBaseItem  *     babyItem;

-(void)setBtnImageUrl:(NSString*)imageUrl;

-(void)setBtnImageUrl:(NSString*)imageUrl withSex:(NSUInteger)isBoy;

-(void)setBtnImage:(UIImage*)image;

-(void)setBtnSelectImage:(UIImage*)image;

-(void)setBtnTitle:(NSString*)title;

-(void)setBtnEnabel:(BOOL)enable;

-(void)setBtnClicked;

@end
