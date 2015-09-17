//
//  EHMapHistoryTraceViewCell.m
//  eHome
//
//  Created by 孟希羲 on 15/8/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapHistoryTraceViewCell.h"
#import "EHMapHistoryTraceCellModelInfoItem.h"
#import "EHUserDevicePosition.h"

@interface EHMapHistoryTraceViewCell()

@property (nonatomic,strong)  EHMapHistoryTraceCellModelInfoItem * historyTraceCellModelInfoItem;

@property (nonatomic,strong)  NSMutableAttributedString          * sosMessageText;

@end

@implementation EHMapHistoryTraceViewCell

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
    [self.positionBubbleImageView setImage:[[UIImage imageNamed:@"bg_message"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 100, 20, 120)]];
    self.positionArrorImageViewShouldShow = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _sosMessageText = [[NSMutableAttributedString alloc] initWithString:@"发出SOS警报:"];
    [_sosMessageText addAttribute:NSForegroundColorAttributeName value:EH_cor3 range:NSMakeRange(0,2)];
    [_sosMessageText addAttribute:NSForegroundColorAttributeName value:RGB(0xff, 0x3e, 0x3e) range:NSMakeRange(2,3)];
    [_sosMessageText addAttribute:NSForegroundColorAttributeName value:EH_cor3 range:NSMakeRange(5,3)];
    self.sosMessageInfolabel.attributedText = self.sosMessageText;
    [self.sosMessageInfolabel sizeToFit];
}

-(UILabel *)sosMessageInfolabel{
    if (_sosMessageInfolabel == nil) {
        _sosMessageInfolabel = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLocationDesInfolabel.origin.x, 0, 200, 20)];
        _sosMessageInfolabel.font = [UIFont systemFontOfSize:15];
        _sosMessageInfolabel.textColor = EH_cor3;
        _sosMessageInfolabel.numberOfLines = 1;
        [self addSubview:_sosMessageInfolabel];
    }
    return _sosMessageInfolabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_sosMessageInfolabel.hidden) {
        [_sosMessageInfolabel setFrame:CGRectMake(self.positionLocationDesInfolabel.origin.x, self.positionBubbleImageView.top + (self.positionBubbleImageView.height - self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.height - _sosMessageInfolabel.height)/2, _sosMessageInfolabel.width, _sosMessageInfolabel.height)];
        [self.positionLocationDesInfolabel setFrame:CGRectMake(self.positionLocationDesInfolabel.origin.x, _sosMessageInfolabel.bottom + 2, self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.width, self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.height)];
    }else{
        [self.positionLocationDesInfolabel setFrame:CGRectMake(self.positionLocationDesInfolabel.origin.x, self.positionBubbleImageView.top + (self.positionBubbleImageView.height - self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.height)/2, self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.width, self.historyTraceCellModelInfoItem.positionLocationDesInfoSize.height)];

    }
}

-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHUserDevicePosition *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
    self.positionArrowImageView.hidden = !self.positionArrorImageViewShouldShow;
}

-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(EHUserDevicePosition *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if ([extroParams isKindOfClass:[EHMapHistoryTraceCellModelInfoItem class]]) {
        self.timelabel.text = [NSString stringWithFormat:@"%@",((EHMapHistoryTraceCellModelInfoItem*)extroParams).positionLocationTime];
        self.historyTraceCellModelInfoItem = (EHMapHistoryTraceCellModelInfoItem*)extroParams;
    }else{
        self.timelabel.text = [NSString stringWithFormat:@"%@",componentItem.location_time];
    }
    if ([componentItem.locationType isEqualToString:SOS_LocationType]) {
        [self.sosMessageInfolabel setHidden:NO];
    }else{
        [self.sosMessageInfolabel setHidden:YES];
    }
    self.positionLocationDesInfolabel.text = [NSString stringWithFormat:@"%@",componentItem.location_Des];
}

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    
    EHUserDevicePosition* positionInfoComponentItem = (EHUserDevicePosition*)componentItem;
    if (![positionInfoComponentItem isKindOfClass:[EHUserDevicePosition class]]) {
        return;
    }
    [self configCellLabelWithCellView:cell Frame:rect componentItem:positionInfoComponentItem extroParams:extroParams];
    [self configCellImageWithCellView:cell Frame:rect componentItem:positionInfoComponentItem extroParams:extroParams];
    
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}


@end
