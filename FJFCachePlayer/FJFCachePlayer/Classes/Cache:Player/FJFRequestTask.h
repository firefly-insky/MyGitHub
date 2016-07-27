//
//  FJFRequestTask.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJFRequestTask : NSObject
/**
 *  请求地址
 */
@property(nonatomic,strong)NSURL * requestURl;
/**
 *  请求起始位置
 */
@property(nonatomic,assign)NSInteger requestOffset;
/**
 *  文件长度
 */
@property(nonatomic,assign)NSInteger fileLength;
/**
 *  缓冲长度
 */
@property(nonatomic,assign)NSInteger cacheLength;
/**
 *  是否缓存文件
 */
@property(nonatomic,assign)BOOL cache;
/**
 *  是否取消请求
 */
@property(nonatomic,assign)BOOL  cancelTask;


@end
