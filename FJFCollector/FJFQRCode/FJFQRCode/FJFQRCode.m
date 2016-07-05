//
//  FJFQRCode.m
//  FJFQRCode
//
//  Created by FJF on 16/7/5.
//  Copyright © 2016年 FJF. All rights reserved.
//

#import "FJFQRCode.h"
#import <AVFoundation/AVFoundation.h>

@interface FJFQRCode()<AVCaptureMetadataOutputObjectsDelegate>


//是否绘制扫描到二维码边框
@property(nonatomic,assign)BOOL isDrawQRCodeFrame;

//摄像头输入
@property(nonatomic,strong)AVCaptureDeviceInput *captureDeviceInput;
//数据输出
@property(nonatomic,strong)AVCaptureMetadataOutput *captureMetadataOutput;
//输入输出会话
@property(nonatomic,strong)AVCaptureSession *captureSession;
//视图视频图层
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation FJFQRCode

static FJFQRCode *_instance;

single_implementation(FJFQRCode)

#pragma mark - 扫描二维码
#pragma mark 开始扫描
-(void)scanQRCodeWithinView:(UIView *)inView isDrawQRCodeFrame:(BOOL)isDrawQRCodeFrame scanResult:(void(^)(NSArray *array))scanResult{
    self.scanQRCodeResultBlock = scanResult;
    self.isDrawQRCodeFrame = isDrawQRCodeFrame;
    
    //添加输入和输出
    if([self.captureSession canAddInput:self.captureDeviceInput] && [self.captureSession canAddOutput:self.captureMetadataOutput]){
        [self.captureSession addInput:self.captureDeviceInput];
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    //设置输出编码类型：一定要放在添加输出之后
    self.captureMetadataOutput.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
    
    self.previewLayer.frame = inView.bounds;
    if(!inView.layer.sublayers || ![inView.layer.sublayers containsObject:self.previewLayer]){
        [inView.layer insertSublayer:_previewLayer atIndex:0];
    }
    
    //启动会话，开始扫描
    [self.captureSession startRunning];
}
#pragma mark 停止扫描
-(void)stopScan{
    [self.captureSession stopRunning];
}

#pragma mark 二维码识别区
-(void)setRectInterest:(CGRect)react{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGFloat x = react.origin.x / bounds.size.width;
    CGFloat y = react.origin.y / bounds.size.height;
    CGFloat w = react.size.width / bounds.size.width;
    CGFloat h = react.size.height / bounds.size.height;
    
    self.captureMetadataOutput.rectOfInterest = CGRectMake(y, x, h, w);
}

#pragma mark 根据图片扫描二维码
+(void)detectorQRCodeImage:(UIImage *)qrImage isDrawQRCodeFrame:(BOOL)isDrawQRCodeFrame result:(void(^)(NSArray *resultStrs, UIImage *resultImage))detectorResult{
    //创建探测器
    CIContext *context = [[CIContext alloc] init];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    //识别图片特征
    CIImage *imageCI = [[CIImage alloc] initWithImage:qrImage];
    
    NSArray *features = [detector featuresInImage:imageCI];
    
    NSMutableArray *qrCodeStrs = [NSMutableArray array];
    
    UIImage *resultImage = qrImage;
    
    for (CIFeature *feature in features) {
        CIQRCodeFeature *qrfeature = (CIQRCodeFeature *)feature;
        [qrCodeStrs addObject:qrfeature.messageString];
        
        if(isDrawQRCodeFrame){
            resultImage = [FJFQRCode drawQRCodeFrameRectWintImage:resultImage feature:qrfeature];
        }
        
    }
    
    if(detectorResult){
        detectorResult(qrCodeStrs,resultImage);
    }
}

#pragma mark 生成二维码 自定义二维码，自定义头像，自定义大小
+(UIImage *)generatorQRCode:(NSString *)contentStr middleImage:(UIImage *)middleImage{
    //创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //回复滤镜的默认值
    [filter setDefaults];
    
    //设置输入数据,之接收NSData
    [filter setValue:[contentStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //设置纠错率
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *outImage = [filter outputImage];
    
    UIImage *image = [FJFQRCode createBigImageWithImage:outImage size:200];
    
    //合成图片
    if(middleImage){
        return [FJFQRCode createSyntheticImageWithBcakImage:image foreImage:middleImage size:40];
    }else{
        return  image;
    }
}




#pragma mark - 生成二维码的附加功能
#pragma mark 给扫描到的二维码添加边框
+(UIImage *)drawQRCodeFrameRectWintImage:(UIImage *)sourceImage feature:(CIQRCodeFeature *)feature{
    CGSize size = sourceImage.size;
    //开启上下文
    UIGraphicsBeginImageContext(size);
    //绘制大图片
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //反转坐标系？？？
     CGContextRef context = (CGContextRef )UIGraphicsGetCurrentContext();
     CGContextScaleCTM(context, 1, -1);
     CGContextTranslateCTM(context, 0, -size.height);
    
    //绘制路径
    CGRect react = feature.bounds;
    
    [[UIColor redColor] setStroke];
    UIBezierPath *patch = [UIBezierPath bezierPathWithRect:react];
    patch.lineWidth = 5;
    [patch stroke];
    
    //取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 生产固定尺寸的Image
+(UIImage *)createBigImageWithImage:(CIImage *)sourceImage size:(CGFloat)size{
    
    CGRect extenRect = CGRectIntegral(sourceImage.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extenRect), size/CGRectGetHeight(extenRect));
    
    //创建bitMap
    CGFloat width = CGRectGetWidth(extenRect)*scale;
    CGFloat Height = CGRectGetHeight(extenRect)*scale;
    CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, Height, 8, 0, spaceRef, 0);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:sourceImage fromRect:extenRect];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);

    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extenRect , bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark 创建一个合成图片
+(UIImage *)createSyntheticImageWithBcakImage:(UIImage *)backImage foreImage:(UIImage *)foreImage size:(CGFloat)imageHW{
    CGSize size = backImage.size;
    UIGraphicsBeginImageContext(size);
    [backImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //绘制中间的头像
    CGFloat w = imageHW;
    CGFloat h = imageHW;
    CGFloat x = (size.width-imageHW)*0.5;
    CGFloat y = (size.height-imageHW)*0.5;
    [foreImage drawInRect:CGRectMake(x,y, w, h)];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  image;
}

#pragma mark 绘制四个角
-(void)drawQRCodeFrameWithLayer:(CALayer *)layer resultMeta:(AVMetadataMachineReadableCodeObject *)resultMeta{
    // 1. 创建形状图层
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.fillColor = [UIColor clearColor].CGColor;
    shapLayer.strokeColor = [UIColor redColor].CGColor;
    shapLayer.lineWidth = 6;
    
    
    // 2. 给形状图层, 设置一个路径
    
    NSArray *corners  = resultMeta.corners;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    for (int i=0;i<corners.count;i++) {
        
        CFDictionaryRef dic = (__bridge CFDictionaryRef)((corners[i]));
        //            corner == 字典
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation(dic, &point);
        
        if (i == 0) {
            [path moveToPoint:point];
        }else {
            [path addLineToPoint:point];
        }
    }
    [path closePath];
    
    shapLayer.path = path.CGPath;
    
    
    // 3. 添加形状图层,到需要展示的图层
    [layer addSublayer:shapLayer];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  扫描到二维码会调用这个方法
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
   
    [self removeQRCodeFrame:_previewLayer];
    
    NSMutableArray *resultStrs = [NSMutableArray array];
    
    for (id meadata in metadataObjects) {
        if([meadata isKindOfClass:[AVMetadataMachineReadableCodeObject class]]){
         AVMetadataMachineReadableCodeObject *resultQRCodeMeta  = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:meadata];
        
            [resultStrs addObject:resultQRCodeMeta.stringValue];
            
            if(_isDrawQRCodeFrame){
                [self drawQRCodeFrameWithLayer:_previewLayer resultMeta:resultQRCodeMeta];
            }
        }
    }
    if(self.scanQRCodeResultBlock){
        self.scanQRCodeResultBlock(resultStrs);
    }
}


//
-(void)removeQRCodeFrame:(CALayer *)layer{
    for (CALayer *sublayer in layer.sublayers) {
        if([sublayer isKindOfClass:[CAShapeLayer class]]){
            [sublayer removeFromSuperlayer];
        }
    }
}



#pragma mark - lazy
-(AVCaptureDeviceInput *)captureDeviceInput{
    if(!_captureDeviceInput){
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error=nil;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if(error){
            NSLog(@"error= %@",error);
        }
    }
    return _captureDeviceInput;
}
-(AVCaptureMetadataOutput *)captureMetadataOutput{
    if(!_captureMetadataOutput){
        _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return  _captureMetadataOutput;
}
-(AVCaptureSession *)captureSession{
    if(!_captureSession){
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}
-(AVCaptureVideoPreviewLayer *)previewLayer{
    if(!_previewLayer){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    
    return  _previewLayer;
}


@end
