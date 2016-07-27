//
//  FJFPlayer.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "FJFPlayer.h"
#import "FJFFileHandle.h"
#import "FJFResourceLoader.h"
#import "NSURL+FJFScheme.h"
#import "SONARC4Tool.h"

@interface FJFPlayer()<FJFLoaderDelegate>

@property(nonatomic,strong)NSURL *url;

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *currentItem;
@property(nonatomic,strong)FJFResourceLoader *resourceLoader;
@end

@implementation FJFPlayer
-(instancetype)initWithUrl:(NSURL *)url{
     if(self == [super init])
     {
         self.url = url;
         [self reloadCurrentItem];
     }
    return self;
}

-(void)reloadCurrentItem{
    //获取本地缓存
    NSString *cachePath = [FJFFileHandle cacheFileExistsWithUrl:self.url];
    if(cachePath){//有缓存
        NSURL *playUrl = [NSURL fileURLWithPath:cachePath];

        NSMutableData *musicData = [NSMutableData dataWithContentsOfFile:cachePath];
    
//        
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
        [musicData writeToFile:cachePath atomically:YES];
        
        
        self.currentItem = [AVPlayerItem playerItemWithURL:playUrl];
        NSLog(@"****播放缓存文件****");
    }else{//没有缓存
        self.resourceLoader = [[FJFResourceLoader alloc] init];
        self.resourceLoader.delegate = self;
        
        AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[self.url customSchemeURL] options:nil];
        [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
        self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
        NSLog(@"无缓存，播放网络文件");
    }
    
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    [self.player play];
}

#pragma mark - action
-(void)play{
    [self.player play];
}

#pragma mark - FJFLoaderDelegate
-(void)loader:(FJFResourceLoader *)loader cacheProgress:(CGFloat)progress{

}
-(void)loader:(FJFResourceLoader *)loader failLoadingWithError:(NSError *)error{
    
}


@end
