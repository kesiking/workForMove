//
//  EHBabyMsgInfoCell.m
//  eHome
//
//  Created by 姜伟刚 on 15/8/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBabyMsgInfoCell.h"
#import "EHMessageInfoModel.h"
#import "EHMessageCellModelInfoItem.h"

@interface EHBabyMsgInfoCell()

@property (nonatomic, assign) CGSize             messageInfoSize;

@end
@implementation EHBabyMsgInfoCell

+(id)createView{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    if ([nibContents count] > 0) {
        id object = [nibContents objectAtIndex:0];
        if (object && [object isKindOfClass:[self class]])
        {
            return object;
        }
    }
    return nil;
}
-(instancetype)init
{
    self=[[self class] createView];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[[self class] createView];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    [super setupView];
    [self.bgMsgImageView setImage:[[UIImage imageNamed:@"bg_message"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 100, 40, 120)]];
    self.timeStampLabel.textColor=EH_cor5;
    self.dateLabel.textColor=EH_cor3;
    self.timeLabel.textColor=EH_cor5;
    self.sosMessageLabel.textColor=EH_cor7;
    self.babyNameLabel.textColor=EH_cor3;
    self.messageNameLabel.textColor=EH_cor3;
    self.messageInfoLabel.textColor=EH_cor3;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.messageInfoLabel setSize:self.messageInfoSize];
}
- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem *)extroParams
{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    EHMessageInfoModel* messageInfoComponentItem = (EHMessageInfoModel*)componentItem;
    if (![messageInfoComponentItem isKindOfClass:[EHMessageInfoModel class]]) {
        return;
    }
    [self configCellLabelWithCellView:cell Frame:rect componentItem:messageInfoComponentItem extroParams:extroParams];
    [self configCellImageWithCellView:cell Frame:rect componentItem:messageInfoComponentItem extroParams:extroParams];
}

-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHMessageInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams
{
    NSUInteger category = [componentItem.category unsignedIntegerValue];
    [self isSOSMessage:category];
    switch (category) {
        case EHMessageInfoCatergoryType_Battery:
            self.messageNameLabel.text=@"电量提示";
            break;
        case EHMessageInfoCatergoryType_Family:
            self.messageNameLabel.text=@"家庭消息";
            break;
        case EHMessageInfoCatergoryType_Family_ChangeBabyPhone:
            self.messageNameLabel.text=@"换卡提醒";
            break;
        case EHMessageInfoCatergoryType_Location:
            self.messageNameLabel.text=@"位置消息";
            break;
        case EHMessageInfoCatergoryType_SOS:
            self.messageNameLabel.text=[NSString stringWithFormat:@"%@发出求救消息",componentItem.trigger_name];
            break;
        case EHMessageInfoCatergoryType_OutOrInLine:
        {
            if ([self isDeviceOutLineWithComponentItem:componentItem]) {
                self.messageNameLabel.text=@"离线消息";
            }else{
                self.messageNameLabel.text=@"上线消息";
                }
        }
            break;
        default:
            self.messageNameLabel.text=@"未知消息";
            break;
    }

}

-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHMessageInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams
{
    if ([extroParams isKindOfClass:[EHMessageCellModelInfoItem class]]) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@",((EHMessageCellModelInfoItem*)extroParams).messageDate];
        self.timeStampLabel.text = [NSString stringWithFormat:@"%@",((EHMessageCellModelInfoItem*)extroParams).timeStamp];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",((EHMessageCellModelInfoItem*)extroParams).messageTime];
    }else{
        self.dateLabel.text = [NSString stringWithFormat:@"%@",componentItem.message_time];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",componentItem.message_time];
    }
    self.babyNameLabel.text =[NSString stringWithFormat:@"%@",componentItem.trigger_name];
    self.messageInfoLabel.text = [NSString stringWithFormat:@"%@",componentItem.info];
    [self needTimeStampOrNot:((EHMessageCellModelInfoItem*)extroParams).needTimeStamp];
    self.messageInfoSize = ((EHMessageCellModelInfoItem*)extroParams).messageInfoSize;
    [self.messageInfoLabel setSize:self.messageInfoSize];
}
-(BOOL)isDeviceOutLineWithComponentItem:(EHMessageInfoModel *)componentItem{
    NSRange range = [componentItem.info rangeOfString:@"离线"];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (void)isSOSMessage:(NSUInteger)category
{
    if (category==EHMessageInfoCatergoryType_SOS) {
        self.sosPointImageView.hidden=NO;
        self.dateToSosConstraint.priority=750;
        self.dateToSuperConstraint.priority=250;
        
        self.sosMessageLabel.hidden=NO;
        self.msgNameToSosMsgConstraint.priority=750;
        self.msgNameToBgConstraint.priority=250;
    }
    else
    {
        self.sosPointImageView.hidden=YES;
        self.dateToSosConstraint.priority=250;
        self.dateToSuperConstraint.priority=750;
        
        self.sosMessageLabel.hidden=YES;
        self.msgNameToSosMsgConstraint.priority=250;
        self.msgNameToBgConstraint.priority=750;
    }
}
- (void)needTimeStampOrNot:(BOOL)flag
{
    if (flag) {
        self.timeStampLabel.hidden=NO;
        self.bgImageToTimeStamp.priority=750;
        self.bgImageTosuper.priority=250;
    }else {
        self.timeStampLabel.hidden=YES;
        self.bgImageToTimeStamp.priority=250;
        self.bgImageTosuper.priority=750;
    }
}
@end
