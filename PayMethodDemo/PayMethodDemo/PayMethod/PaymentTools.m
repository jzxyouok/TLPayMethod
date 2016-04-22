//
//  PaymentTools.m
//  Consumer
//
//  Created by Magic-Beans on 15/7/2.
//  Copyright (c) 2015年 MagicBeans. All rights reserved.
//

#import "PaymentTools.h"
// 支付宝支付相关
#import <AlipaySDK/AlipaySDK.h>
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "Order.h"
// 微信支付
#import "payRequsestHandler.h"
#import "WXUtil.h"
#import "CommonUtil.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "PartnerConfig.h"

@implementation PaymentTools

+ (instancetype)sharedTools {
    
    static PaymentTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[PaymentTools alloc] init];
    });
    return tools;
}

#pragma mark   ==============点击订单支付行为==============
#pragma mark   =========选中商品调用支付宝极简支付===========
- (void)showAlipayPayOrderCompletionBlock:(void (^)(BOOL))success
{
    if (![PartnerID length]) {
        NSLog(@"缺少支付宝合作身份者id");return;
    }
    if (![SellerID length]) {
        NSLog(@"缺少支付宝收款账号");return;
    }
    if (![MD5_KEY length]) {
        NSLog(@"缺少安全校验码（MD5）密钥");return;
    }
    if (![PartnerPrivKey length]) {
        NSLog(@"缺少商户私钥");return;
    }
    if (![AlipayPubKey length]) {
        NSLog(@"缺少支付宝公钥");return;
    }
    if (![AlipayPubKey length]) {
        NSLog(@"缺少应用包名");return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息拼接成字符串
    NSString* orderSpec = [self getOrderInfo];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer  = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:AppScheme
                                    callback:^(NSDictionary *resultDic) {
                                        //结果处理
                                        if (resultDic)
                                        {
                                            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"])
                                            {
                                                //交易成功
                                                id<DataVerifier> verifier;
                                                verifier = CreateRSADataVerifier(AlipayPubKey);
                                                NSString *result = resultDic[@"result"];
                                                //
                                                // 签名类型
                                                //
                                                NSRange range = [result rangeOfString:@"&sign_type=\""];
                                                if (range.location == NSNotFound) {
                                                    return;
                                                }
                                                NSString *resultString = [result substringToIndex:range.location];
                                                
                                                range.location += range.length;
                                                range.length   = [result length] - range.location;
                                                NSRange range2 = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:range];
                                                if (range2.location == NSNotFound) {
                                                    return;
                                                }
                                                range.length = range2.location - range.location;
                                                if (range.length <= 0) {
                                                    return;
                                                }
                                                
                                                //
                                                // 签名字符串
                                                //
                                                range.location = range2.location;
                                                range.length = [result length] - range.location;
                                                range = [result rangeOfString:@"sign=\"" options:NSCaseInsensitiveSearch range:range];
                                                if (range.location == NSNotFound) {
                                                    return;
                                                }
                                                range.location += range.length;
                                                range.length = [result length] - range.location;
                                                range2 = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:range];
                                                if (range2.location == NSNotFound) {
                                                    return;
                                                }
                                                range.length = range2.location - range.location;
                                                if (range.length <= 0) {
                                                    return;
                                                }
                                                NSString *signString = [result substringWithRange:range];
                                                
                                                /*
                                                 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
                                                 */
                                                
                                                if ([verifier verifyString:resultString withSign:signString])
                                                {
                                                    success(YES);
                                                }
                                            }
                                            else
                                            {
                                                success(NO);
                                            }
                                        }
                                        else
                                        {
                                            success(NO);
                                        }
                                    }];
    }
}
/**
 *  获得订单详情
 *
 *  @return 按照支付宝的规则 拼接字符串
 */
-(NSString*)getOrderInfo
{
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order             = [[Order alloc] init];
    order.partner            = PartnerID;
    order.seller             = SellerID;
    order.tradeNO            = self.orderID;//订单ID（由商家自行制定）
    order.productName        = self.productName;//商品标题
    order.productDescription = self.productDescription;//商品描述
    order.amount             = @"0.01";//商品价格
    order.notifyURL          = self.notifyURL; //回调URL
    
    order.service            = @"mobile.securitypay.pay";
    order.paymentType        = @"1";
    order.inputCharset       = @"utf-8";
    order.itBPay             = @"30m";
    order.showUrl            = @"m.alipay.com";;
    
    return [order description];
}
/**
 *  rsa加密
 *
 *  @param orderInfo
 *
 *  @return
 */

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
#pragma mark - 微信支付 -----------------------------------
- (void) showWechatPayOrderCompletionBlock:(void (^)(BOOL))success
{
    if (![WX_APP_ID length]) {
        NSLog(@"缺少微信支付APP_ID");return;
    }
    if (![WX_APP_SECRET length]) {
        NSLog(@"缺少微信支付APP_SECRET");return;
    }
    if (![WX_MCH_ID length]) {
        NSLog(@"缺少微信商户号");return;
    }
    if (![WX_PARTNER_ID length]) {
        NSLog(@"缺少微信商户API密钥");return;
    }
    
    int price = (int)([_orderPrice floatValue] * 100);
    //[NSString stringWithFormat:@"%@%@",BASE_URL,WEChat_NotifyURL]
    
    payRequsestHandler *mPayRequsestHandler = [[payRequsestHandler alloc] init:WX_APP_ID mch_id:WX_MCH_ID];
    [mPayRequsestHandler setKey:WX_PARTNER_ID];
    NSDictionary *prePayDic = [mPayRequsestHandler sendPay_demoOrderName:_productName
                                                           AndOrderPrice:[NSString stringWithFormat:@"%d",price]
                                                               NotifyURL:_notifyURL
                                                        Spbill_create_ip:[CommonUtil getIPAddress:YES]
                                                                 OrderID:_orderID
                                                                  Attach:@"WeChatPay"];
    if(prePayDic != nil)
    {
        NSMutableString *stamp  = [prePayDic objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [prePayDic objectForKey:@"appid"];
        req.partnerId           = [prePayDic objectForKey:@"partnerid"];
        req.prepayId            = [prePayDic objectForKey:@"prepayid"];
        req.nonceStr            = [prePayDic objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [prePayDic objectForKey:@"package"];
        req.sign                = [prePayDic objectForKey:@"sign"];
        
        success([WXApi sendReq:req]);
    }
}
@end
