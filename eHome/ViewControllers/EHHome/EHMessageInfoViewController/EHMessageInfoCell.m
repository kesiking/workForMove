//
//  EHMessageInfoCell.m
//  eHome
//
//  Created by 孟希羲 on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMessageInfoCell.h"
#import "EHMessageInfoModel.h"
#import "EHMessageCellModelInfoItem.h"

@interface EHMessageInfoCell()

@property (nonatomic,strong)  UIImage   * batteryImage;
@property (nonatomic,strong)  UIImage   * familyImage;
@property (nonatomic,strong)  UIImage   * locationImage;
@property (nonatomic,strong)  UIImage   * sosImage;
@property (nonatomic,strong)  UIImage   * outLineImage;

@end

@implementation EHMessageInfoCell

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

-(instancetype)init{
    self = [[self class] createView];
    if (self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [[self class] createView];
    if (self) {
        self.frame = frame;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [super setupView];
    self.backgroundColor = RGB(0xf0, 0xf0, 0xf0);
    self.batteryImage = [UIImage imageNamed:@"ico_messagelist_battery"];
    self.familyImage = [UIImage imageNamed:@"ico_messagelist_family"];
    self.locationImage = [UIImage imageNamed:@"ico_messagelist_location"];
    self.sosImage = [UIImage imageNamed:@"ico_messagelist_SOS"];
    self.outLineImage = [UIImage imageNamed:@"gz_image_loading"];
}

-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHMessageInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    NSUInteger category = [componentItem.category unsignedIntegerValue];
    switch (category) {
        case EHMessageInfoCatergoryType_Battery:{
            if (self.batteryImage != self.messageImageView.image) {
                [self.messageImageView setImage:self.batteryImage];
                [self.messageNamelabel setText:@"电池提醒："];
            }
        }
            break;
        case EHMessageInfoCatergoryType_Family:{
            if (self.familyImage != self.messageImageView.image) {
                [self.messageImageView setImage:self.familyImage];
                [self.messageNamelabel setText:@"家庭消息："];
            }
        }
            break;
        case EHMessageInfoCatergoryType_Family_ChangeBabyPhone:{
            if (self.familyImage != self.messageImageView.image) {
                [self.messageImageView setImage:self.familyImage];
                [self.messageNamelabel setText:@"家庭消息："];
            }
        }
            break;
        case EHMessageInfoCatergoryType_Location:{
            if (self.locationImage != self.messageImageView.image) {
                [self.messageImageView setImage:self.locationImage];
                [self.messageNamelabel setText:@"位置消息："];
            }
        }
            break;
        case EHMessageInfoCatergoryType_SOS:{
            if (self.sosImage != self.messageImageView.image) {
                [self.messageImageView setImage:self.sosImage];
                [self.messageNamelabel setText:@"SOS："];
            }
        }
            break;
        case EHMessageInfoCatergoryType_OutOrInLine:
        {
            if ([self isDeviceOutLineWithComponentItem:componentItem]) {
                if (self.outLineImage != self.messageImageView.image) {
                    [self.messageImageView setImage:self.outLineImage];
                    [self.messageNamelabel setText:@"离线消息："];
                }
            }else{
                if (self.outLineImage != self.messageImageView.image) {
                    [self.messageImageView setImage:self.outLineImage];
                    [self.messageNamelabel setText:@"上线消息："];
                }
            }
        }
            break;
        default:
            [self.messageImageView setImage:[UIImage imageNamed:@"gz_image_loading"]];
            [self.messageNamelabel setText:@"未知消息："];
            break;
    }
}

-(BOOL)isDeviceOutLineWithComponentItem:(EHMessageInfoModel *)componentItem{
    NSRange range = [componentItem.info rangeOfString:@"离线"];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHMessageInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
    if ([extroParams isKindOfClass:[EHMessageCellModelInfoItem class]]) {
        self.timelabel.text = [NSString stringWithFormat:@"%@",((EHMessageCellModelInfoItem*)extroParams).messageTime];
    }else{
        self.timelabel.text = [NSString stringWithFormat:@"%@",componentItem.message_time];
    }
    
    self.personNamelabel.text = [NSString stringWithFormat:@"%@",componentItem.trigger_name];
    self.messageInfolabel.text = [NSString stringWithFormat:@"%@",componentItem.info];
    
    [self.messageInfolabel setSize:((EHMessageCellModelInfoItem*)extroParams).messageInfoSize];
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    
    EHMessageInfoModel* messageInfoComponentItem = (EHMessageInfoModel*)componentItem;
    if (![messageInfoComponentItem isKindOfClass:[EHMessageInfoModel class]]) {
        return;
    }
    [self configCellLabelWithCellView:cell Frame:rect componentItem:messageInfoComponentItem extroParams:extroParams];
    [self configCellImageWithCellView:cell Frame:rect componentItem:messageInfoComponentItem extroParams:extroParams];
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

@end
