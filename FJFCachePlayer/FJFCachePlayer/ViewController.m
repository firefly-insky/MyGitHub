//
//  ViewController.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "FJFPlayer.h"

@interface ViewController ()
@property(nonatomic,strong)FJFPlayer  *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url =@"http://sona-vod-output-test.oss-cn-hangzhou.aliyuncs.com/xpqh_music%2F04c0bffe8c943f9bb8aff2308ec34f6a?OSSAccessKeyId=XPhGVIISlXeMeoTL&Expires=1469973991&Signature=n3YOyNDbcgQ71b27dEG2bPP2Eag%3D";
    NSString *url1 = @"http://mr7.doubanio.com/3fd082ae3370d22e48e300ab1d5d6590/1/fm/song/p190415_128k.mp4";
    self.player = [[FJFPlayer alloc] initWithUrl:[NSURL URLWithString:url]];
}

- (IBAction)play:(id)sender {
    
    [self.player play];
}
- (IBAction)clean:(id)sender {
    [FJFPlayer clearCache];
}

@end
