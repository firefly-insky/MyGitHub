//
//  SONARC4Tool.h
//  Buddhism
//
//  Created by FJF on 16/7/21.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SONARC4Tool : NSObject
+(Byte *)EncodeRC4WithByte:(Byte *)input len:(NSInteger)len Key:(NSArray*)Key;
+(NSMutableArray *)initRC4Key:(NSString *)aKey;
@end
