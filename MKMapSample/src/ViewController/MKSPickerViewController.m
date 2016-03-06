//
//  MKSPickerViewController.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSPickerViewController.h"

@interface MKSPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation MKSPickerViewController {
    NSInteger currentRow;
}

#pragma mark ViewController LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    // 初期値
    NSInteger currentIndex = 0;
    if (_currentValue && [_pickerArray containsObject:_currentValue]) {
        currentIndex = [_pickerArray indexOfObject:_currentValue];
    }
    [_pickerView selectRow:currentIndex inComponent:0 animated:NO];
    currentRow = currentIndex;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverCurrentContext;
}

- (UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCrossDissolve;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentRow = row;
    if (_changedBlock) {
        _changedBlock([_pickerArray objectAtIndex:currentRow]);
    }
}

#pragma mark Segue
- (IBAction)dismissButtonTap:(id)sender {
    __weak MKSPickerViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if (weakSelf.valueDecided) {
                                     weakSelf.valueDecided([_pickerArray objectAtIndex:currentRow]);
                                 }
                             }];
}

@end
