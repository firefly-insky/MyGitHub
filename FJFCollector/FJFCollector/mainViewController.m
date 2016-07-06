//
//  mainViewController.m
//  FJFCollector
//
//  Created by sonasona on 16/7/6.
//  Copyright © 2016年 sonasona. All rights reserved.
//

#import "mainViewController.h"
#import "FJFQRCode.h"
#import "ViewController.h"

@interface mainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    ViewController *vc=[[ViewController alloc] init];
    
    vc.QRCodeResultBlock = ^(NSArray *array){
        NSString *resulString=nil;
        for (NSString *str in array) {
            resulString = [resulString stringByAppendingString:str];
        }
        self.textView.text = resulString;
    };
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


@end
