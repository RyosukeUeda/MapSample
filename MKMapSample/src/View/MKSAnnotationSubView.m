//
//  MKSAnnotationSubView.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSAnnotationSubView.h"

@implementation MKSAnnotationSubView

+ (instancetype)view {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    id view = [nib instantiateWithOwner:self options:nil][0];
    return view;
}

@end
