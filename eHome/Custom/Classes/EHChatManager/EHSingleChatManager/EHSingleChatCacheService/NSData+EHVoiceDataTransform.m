//
//  NSData+EHVoiceDataTransform.m
//  eHome
//
//  Created by 孟希羲 on 15/9/17.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "NSData+EHVoiceDataTransform.h"
#import "XHVoiceRecordHelper.h"

@implementation NSData (EHVoiceDataTransform)

+(NSString *)stringFromVoicePath:(NSString *)voicePath
{
    if (voicePath == nil) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:voicePath];
    NSString *str;
    if(IOS_VERSION<7)
    {
        str = [data base64Encoding];
    }
    else
    {
        str  =[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    return str;
}

+(NSString *)voicePathFromString:(NSString *)string
{
    if(string==nil)
    {
        return nil;
    }
    NSData *data;
    //NSLog(@"%@",string);
    if(IOS_VERSION<7)
    {
        data = [[NSData alloc] initWithBase64Encoding:string];
    }
    else
    {
        data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    NSString *voicePath = [self getRecorderPath];
    
    if (data) {
        [data writeToFile:voicePath atomically:YES];
        return voicePath;
    }
    
    return nil;
}

+ (NSString *)getRecorderPath {
    return [XHVoiceRecordHelper getRecorderPath];
}

@end
