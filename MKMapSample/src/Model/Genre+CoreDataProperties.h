//
//  Genre+CoreDataProperties.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Genre.h"

NS_ASSUME_NONNULL_BEGIN

@interface Genre (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code1;
@property (nullable, nonatomic, retain) NSString *code2;
@property (nullable, nonatomic, retain) NSString *code3;
@property (nullable, nonatomic, retain) NSString *name1;
@property (nullable, nonatomic, retain) NSString *name2;
@property (nullable, nonatomic, retain) NSString *name3;

@end

NS_ASSUME_NONNULL_END
