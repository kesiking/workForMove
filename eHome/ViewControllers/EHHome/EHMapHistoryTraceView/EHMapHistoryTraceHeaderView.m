//
//  EHMapHistoryTraceHeaderView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/5.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceHeaderView.h"

#define historyTraceHeaderImageView_width   (36)
#define historyTraceHeaderImageView_height  (historyTraceHeaderImageView_width)

#define historyTraceNameLabel_height        (20)


@implementation EHMapHistoryTraceHeaderView

-(void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor clearColor];
    [self initHistoryTraceHeaderBtn];
//    [self initBGImageView];
    [self initHeaderImageView];
//    [self initNameLabel];
}

-(void)initHistoryTraceHeaderBtn{
    _historyTraceHeaderBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [_historyTraceHeaderBtn setBackgroundColor:[UIColor clearColor]];
    [_historyTraceHeaderBtn addTarget:self action:@selector(historyTraceHeaderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_historyTraceHeaderBtn];
}

-(void)initBGImageView{
    _historyTraceHeaderBGImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_historyTraceHeaderBGImageView setImage:[UIImage imageNamed:@"bg_maptrack"]];
    [self addSubview:_historyTraceHeaderBGImageView];
}

-(void)initHeaderImageView{
    _historyTraceHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - historyTraceHeaderImageView_width)/2, (self.height - historyTraceHeaderImageView_height - historyTraceNameLabel_height)/2 + 3, historyTraceHeaderImageView_width, historyTraceHeaderImageView_height)];
    _historyTraceHeaderImageView.layer.cornerRadius = _historyTraceHeaderImageView.height/2;
    _historyTraceHeaderImageView.layer.masksToBounds = YES;
    [_historyTraceHeaderImageView setImage:[UIImage imageNamed:@"ico_suspend"]];

    /*
     EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];

    if ([KSAuthenticationCenter isTestAccount]) {
        [_historyTraceHeaderImageView setImage:[UIImage imageNamed:@"public_headportrait_map_testaccount_100"]];
    }else if ([currentBabyUserInfo.babySex integerValue] == EHBabySexType_girl) {
        [_historyTraceHeaderImageView sd_setImageWithURL:[NSURL URLWithString:currentBabyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:currentBabyUserInfo.babyId newPlaceHolderImagePath:currentBabyUserInfo.babyHeadImage defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_girl_80"]]];
    }else{
        [_historyTraceHeaderImageView sd_setImageWithURL:[NSURL URLWithString:currentBabyUserInfo.babyHeadImage] placeholderImage:[EHUtils getBabyHeadPlaceHolderImage:currentBabyUserInfo.babyId newPlaceHolderImagePath:currentBabyUserInfo.babyHeadImage defaultHeadImage:[UIImage imageNamed:@"public_headportrait_map_dorpdown_boy_80"]]];
    }*/
    [self addSubview:_historyTraceHeaderImageView];

}

-(void)initNameLabel{
    _historyTraceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _historyTraceHeaderImageView.bottom, self.width, historyTraceNameLabel_height)];
    _historyTraceNameLabel.textAlignment = NSTextAlignmentCenter;
    _historyTraceNameLabel.textColor = EH_cor3;
    _historyTraceNameLabel.font = EH_font6;
    EHGetBabyListRsp* currentBabyUserInfo = [[EHBabyListDataCenter sharedCenter] currentBabyUserInfo];
    [_historyTraceNameLabel setText:currentBabyUserInfo.babyNickName];
    [self addSubview:_historyTraceNameLabel];
}

-(void)historyTraceHeaderBtnClicked:(id)sender{
    if (self.historyTraceHeaderBtnClickedBlock) {
        self.historyTraceHeaderBtnClickedBlock(self);
    }
}

@end
