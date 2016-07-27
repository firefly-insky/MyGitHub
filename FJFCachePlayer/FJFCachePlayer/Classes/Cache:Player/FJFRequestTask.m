//
//  FJFRequestTask.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "FJFRequestTask.h"

//请求超时
#define RequestTimeout 10.0

@interface FJFRequestTask ()<NSURLSessionDataDelegate>

@property(nonatomic, strong)NSURLSession *session; //会话
@property(nonatomic, strong)NSURLSessionDataTask *task; //下载任务

@end

@implementation FJFRequestTask

@end
