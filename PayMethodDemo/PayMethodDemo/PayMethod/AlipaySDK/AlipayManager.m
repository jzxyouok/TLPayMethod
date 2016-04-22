//
//  AlipayManager.m
//  PayMethod
//
//  Created by Ted Liu on 16/1/20.
//  Copyright © 2016年 Ted Liu. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayManager alloc] init];
    });
    return instance;
}

- (void)alipayProcessOrderWithPaymentResult:(NSURL *)url
{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {

                                                  }];

        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {

                                         }];
    }
    else if ([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url
                                      standbyCallback:^(NSDictionary *resultDic) {

                                      }];
    }
}
@end
