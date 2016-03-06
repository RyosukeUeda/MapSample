//
//  MKSMessageOverlayView.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKSMessageOverlayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *messageView;

+ (instancetype)view;

+ (instancetype)view:(NSString *)message;

@end
