//
//  EHMapGeoSearchContainer.h
//  eHome
//
//  Created by 孟希羲 on 15/6/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHMapServiceContainer.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface EHMapGeoSearchContainer : EHMapServiceContainer<AMapSearchDelegate>
{
    AMapSearchAPI *_search;
}

@end
