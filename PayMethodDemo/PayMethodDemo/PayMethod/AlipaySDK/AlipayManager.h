//
//  AlipayManager.h
//  PayMethod
//
//  Created by Ted Liu on 16/1/20.
//  Copyright © 2016年 Ted Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayManager : NSObject

+ (instancetype)sharedManager;

- (void) alipayProcessOrderWithPaymentResult:(NSURL *) url;

@end
