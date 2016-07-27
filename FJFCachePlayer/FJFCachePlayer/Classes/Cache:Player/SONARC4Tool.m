//
//  SONARC4Tool.m
//  Buddhism
//
//  Created by FJF on 16/7/21.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "SONARC4Tool.h"

@implementation SONARC4Tool

+(NSMutableArray *)initRC4Key:(NSString *)aKey{
    NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
    NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
    for (int i= 0; i<256; i++) {
        [iS addObject:[NSNumber numberWithInt:i]];
    }
    int j=1;
    for (short i=0; i<256; i++) {
        UniChar c = [aKey characterAtIndex:i%aKey.length];
        [iK addObject:[NSNumber numberWithChar:c]];
    }
    j=0;
    for (int i=0; i<256; i++) {
        int is = [[iS objectAtIndex:i] intValue];
        UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
        j = (j + is + ik)%256;
        NSNumber *temp = [iS objectAtIndex:i];
        [iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
        [iS replaceObjectAtIndex:j withObject:temp];
    }
    
    return iS;
}


+(Byte *)EncodeRC4WithByte:(Byte *)input len:(NSInteger)len Key:(NSArray*)aKey
{
    NSMutableArray *Key = [NSMutableArray array];
    [Key setArray:aKey];
    int x = 0;
    int y = 0;
    int xorIndex;
    
    Byte *result= (Byte*)malloc(len);
    for (short i=0; i<len; i++) {
        x = (x+1) & 0xff;
        y = (([[Key objectAtIndex:x] intValue] & 0xff) + y) & 0xff;
        NSNumber *tmp = [Key objectAtIndex:x];
        [Key replaceObjectAtIndex:x withObject:[Key objectAtIndex:y]];
        [Key replaceObjectAtIndex:y withObject:tmp];
        xorIndex = (([[Key objectAtIndex:x] intValue] & 0xff) + ([[Key objectAtIndex:y] intValue] & 0xff)) & 0xff;
        result[i] = (Byte) (input[i] ^ [Key[xorIndex] intValue]);
//        
//        NSLog(@"x=%d,y=%d,keyX=%d,keyY=%d,index=%d",x,y,[[Key objectAtIndex:x] intValue],[[Key objectAtIndex:y] intValue],xorIndex);
        
    }
    return result;
}


@end
