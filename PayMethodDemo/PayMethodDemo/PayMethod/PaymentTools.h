//
//  PaymentTools.h
//  A Plus
//
//  Created by Ted Liu on 16/1/19.
//  Copyright (c) 2016年 Ted Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentTools : NSObject

+ (instancetype) sharedTools;
/**
 *  调起支付宝支付block
 */
- (void) showAlipayPayOrderCompletionBlock:(void (^)(BOOL resultDic)) success;
/**
 *  调起微信支付block
 */
- (void) showWechatPayOrderCompletionBlock:(void (^)(BOOL resultDic)) success;
/**
 *  商品ID
 */
@property (nonatomic, copy) NSString* orderID;
/**
 *  商品价格
 */
@property (nonatomic ,copy) NSString* orderPrice;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString* productName;
/**
 *  商品描述
 */
@property (nonatomic, copy) NSString* productDescription;
/**
 *  支付成功回调地址
 */
@property (nonatomic, copy) NSString* notifyURL;

@end
