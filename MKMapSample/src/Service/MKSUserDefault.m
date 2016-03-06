//
//  MKSUserDefault.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSUserDefault.h"

@implementation MKSUserDefault

#pragma mark KeyConstants
NSString *const kMKSUserDefaultsKeySearchDistance = @"searchDistance";

NSString *const kMKSUserDefaultsKeySearchTraffic = @"searchTraffic";

#pragma mark Methods
+ (MKSUserDefault *)sharedInstance {
    static MKSUserDefault *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MKSUserDefault alloc] init];
    });
    return sharedInstance;
}

- (void)setDefaultParam:(NSDictionary *)defaultParams {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:defaultParams];
}

- (NSInteger)integerValue:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

- (void)saveIntegerValue:(NSString *)key value:(NSInteger)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

@end
