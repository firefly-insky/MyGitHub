//
//  FJFRequestTask.m
//  FJFCachePlayer
//
//  Created by FJF on 16/7/27.
//  Copyright © 2016年 杭州索那声美科技有限公司. All rights reserved.
//

#import "FJFRequestTask.h"
#import "FJFFileHandle.h"
#import "NSURL+FJFScheme.h"
#import "NSData+FJFData.h"
//请求超时
#define RequestTimeout 10.0

@interface FJFRequestTask ()<NSURLSessionDataDelegate>{
    NSMutableData *_tempData;
}

@property(nonatomic, strong)NSURLSession *session; //会话
@property(nonatomic, strong)NSURLSessionDataTask *task; //下载任务

@end

@implementation FJFRequestTask

-(instancetype)init{
    if(self = [super init]){
        [FJFFileHandle createTempFile];
        _tempData = [NSMutableData data];
    }
    return self;
}


-(void)startTask{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.requestURL originalSchemeURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RequestTimeout];
    if (self.requestOffset > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld", self.requestOffset, self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

-(void)setCancelTask:(BOOL)cancelTask{
   _cancelTask = cancelTask;
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    if(self.cancelTask){
        NSLog(@"下载取消");
        return;
    }
    completionHandler(NSURLSessionResponseAllow);
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString * fileLength = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
    self.totalLength = [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidReceiveResponse)]) {
        [self.delegate requestTaskDidReceiveResponse];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    if(self.cancelTask){
        NSLog(@"下载取消");
        return;
    }
    /*添加解密算法*/
    
    NSMutableData *responseData = [NSMutableData dataWithData:_tempData];
    [responseData appendData:data];
    
    NSInteger count = responseData.length/256;
    if(count != 0)
        [_tempData setData:[responseData subdataWithRange:NSMakeRange(count*256, responseData.length - count*256)]];
    

    NSData *encodeData = [responseData subdataWithRange:NSMakeRange(0, count*256)];
    [FJFFileHandle writeTempFileData:[encodeData RC4Decode]];
    self.cacheLength += data.length;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidUpdateCache)]) {
        [self.delegate requestTaskDidUpdateCache];
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(self.cancelTask){
        NSLog(@"下载取消");
        return;
    }
    if(error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidFailWithError:)]) {
            [self.delegate requestTaskDidFailWithError:error];
            return;
        }
    }
    
            //允许缓存
            if(self.cache){
                //先加密RC4加密在缓存
                
                [FJFFileHandle cacheTempFileWithFileName:[NSString fileNameWithUrl:self.requestURL]];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidFinishLoadingWithCache:)]) {
                [self.delegate requestTaskDidFinishLoadingWithCache:self.cancelTask];
            }
}

@end
