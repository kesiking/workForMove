//
//  EHAudioDataCache.h
//  eHome
//
//  Created by 孟希羲 on 15/9/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EHAudioDataCacheType) {
    /**
     * The audio wasn't available the EHAudioData caches, but was downloaded from the web.
     */
    EHAudioDataCacheTypeNone,
    /**
     * The audio was obtained from the disk cache.
     */
    EHAudioDataCacheTypeDisk,
};

typedef void(^EHAudioDataQueryCompletedBlock)(NSData *AudioData, EHAudioDataCacheType cacheType);

typedef void(^EHAudioDataCheckCacheCompletionBlock)(BOOL isInCache);

typedef void(^EHAudioDataCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

typedef void(^EHWebAudioDataNoParamsBlock)();

@interface EHAudioDataCache : NSObject

/**
 * The maximum "total cost" of the in-memory AudioData cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum length of time to keep an AudioData in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 * Returns global shared cache instance
 *
 * @return SDAudioDataCache global instance
 */
+ (EHAudioDataCache *)sharedAudioDataCache;

/**
 * Init a new cache store with a specific namespace
 *
 * @param ns The namespace to use for this cache store
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 * Add a read-only cache path to search for AudioDatas pre-cached by SDAudioDataCache
 * Useful if you want to bundle pre-loaded AudioDatas with your app
 *
 * @param path The path to use for this read-only cache path
 */
- (void)addReadOnlyCachePath:(NSString *)path;

/**
 * Store an AudioData into memory and disk cache at the given key.
 *
 * @param AudioData The AudioData to store
 * @param key   The unique AudioData cache key, usually it's AudioData absolute URL
 */
- (void)storeAudioData:(NSData *)audioData forKey:(NSString *)key;

/**
 * Store an AudioData into memory and optionally disk cache at the given key.
 *
 * @param AudioData  The AudioData to store
 * @param key    The unique AudioData cache key, usually it's AudioData absolute URL
 * @param toDisk Store the AudioData to disk cache if YES
 */
- (void)storeAudioData:(NSData *)audioData forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Query the disk cache asynchronously.
 *
 * @param key The unique key used to store the wanted AudioData
 */
- (void)queryDiskCacheForKey:(NSString *)key done:(EHAudioDataQueryCompletedBlock)doneBlock;

/**
 * Query the disk cache synchronously after checking the memory cache.
 *
 * @param key The unique key used to store the wanted AudioData
 */
- (NSData *)audioDataFromDiskCacheForKey:(NSString *)key;

/**
 * Remove the AudioData from memory and disk cache synchronously
 *
 * @param key The unique AudioData cache key
 */
- (void)removeAudioDataForKey:(NSString *)key;

/**
 * Remove the AudioData from memory and disk cache synchronously
 *
 * @param key             The unique AudioData cache key
 * @param completion      An block that should be executed after the AudioData has been removed (optional)
 */
- (void)removeAudioDataForKey:(NSString *)key withCompletion:(EHWebAudioDataNoParamsBlock)completion;

/**
 * Remove the AudioData from memory and optionally disk cache synchronously
 *
 * @param key      The unique AudioData cache key
 * @param fromDisk Also remove cache entry from disk if YES
 */
- (void)removeAudioDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 * Remove the AudioData from memory and optionally disk cache synchronously
 *
 * @param key             The unique AudioData cache key
 * @param fromDisk        Also remove cache entry from disk if YES
 * @param completion      An block that should be executed after the AudioData has been removed (optional)
 */
- (void)removeAudioDataForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(EHWebAudioDataNoParamsBlock)completion;

/**
 * Clear all disk cached AudioDatas. Non-blocking method - returns immediately.
 * @param completion    An block that should be executed after cache expiration completes (optional)
 */
- (void)clearDiskOnCompletion:(EHWebAudioDataNoParamsBlock)completion;

/**
 * Clear all disk cached AudioDatas
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Remove all expired cached AudioData from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)cleanDiskWithCompletionBlock:(EHWebAudioDataNoParamsBlock)completionBlock;

/**
 * Remove all expired cached AudioData from disk
 * @see cleanDiskWithCompletionBlock:
 */
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of AudioDatas in the disk cache
 */
- (NSUInteger)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */
- (void)calculateSizeWithCompletionBlock:(EHAudioDataCalculateSizeBlock)completionBlock;

/**
 *  Async check if AudioData exists in disk cache already (does not load the AudioData)
 *
 *  @param key             the key describing the url
 *  @param completionBlock the block to be executed when the check is done.
 *  @note the completion block will be always executed on the main queue
 */
- (void)diskAudioDataExistsWithKey:(NSString *)key completion:(EHAudioDataCheckCacheCompletionBlock)completionBlock;

/**
 *  Check if AudioData exists in disk cache already (does not load the AudioData)
 *
 *  @param key the key describing the url
 *
 *  @return YES if an AudioData exists for the given key
 */
- (BOOL)diskAudioDataExistsWithKey:(NSString *)key;

/**
 *  Get the cache path for a certain key (needs the cache path root folder)
 *
 *  @param key  the key (can be obtained from url using cacheKeyForURL)
 *  @param path the cach path root folder
 *
 *  @return the cache path
 */
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;

/**
 *  Get the default cache path for a certain key
 *
 *  @param key the key (can be obtained from url using cacheKeyForURL)
 *
 *  @return the default cache path
 */
- (NSString *)defaultCachePathForKey:(NSString *)key;

@end
