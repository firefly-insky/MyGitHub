//
//  FJFFileHandle.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJFFileHandle : NSObject

/**
 *  创建一个临时文件
 */
+(BOOL)createTempFile;
/**
 *  写数据到临时文件
 */
+(void)writeTempFileData:(NSData *)data;
/**
 *  从临时文件读取数据
 */
+(NSData *)readTempFileWithOffset:(NSInteger)offset length:(NSInteger)length;

/**
 *  保存临时文件到缓存
 */
+(void)cacheTempFileWithFileName:(NSString *)name;

/**
 *  查询本地是否有缓存
 *
 *  @return 返回文件URL,没有返回nil
 */
+(NSString *)cacheFileExistsWithUrl:(NSURL *)url;
/**
 *  清除缓存
 */
+(BOOL)clearCache;
@end
