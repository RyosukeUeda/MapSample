//
//  NSString+MKSCustom.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "NSString+MKSCustom.h"

@implementation NSString (MKSCustom)

- (NSArray *)arrayFromCSVString {
    NSMutableArray *retArray = [NSMutableArray array];
    // まず行で分割
    NSArray *splitArray = [self componentsSeparatedByString:@"\r\n"];
    for (NSString *split in splitArray) {
        // カンマで分割 → Add
        NSArray *array = [split componentsSeparatedByString:@","];
        [retArray addObject:array];
    }
    return retArray;
}

@end
