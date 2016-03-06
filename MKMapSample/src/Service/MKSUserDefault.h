//
//  MKSUserDefault.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKSUserDefault : NSObject

#pragma mark KeyConstants
extern NSString *const kMKSUserDefaultsKeySearchDistance;

extern NSString *const kMKSUserDefaultsKeySearchTraffic;

#pragma mark Methods
+ (MKSUserDefault *)sharedInstance;

- (void)setDefaultParam:(NSDictionary *)defaultParams;

- (NSInteger)integerValue:(NSString *)key;

- (void)saveIntegerValue:(NSString *)key value:(NSInteger)value;

@end
