//
//  NSString+FJFFileExtension.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FJFFileExtension)

/**
 * 临时文件路劲
 */
+(NSString *)tempFilePath;
/**
 *  缓存文件路径
 */
+(NSString *)cacheFolderPath;
/**
 *  获取网址中的文件名
 */
+(NSString *)fileNameWithUrl:(NSURL *)url;
@end
