//
//  FJFQRCode.h
//  FJFQRCode
//
//  Created by FJF on 16/7/5.
//  Copyright © 2016年 FJF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface FJFQRCode : NSObject

single_interface(FJFQRCode)

//扫描结果返回，可能重一张图中扫描到多张二维码
@property(nonatomic,copy)void (^scanQRCodeResultBlock)(NSArray *resultArray);

-(void)setRectInterest:(CGRect)react;

-(void)stopScan;

-(void)scanQRCodeWithinView:(UIView *)inView isDrawQRCodeFrame:(BOOL)isDrawQRCodeFrame scanResult:(void(^)(NSArray *array))scanResult;

@end
