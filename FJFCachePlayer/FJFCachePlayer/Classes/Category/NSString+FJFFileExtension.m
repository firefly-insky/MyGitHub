//
//  NSString+FJFFileExtension.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "NSString+FJFFileExtension.h"

@implementation NSString (FJFFileExtension)

+(NSString *)tempFilePath{

    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"tempMusic.mp3"];
}

+(NSString *)cacheFolderPath{
   
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"MusicCache"];
}

+(NSString *)fileNameWithUrl:(NSURL *)url{
    
    NSArray *urls =  [url.path componentsSeparatedByString:@"/"];
    NSString *name = [urls.lastObject componentsSeparatedByString:@"?"].firstObject;
    return name;
}
@end
