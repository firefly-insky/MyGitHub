//
//  NSData+FJFDataEncode.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/28.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "NSData+FJFData.h"
#import "SONARC4Tool.h"

@implementation NSData (FJFData)

-(NSMutableData *)RC4Decode{
    NSMutableData *musicData=[[NSMutableData alloc] init];
    [musicData setData:self];
    Byte *buff = (Byte *)malloc(256);
    NSInteger loc = 0;
    NSInteger len = 32;
    NSInteger partlen = 256;
    NSData *tempdata = musicData;
    NSInteger totallen = musicData.length;
    NSArray *key= [[SONARC4Tool initRC4Key:@"SONA1234567890acdefg"] mutableCopy];
    
    while (loc < tempdata.length-1) {
        if(totallen-1-loc <= len){
            len = totallen-1-loc;
        }
        [musicData getBytes:buff range:NSMakeRange(loc, len)];
        Byte *subData = [SONARC4Tool EncodeRC4WithByte:buff len:len Key:key];
        [musicData replaceBytesInRange:NSMakeRange(loc, len) withBytes:subData];
        loc +=partlen;
    }
    return musicData;
}

@end
