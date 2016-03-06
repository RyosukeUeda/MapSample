//
//  MKSHomeViewController.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <MBProgressHUD.h>
#import "MKSGenreRecord.h"
#import "MKSHomeViewController.h"
#import "MKSPickerViewController.h"
#import "MKSYahooMapViewController.h"

@interface MKSHomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *genreq1Button;
@property (weak, nonatomic) IBOutlet UIButton *genre2Button;
@property (weak, nonatomic) IBOutlet UILabel *genre1Label;
@property (weak, nonatomic) IBOutlet UILabel *genre2Label;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MKSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // データ作成
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MKSGenreRecord sharedInstance] recordGenreList:^(BOOL contextDidSave, NSError *_Nullable error) {
        [hud hide:YES];
        [_genreq1Button setEnabled:YES];
        [_genre2Button setEnabled:YES];
        [_searchButton setEnabled:YES];
    }];
}

- (IBAction)genre1ButtonTaped:(id)sender {
    NSArray *array = [Genre MR_findAll];
    NSMutableArray *dispArray = [NSMutableArray array];
    for (Genre *genre in array) {
        if (![dispArray containsObject:genre.name2]) {
            [dispArray addObject:genre.name2];
        }
    }
    MKSPickerViewController *picker =
        [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MKSPickerViewController class])];
    picker.pickerArray = dispArray;
    picker.valueDecided = [^(NSString *decide) {
        [_genre1Label setText:decide];
    } copy];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)genre2ButtonTap:(id)sender {
    NSArray *genres =
        [Genre MR_findByAttribute:kMKSGenreNameSecond withValue:[_genre1Label text] andOrderBy:nil ascending:YES];
    NSMutableArray *dispArray = [NSMutableArray array];
    for (Genre *genre in genres) {
        if (![dispArray containsObject:genre.name3]) {
            [dispArray addObject:genre.name3];
        }
    }
    MKSPickerViewController *picker =
        [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MKSPickerViewController class])];
    picker.pickerArray = dispArray;
    picker.valueDecided = [^(NSString *decide) {
        [_genre2Label setText:decide];
    } copy];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kMKSSegueHomeToYahooMap]) {
        // YahooMap画面へ繊維するイベントをハック
        MKSYahooMapViewController *next = [segue destinationViewController];
        NSArray *genres =
            [Genre MR_findByAttribute:kMKSGenreNameThird withValue:[_genre2Label text] andOrderBy:nil ascending:YES];
        next.facilityId = ((Genre *)[genres firstObject]).code3;
    }
}

@end
