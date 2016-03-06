//
//  MKSGenreRecord.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Genre+CoreDataProperties.h"

@interface MKSGenreRecord : NSObject

#pragma mark Defines
extern NSString *const kMKSGenreCodeFirst;

extern NSString *const kMKSGenreCodeSecond;

extern NSString *const kMKSGenreCodeThird;

extern NSString *const kMKSGenreNameFirst;

extern NSString *const kMKSGenreNameSecond;

extern NSString *const kMKSGenreNameThird;

#pragma mark Methods
+ (MKSGenreRecord *)sharedInstance;

- (NSArray *)findAllGenre;

- (void)recordGenreList:(void (^)(BOOL contextDidSave, NSError *_Nullable error))comletion;

@end
