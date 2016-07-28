//
//  FJFResourceLoader.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FJFRequestTask.h"
@class FJFResourceLoader;
//#define MimeType @"audio/m4a"
#define MimeType @"audio/mpeg"

@class FJFResourceLoader;
@protocol FJFLoaderDelegate <NSObject>

//@required
- (void)loader:(FJFResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(FJFResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface FJFResourceLoader : NSObject<AVAssetResourceLoaderDelegate,FJFRequestTaskDelegate>

@property (nonatomic, weak) id<FJFLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;
@end
