//
//  NSURL+FJFScheme.h
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (FJFScheme)
-(NSURL *)customSchemeURL;

-(NSURL *)originalSchemeURL;
@end
