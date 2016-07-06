//
//  ViewController.m
//  FJFCollector
//
//  Created by sonasona on 16/6/27.
//  Copyright © 2016年 sonasona. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "FJFQRCode.h"
#import <AFNetworking.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self beginAnimation];
    
    [[FJFQRCode sharedFJFQRCode] setRectInterest:self.backView.frame];
    
    [[FJFQRCode sharedFJFQRCode] scanQRCodeWithinView:self.view isDrawQRCodeFrame:YES scanResult:^(NSArray *array) {
        NSArray *scanresult = array;
        [[FJFQRCode sharedFJFQRCode] stopScan];
        [self dismissViewControllerAnimated:YES completion:^{
            if(self.QRCodeResultBlock)
               self.QRCodeResultBlock(scanresult);
        }];
    }];
}

-(void)beginAnimation{
    
    self.bottomCon.constant = self.backView.frame.size.height;
    [self.view layoutIfNeeded];
    self.bottomCon.constant = -self.backView.frame.size.height;
    [UIView animateWithDuration:2.0 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [self.view layoutIfNeeded];
    }];
}


@end
