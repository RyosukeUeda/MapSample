//
//  MKSAnnotationSubView.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSFacilityModel.h"

@interface MKSAnnotationSubView : UIButton

@property MKSFacilityModel *model;

+ (instancetype)view;

@end
