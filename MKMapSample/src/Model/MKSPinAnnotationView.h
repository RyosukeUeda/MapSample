//
//  MKSPinAnnotationView.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YMapKit/YMapKit.h>
#import "MKSFacilityModel.h"

@interface MKSPinAnnotationView : NSObject <YMKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *annotationTitle;
    NSString *annotationSubtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubtitle;
@property MKSFacilityModel *model;

- (id)initWithLocationCoordinate:(CLLocationCoordinate2D)coord
                           title:(NSString *)annTitle
                        subtitle:(NSString *)annSubtitle;
- (NSString *)title;
- (NSString *)subtitle;

@end

@interface MKSSelfPinAnnotation : MKSPinAnnotationView

@end

@interface MKSSearchResultAnnotaion : MKSPinAnnotationView

@end
