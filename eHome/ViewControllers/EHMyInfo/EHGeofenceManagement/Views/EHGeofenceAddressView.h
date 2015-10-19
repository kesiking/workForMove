//
//  EHGeofenceAddressView.h
//  eHome
//
//  Created by xtq on 15/9/30.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBtnClickBlock)();


@interface EHGeofenceAddressView : UIView

@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)SearchBtnClickBlock searchBtnClickBlock;

@end
