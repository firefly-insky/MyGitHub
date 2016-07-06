//
//  FJFNetWorkManager.m
//  FJFCollector
//
//  Created by FJF on 16/7/6.
//  Copyright © 2016年 sonasona. All rights reserved.
//

#import "FJFNetWorkManager.h"



#define TIMEOUT 30

@interface FJFNetWorkManager()<NSURLSessionDelegate>

@end

@implementation FJFNetWorkManager
single_implementation(FJFNetWorkManager)

#pragma mark - NSURLSession
-(void)sessionGETWithRequestUrl:(NSString *)url
                         params:(NSMutableDictionary *)params
                    complection:(void (^)(id))complectoinBlock{

    [self sessionRequestWithUrl:url params:params method:requestMethod_GET complection:^(id result) {
        
    }];

}

-(void)sessoinPOSTWithRequestUrl:(NSString *)url
                          params:(NSMutableDictionary *)params
                     complection:(void (^)(id))complectionBlock{

    
}

-(void)sessionRequestWithUrl:(NSString *)url
                      params:(id)params
                      method:(requstMetnod)method
                 complection:(void(^)(id result))complectionBlock{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]];
    
    NSString *bodyString=nil;
    if(params){
        bodyString = [self getBodyStringWithDict:params];
    }
    
    if(method == requestMethod_GET){
        
        NSString *urlString = [NSString stringWithFormat:@"%@?%@",url,bodyString];
        request.URL = [NSURL URLWithString:urlString];
        request.HTTPMethod = @"GET";
        
    }else{
        NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = bodyData;
        request.HTTPMethod = @"POST";
    }
    request.timeoutInterval =TIMEOUT;
    
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    //创建任务
    NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error!=nil){
            NSLog(@"request fail! ");
        }else{
            if(complectionBlock){
                complectionBlock(data);
            }
        }
    }];
    //执行任务
    [task resume];
}


#pragma mark - NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    //AFNetworking中的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
         NSURLSessionAuthChallengeUseCredential：使用指定的证书   
         NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
         */
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
    
}
// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"didReceiveResponse");
    completionHandler(NSURLSessionResponseAllow);
}
// 接收到服务器返回的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
}
// 请求完毕
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
}


#pragma mark - AFNetworking
-(void)AFNetRequestWithUrl:(NSString *)urlString
                    method:(requstMetnod)method
                    params:(id)params
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    
    switch (method) {
        case requestMethod_GET:{
            [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
             
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"request success!");
                if(success){
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"request fail!");
                if(failure){
                    failure(error);
                }
            }];
            break;
        }
        case requestMethod_POST:{
            [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"request success!");
                if(success){
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"request fail!");
                if(failure){
                    failure(error);
                }
            }];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - tool
-(NSString *)getBodyStringWithDict:(NSDictionary *)bodyDict{
    NSString  *bodyString=@"";
    for (NSString *dictStr in bodyDict) {
        bodyString=[bodyString stringByAppendingString:dictStr];
        bodyString=[bodyString stringByAppendingString:@"="];
        NSString *param;
        param=[NSString stringWithFormat:@"%@",[bodyDict objectForKey:dictStr]];
        bodyString=[bodyString stringByAppendingString:param];
        bodyString=[bodyString stringByAppendingString:@"&"];
    }
    bodyString=[bodyString stringByReplacingCharactersInRange:NSMakeRange(bodyString.length-1, 1) withString:@""];
    return bodyString;
}


@end
