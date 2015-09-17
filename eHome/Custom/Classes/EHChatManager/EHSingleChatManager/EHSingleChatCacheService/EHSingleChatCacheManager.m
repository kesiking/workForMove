//
//  EHSingleChatCacheManager.m
//  eHome
//
//  Created by 孟希羲 on 15/9/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHSingleChatCacheManager.h"
#import "EHSingleChatCacheService.h"
#import "LKDBHelper.h"

@implementation EHSingleChatCacheManager

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

-(void)insertCacheWithBabyID:(NSString*)babyID
               componentItem:(WeAppComponentBaseItem*)componentItem
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] insertToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)deleteCacheWithBabyID:(NSString*)babyID
                componentItem:(WeAppComponentBaseItem*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] deleteToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)clearCacheWithBabyID:(NSString*)babyID
          componentItemClass:(Class)componentItemClass{
    [[LKDBHelper getUsingLKDBHelper] deleteWithTableName:[EHSingleChatCacheService getSingleChatCacheTableNameWithBabyID:babyID] where:nil];
}

@end
