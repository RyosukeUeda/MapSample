//
//  MKSYahooMapAPIConnecter.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MKSNetworkConnecter.h"

@interface MKSYahooMapAPIConnecter : MKSNetworkConnecter

+ (MKSYahooMapAPIConnecter *)sharedInstance;

/**
 *  YahooMapAPIを使用したアレ
 *
 *  @param facilityId 検索ID
 *  @param coodinate  現在値
 *  @param success    成功
 *  @param failure    失敗
 */
- (void)getFacilityDatasWithFacilityId:(NSString *)facilityId coordinate:(CLLocationCoordinate2D)coodinate success:(success)success failure:(failure)failure;

@end
