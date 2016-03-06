//
//  MKSYahooMapAPIConnecter.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSFacilityModel.h"
#import "MKSUserDefault.h"
#import "MKSYahooMapAPIConnecter.h"

@implementation MKSYahooMapAPIConnecter

+ (MKSYahooMapAPIConnecter *)sharedInstance {
    static MKSYahooMapAPIConnecter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MKSYahooMapAPIConnecter alloc] init];
    });
    return sharedInstance;
}

- (void)getFacilityDatasWithFacilityId:(NSString *)facilityId
                            coordinate:(CLLocationCoordinate2D)coodinate
                               success:(success)success
                               failure:(failure)failure {
    NSMutableString *url =
        [[NSMutableString alloc] initWithString:@"http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch?"];
    // AppId
    [url appendFormat:@"appid=%@", kYahooMapAppId];
    // 施設情報ID
    [url appendFormat:@"&gc=%@", facilityId];
    //    // Lat, Lon
    [url appendFormat:@"&lat=%f&lon=%f", coodinate.latitude, coodinate.longitude];
    //    // 距離
    [url appendFormat:@"&dist=%ld",
                      (long)[[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchDistance]];
    //    // ソート
    [url appendFormat:@"&sort=%@", @"geo"];
    //    // フォーマット
    [url appendFormat:@"&output=%@", @"json"];
    //    [url appendFormat:@"&device=%@", @"mobile"];
    DLog(@"Access URL : %@", url);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (responseObject) {
                DLog(@"%@", responseObject);
            }
            NSMutableArray<MKSFacilityModel *> *ret = [@[] mutableCopy];
            NSArray *feature = [responseObject objectForKey:@"Feature"];
            if (feature && [feature count] > 0) {
                for (NSDictionary *dict in feature) {
                    NSString *name = [dict objectForKey:@"Name"];
                    NSDictionary *geo = [dict objectForKey:@"Geometry"];
                    if (geo && ![geo isKindOfClass:[NSNull class]]) {
                        NSString *coodinates = [geo objectForKey:@"Coordinates"];
                        NSArray *split = [coodinates componentsSeparatedByString:@","];
                        if (split.count == 2) {
                            MKSFacilityModel *model = [[MKSFacilityModel alloc] init];
                            model.name = name;
                            model.coorinate = CLLocationCoordinate2DMake([split[1] floatValue], [split[0] floatValue]);
                            [ret addObject:model];
                        }
                    }
                }
            }
            if (success) {
                success(ret);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
