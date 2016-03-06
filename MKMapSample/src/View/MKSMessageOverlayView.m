//
//  MKSMessageOverlayView.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/06.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MKSMessageOverlayView.h"

@implementation MKSMessageOverlayView

+ (instancetype)view {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    id view = [nib instantiateWithOwner:self options:nil][0];
    return view;
}

+ (instancetype)view:(NSString *)message {
    MKSMessageOverlayView *view = [MKSMessageOverlayView view];
    [view.messageView setText:message];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // 枠を整えておく
    [[self layer] setCornerRadius:3.0f];
    [[self layer] setMasksToBounds:YES];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        // Add
        [self setAlpha:0.0f];
        [UIView animateWithDuration:0.5f
            animations:^{
                [self setAlpha:1.0f];
            }
            completion:^(BOOL finished) {
                // 表示仕切ったら削除
                [UIView animateWithDuration:0.5f
                    animations:^{
                        [self setAlpha:0.0f];
                    }
                    completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
            }];
    } else {
        // Remove
    }
}

@end
