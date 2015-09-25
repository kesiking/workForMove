//
//  XHAudioPlayerHelper+EHAudioPlayerDownload.m
//  eHome
//
//  Created by 孟希羲 on 15/9/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "XHAudioPlayerHelper+EHAudioPlayerDownload.h"
#import "EHAudioPlayDownLoader.h"

@implementation XHAudioPlayerHelper (EHAudioPlayerDownload)

- (void)managerAudioWithUrl:(NSString*)url toPlay:(BOOL)toPlay {
    NSString* filePath = [[EHAudioPlayDownLoader sharedManager] getFilePathWithURL:[NSURL URLWithString:url]];
    if (filePath == nil) {
        [WeAppToast toast:@"拼命加载中，休息一下再点哦^-^"];
        return;
    }
    [self managerAudioWithFileName:filePath toPlay:toPlay];
}

@end
