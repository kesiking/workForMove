//
//  EHBabyButton.m
//  eHome
//
//  Created by 孟希羲 on 15/6/18.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyButton.h"

#define babyImageViewWidth  (60.0)
#define babyImageViewHeight (babyImageViewWidth)

@interface EHBabyButton()

@property (nonatomic, strong) UIButton              *btn;
@property (nonatomic, strong) UIImageView           *babyImageView;
@property (nonatomic, strong) UILabel               *babyLabel;

@property (nonatomic, strong) UIImage               *selectImage;

@property (nonatomic, strong) UIImage               *unSelectImage;

@end

@implementation EHBabyButton

-(void)setupView{
    [super setupView];
    [self initBabyButton];
    [self initNotification];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setBabyItem:(WeAppComponentBaseItem *)babyItem
{
    _babyItem = babyItem;
    
    if ([babyItem isKindOfClass:[EHGetBabyListRsp class]]
        && [((EHGetBabyListRsp*)babyItem).device_status integerValue] == 0) {
        self.babyImageView.alpha = 0.5;
    }
}
-(void)setBtnImageUrl:(NSString*)imageUrl{
    if (imageUrl == nil) {
        return;
    }
//    [_btn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"gz_image_loading"]];
    [_babyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"gz_image_loading"]];
}

-(void)setBtnImageUrl:(NSString*)imageUrl withSex:(NSUInteger)isBoy{
    if (imageUrl == nil) {
        return;
    }
    /*if ([KSAuthenticationCenter isTestAccount]) {
        [_babyImageView setImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]];
    }else*/
    {
        if (isBoy == EHBabySexType_girl) {
            [_babyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:[(EHGetBabyListRsp*)self.babyItem babyId] newPlaceHolderImagePath:imageUrl defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]]];
        }else{
            [_babyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:[(EHGetBabyListRsp*)self.babyItem babyId] newPlaceHolderImagePath:imageUrl defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]]];
        }
    }
}

-(void)setBtnImage:(UIImage*)image{
//    [_btn setImage:image forState:UIControlStateNormal];
    self.unSelectImage = image;
    [_babyImageView setImage:image];
}

-(void)setBtnSelectImage:(UIImage*)image{
//    [_btn setImage:image forState:UIControlStateNormal];
    self.selectImage = image;
}

-(void)setBtnTitle:(NSString*)title{
//    [_btn setTitle:title forState:UIControlStateNormal];
    [_babyLabel setText:title];
}

-(void)setBtnEnabel:(BOOL)enable{
    [_btn setEnabled:enable];
}

-(void)setBtnClicked{
    [self babyButtonClicked:_btn];
}

-(void)initBabyButton{
    _btn = [[UIButton alloc] initWithFrame:self.bounds];
    [_btn addTarget:self action:@selector(babyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btn addTarget:self action:@selector(babyButtonClickedDown:) forControlEvents:UIControlEventTouchDown];
    [_btn addTarget:self action:@selector(babyButtonClickedCancel:) forControlEvents:UIControlEventTouchCancel];
    [_btn addTarget:self action:@selector(babyButtonClickedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:_btn];
    
    _babyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - babyImageViewWidth)/2, 20, babyImageViewWidth, babyImageViewHeight)];
    _babyImageView.layer.cornerRadius = _babyImageView.height/2;
    _babyImageView.layer.masksToBounds = YES;
    _babyImageView.layer.borderWidth = 2.0;
    _babyImageView.layer.borderColor = RGB(0xb4, 0xd0, 0xff).CGColor;

    [self addSubview:_babyImageView];
    
    _babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _babyImageView.bottom + (self.height - _babyImageView.bottom - 20)/2, self.width, 20)];
    _babyLabel.textAlignment = NSTextAlignmentCenter;
    [_babyLabel setFont:[UIFont systemFontOfSize:12]];
    [_babyLabel setTextColor:EH_cor4];
    [self addSubview:_babyLabel];

}

-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyOutLineNotification:) name:EHBabyOutLineNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyOnLineNotification:) name:EHBabyOnLineNotification object:nil];
}

-(void)babyButtonClickedDown:(id)sender{
    if (self.selectImage) {
        [_babyImageView setImage:self.selectImage];
    }
}

-(void)babyButtonClickedCancel:(id)sender{
    if (self.unSelectImage) {
        [_babyImageView setImage:self.unSelectImage];
    }
}

-(void)babyButtonClickedUpOutside:(id)sender{
    if (self.unSelectImage) {
        [_babyImageView setImage:self.unSelectImage];
    }
}

-(void)babyButtonClicked:(id)sender{
    if (self.unSelectImage) {
        [_babyImageView setImage:self.unSelectImage];
    }
    if (self.babyButtonClicedBlock) {
        self.babyButtonClicedBlock(self);
    }
}

-(void)babyOutLineNotification:(NSNotification*)notification{
    
    NSUInteger currentBabyId = [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue];

    NSNumber* messageBabyId = [notification.userInfo objectForKey:EHMESSAGE_BABY_ID_DATA];
    if (messageBabyId) {
        currentBabyId = [messageBabyId integerValue];
    }
    
    if (self.babyImageView.alpha == 1.0
        && self.babyItem
        && [self.babyItem isKindOfClass:[EHGetBabyListRsp class]]
        && [((EHGetBabyListRsp*)self.babyItem).babyId integerValue] == currentBabyId) {
        self.babyImageView.alpha = 0.5;
    }
}

-(void)babyOnLineNotification:(NSNotification*)notification{
    NSUInteger currentBabyId = [[[EHBabyListDataCenter sharedCenter] currentBabyId] integerValue];
    
    NSNumber* messageBabyId = [notification.userInfo objectForKey:EHMESSAGE_BABY_ID_DATA];
    if (messageBabyId) {
        currentBabyId = [messageBabyId integerValue];
    }
    
    if (self.babyImageView.alpha != 1.0
        && self.babyItem
        && [self.babyItem isKindOfClass:[EHGetBabyListRsp class]]
        && [((EHGetBabyListRsp*)self.babyItem).babyId integerValue] == currentBabyId) {
        self.babyImageView.alpha = 1.0;
    }
}

@end
