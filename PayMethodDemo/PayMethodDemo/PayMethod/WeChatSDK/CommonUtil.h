//
//  CommonUtil.h
//  EHouse
//
//  Created by MagicBeans2 on 15/3/26.
//  Copyright (c) 2015年 Magic Beans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject
+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;
@end
