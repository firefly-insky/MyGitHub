//
//  NSURL+FJFScheme.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "NSURL+FJFScheme.h"

@implementation NSURL (FJFScheme)
-(NSURL *)customSchemeURL{
    NSURLComponents *component = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    component.scheme = @"FJFPlayer";
    return [component URL];
}

-(NSURL *)originalSchemeURL{
    NSURLComponents *component = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    component.scheme = @"http";
    return [component URL];
}
@end
