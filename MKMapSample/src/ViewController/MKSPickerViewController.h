//
//  MKSPickerViewController.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSCommonViewController.h"

@interface MKSPickerViewController : MKSCommonViewController <UIPickerViewDataSource, UIPickerViewDelegate>

typedef void (^onValueChanged)(NSString *value);

typedef void (^onValueDecided)(NSString *value);

@property NSArray<NSString *> *pickerArray;

@property NSString *currentValue;

@property (copy) onValueChanged changedBlock;

@property (copy) onValueDecided valueDecided;

@end
