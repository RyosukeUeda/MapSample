//
//  MKSGenreRecord.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSGenreRecord.h"
#import "NSString+MKSCustom.h"

@implementation MKSGenreRecord

#pragma mark Defines
NSString *const kMKSGenreCodeFirst = @"code1";

NSString *const kMKSGenreCodeSecond = @"code2";

NSString *const kMKSGenreCodeThird = @"code3";

NSString *const kMKSGenreNameFirst = @"name1";

NSString *const kMKSGenreNameSecond = @"name2";

NSString *const kMKSGenreNameThird = @"name3";

#pragma mark Methods
+ (MKSGenreRecord *)sharedInstance {
    static MKSGenreRecord *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MKSGenreRecord alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)findAllGenre {
    return [Genre MR_findAll];
}

- (void)recordGenreList:(void (^)(BOOL contextDidSave, NSError *_Nullable error))comletion {
    // YahooのCSVをまじかるレコードへ
    NSString *dataUrlStr = [[NSBundle mainBundle] pathForResource:@"genre" ofType:@"csv"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dataUrlStr]) {
        // 存在する場合、読み込み
        NSString *csvStr = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:dataUrlStr]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
        if (csvStr) {
            // 取得成功 → コンバート
            NSArray *array = [csvStr arrayFromCSVString];

            // 入れる前に消しておく
            [Genre MR_truncateAll];

            // エンティティ
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            for (NSArray *obj in array) {
                if (obj.count == 6) {
                    Genre *genre = [Genre MR_createEntity];
                    // 値をSet
                    genre.code1 = [obj objectAtIndex:0];
                    genre.code2 = [obj objectAtIndex:1];
                    genre.code3 = [obj objectAtIndex:2];
                    genre.name1 = [obj objectAtIndex:3];
                    genre.name2 = [obj objectAtIndex:4];
                    genre.name3 = [obj objectAtIndex:5];
                }
            }
            [context MR_saveToPersistentStoreWithCompletion:comletion];
        }
    }
}

@end
