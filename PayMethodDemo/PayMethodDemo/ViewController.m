//
//  ViewController.m
//  PayMethodDemo
//
//  Created by Ted Liu on 16/4/13.
//  Copyright © 2016年 Ted Liu. All rights reserved.
//

#import "ViewController.h"
#import "PayMethod.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 *  调用支付宝支付
 *
 *  @param sender
 */
- (IBAction)actionAlipaySubmit:(id)sender {
    
    PaymentTools *payTools = [PaymentTools sharedTools];
    
    payTools.orderID            = [self generateTradeNO];
    payTools.orderPrice         = @"0.01";
    payTools.productName        = @"订单名称";
    payTools.productDescription = @"订单详情";
    payTools.notifyURL          = @"www.baidu.com";
    
    // 记得申明weak，防止重复引用
    [payTools showAlipayPayOrderCompletionBlock:^(BOOL resultDic) {
        resultDic ? NSLog(@"支付宝支付成功") : @"支付宝支付失败";
    }];
}
/**
 *  调用微信支付
 *
 *  @param sender
 */
- (IBAction)actionWechatSubmit:(id)sender {
    
    PaymentTools *payTools = [PaymentTools sharedTools];
    
    payTools.orderID            = [self generateTradeNO];
    payTools.orderPrice         = @"0.01";
    payTools.productName        = @"订单名称";
    payTools.productDescription = @"订单详情";
    payTools.notifyURL          = @"www.baidu.com";
    
    // 记得申明weak，防止重复引用
    [payTools showWechatPayOrderCompletionBlock:^(BOOL resultDic) {
        
    }];
}
/**
 *  产生随机订单号
 *
 *  @return
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
