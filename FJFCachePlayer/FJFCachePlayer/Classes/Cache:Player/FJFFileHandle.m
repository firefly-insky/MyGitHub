//
//  FJFFileHandle.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "FJFFileHandle.h"
#import "NSString+FJFFileExtension.h"

@interface FJFFileHandle()

@property(nonatomic,strong)NSFileHandle *writeHandle; //写文件句柄
@property(nonatomic,strong)NSFileHandle *readHandle; //读文件句柄

@end

@implementation FJFFileHandle

+(BOOL)createTempFile{

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSString tempFilePath];
    if([manager fileExistsAtPath:path]){
        [manager removeItemAtPath:path error:nil];
    }
    return [manager createFileAtPath:path contents:nil attributes:nil];
}

+(void)writeTempFileData:(NSData *)data{
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[NSString tempFilePath]];
    [handle seekToEndOfFile];
    [handle writeData:data];
}

+(NSData *)readTempFileWithOffset:(NSInteger)offset length:(NSInteger)length{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:[NSString tempFilePath]];
    [handle seekToFileOffset:offset];
    return  [handle readDataOfLength:length];
}

+(void)cacheTempFileWithFileName:(NSString *)name{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cacheFolderPath = [NSString cacheFolderPath];
    if(![manager fileExistsAtPath:cacheFolderPath]){
        [manager createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@",cacheFolderPath,name];
    BOOL state = [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:[NSString tempFilePath]] toURL:[NSURL URLWithString:cacheFilePath] error:nil];
    NSLog(@"%@",state?@"保存成功":@"保存失败");
}

+(NSString *)cacheFileExistsWithUrl:(NSURL *)url{
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@",[NSString cacheFolderPath],[NSString fileNameWithUrl:url]];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachePath]){
        return cachePath;
    }
    return nil;
}

+(BOOL)clearCache{
    NSFileManager *maneger = [NSFileManager defaultManager];
    return  [maneger removeItemAtPath:[NSString cacheFolderPath] error:nil];
}

@end
