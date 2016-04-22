//
//  PartnerConfig.h
//  PayMethod
//
//  Created by Ted Liu on 16/1/20.
//  Copyright © 2016年 Ted Liu. All rights reserved.
//

#ifndef PartnerConfig_h
#define PartnerConfig_h

#pragma mark - 支付宝支付
/**
 *  合作身份者id，以2088开头的16位纯数字
 */
#define PartnerID @""
/**
 *  收款支付宝账号
 */
#define SellerID @""
/**
 *  安全校验码（MD5）密钥，以数字和字母组成的32位字符
 */
#define MD5_KEY @""
/**
 *  商户私钥，自助生成
 */
#define PartnerPrivKey @""
/**
 *  支付宝公钥
 */
#define AlipayPubKey   @""
/**
 *  应用包名
 */
#define AppScheme      @""


#pragma mark - 微信支付
/**
 *  微信支付APP_ID
 */
#define WX_APP_ID          @""
/**
 *  微信支付APP_SECRET
 */
#define WX_APP_SECRET      @""
/**
 *  商户号，填写商户对应参数
 */
#define WX_MCH_ID          @""
/**
 *  商户API密钥，填写相应参数
 */
#define WX_PARTNER_ID      @""

#endif /* PartnerConfig_h */
