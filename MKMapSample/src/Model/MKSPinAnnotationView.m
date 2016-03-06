//
//  MKSPinAnnotationView.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSPinAnnotationView.h"

@implementation MKSPinAnnotationView

@synthesize coordinate;
@synthesize annotationTitle;
@synthesize annotationSubtitle;

//初期化処理
- (id)initWithLocationCoordinate:(CLLocationCoordinate2D)coord
                           title:(NSString *)annTitle
                        subtitle:(NSString *)annSubtitle {
    if (self = [super init]) {
        coordinate.latitude = coord.latitude;
        coordinate.longitude = coord.longitude;
        annotationTitle = annTitle;
        annotationSubtitle = annSubtitle;
    }
    return self;
}

//タイトル
- (NSString *)title {
    return annotationTitle;
}

//サブタイトル
- (NSString *)subtitle {
    return annotationSubtitle;
}

@end

@implementation MKSSelfPinAnnotation

@end

@implementation MKSSearchResultAnnotaion

@end