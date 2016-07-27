//
//  FJFNetWorkManager.h
//  FJFCollector
//
//  Created by FJF on 16/7/6.
//  Copyright © 2016年 sonasona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};


typedef enum : NSUInteger {
    requestMethod_GET=0,
    requestMethod_POST=1,
} requstMetnod;

@interface FJFNetWorkManager : NSObject
single_interface(FJFNetWorkManager)
// 判断网络类型
+ (NetworkStates)getNetworkStates;
/**
 *  苹果原生的NSURLSession的GET请求
 */
-(void)sessionGETWithRequestUrl:(NSString *)url
                         params:(NSMutableDictionary *)params
                    complection:(void(^)(id result))complectoinBlock;
/**
 *  苹果原生的NSURLSession的POST请求
 */
-(void)sessoinPOSTWithRequestUrl:(NSString *)url
                          params:(id)params
                     complection:(void(^)(id result))complectionBlock;

/**
 *  AFN网络请求
 */
-(void)AFNetRequestWithUrl:(NSString *)urlString
                    method:(requstMetnod)method
                    params:(id)params
                   success:(void(^)(id request))success
                   failure:(void(^)(NSError *))failure;
@end
