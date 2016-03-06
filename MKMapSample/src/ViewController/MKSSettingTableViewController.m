//
//  MKSSettingTableViewController.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSPickerViewController.h"
#import "MKSSettingTableViewController.h"
#import "MKSUserDefault.h"

#pragma mark CustomCell
@interface MKSSettingCell : UITableViewCell

extern NSString *const kSettingCellIdentifier;

@property (weak, nonatomic) IBOutlet UILabel *settingCellLabel;

@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation MKSSettingCell

NSString *const kSettingCellIdentifier = @"settingCell";

@end

@interface MKSSettingTableViewController ()

@property NSArray *settingArray;

@end

@implementation MKSSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // TableView設定
    self.tableView.delegate = self;

    _settingArray = @[ @"施設検索距離 (km)", @"移動手段" ];
}

#pragma mark Events
- (void)settingButtonTap:(id)sender {
    // tagにはindexPath.rowが設定されている。
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0: {
            NSInteger settingVal = [[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchDistance];

            MKSPickerViewController *pickerController = [self.storyboard
                instantiateViewControllerWithIdentifier:NSStringFromClass([MKSPickerViewController class])];
            pickerController.currentValue = [NSString stringWithFormat:@"%ld", (long)settingVal];
            pickerController.pickerArray = @[ @"1", @"3", @"10", @"30" ];

            pickerController.changedBlock = ^(NSString *val) {
                NSInteger set = [val integerValue];
                [[MKSUserDefault sharedInstance] saveIntegerValue:kMKSUserDefaultsKeySearchDistance value:set];
                // 表示
                [button setTitle:val forState:UIControlStateNormal];
            };
            pickerController.valueDecided = ^(NSString *val) {
                NSInteger set = [val integerValue];
                [[MKSUserDefault sharedInstance] saveIntegerValue:kMKSUserDefaultsKeySearchDistance value:set];
                // 表示
                [button setTitle:val forState:UIControlStateNormal];
            };
            [self presentViewController:pickerController animated:YES completion:nil];
        } break;
        case 1: {
            NSInteger settingVal = [[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchTraffic];

            MKSPickerViewController *pickerController = [self.storyboard
                instantiateViewControllerWithIdentifier:NSStringFromClass([MKSPickerViewController class])];
            pickerController.pickerArray = @[ @"車", @"徒歩" ];
            pickerController.currentValue = [pickerController.pickerArray objectAtIndex:settingVal];

            pickerController.changedBlock = ^(NSString *val) {
                NSInteger set = 0;
                if ([val isEqualToString:@"車"]) {
                    set = 0;
                } else {
                    set = 1;
                }
                [[MKSUserDefault sharedInstance] saveIntegerValue:kMKSUserDefaultsKeySearchTraffic value:set];
                // 表示
                [button setTitle:val forState:UIControlStateNormal];
            };
            pickerController.valueDecided = ^(NSString *val) {
                NSInteger set = [val integerValue];
                [[MKSUserDefault sharedInstance] saveIntegerValue:kMKSUserDefaultsKeySearchTraffic value:set];
                // 表示
                [button setTitle:val forState:UIControlStateNormal];
            };
            [self presentViewController:pickerController animated:YES completion:nil];
        } break;

        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_settingArray count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKSSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellIdentifier forIndexPath:indexPath];

    if (cell && indexPath.row >= 0 && indexPath.row < _settingArray.count) {
        [cell.settingCellLabel setText:[_settingArray objectAtIndex:indexPath.row]];
        [cell.settingButton addTarget:self
                               action:@selector(settingButtonTap:)
                     forControlEvents:UIControlEventTouchUpInside];
        [cell.settingButton setTag:indexPath.row];

        // 設定値を設定する
        switch (indexPath.row) {
            case 0: {
                // 距離
                NSInteger settingVal = [[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchDistance];
                NSString *text = [NSString stringWithFormat:@"%ld", (long)settingVal];
                [cell.settingButton setTitle:text forState:UIControlStateNormal];
            } break;
            case 1: {
                // 移動手段
                NSInteger settingVal = [[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchTraffic];
                NSString *text = @"車";
                if (settingVal == 0) {
                    text = @"車";
                } else {
                    text = @"徒歩";
                }
                [cell.settingButton setTitle:text forState:UIControlStateNormal];
            } break;
            default:
                break;
        }
    }

    return cell;
}

@end
