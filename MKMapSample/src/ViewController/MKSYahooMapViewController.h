//
//  MKSYahooMapViewController.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <YMapKit/YMapKit.h>
#import "MKSCommonViewController.h"

@interface MKSYahooMapViewController : MKSCommonViewController <CLLocationManagerDelegate, YMKMapViewDelegate,
                                                                YMKRouteOverlayDelegate, YMKNaviControllerDelegate>

@property NSString *facilityId;

@end
