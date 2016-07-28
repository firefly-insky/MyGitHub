//
//  FJFPlayer.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FJFPlayer : NSObject

-(instancetype)initWithUrl:(NSURL *)url;

-(void)play;
+ (BOOL)clearCache;

@end
