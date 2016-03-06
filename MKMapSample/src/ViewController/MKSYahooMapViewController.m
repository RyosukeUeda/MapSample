//
//  MKSYahooMapViewController.m
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import "MKSAnnotationSubView.h"
#import "MKSFacilityModel.h"
#import "MKSMessageOverlayView.h"
#import "MKSPinAnnotationView.h"
#import "MKSUserDefault.h"
#import "MKSYahooMapAPIConnecter.h"
#import "MKSYahooMapViewController.h"

@interface MKSYahooMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapParentView;

@property YMKMapView *mapView;

// LocationManager
@property CLLocationManager *locationManager;

// 現在地
@property CLLocationCoordinate2D nowLocation;

// Pinリスト
@property NSMutableArray<MKSPinAnnotationView *> *annotationList;

@end

@implementation MKSYahooMapViewController {
    YMKNaviController *naviController;
    UIWindow *arWindow;
    YARKViewController *arViewController;
}

#pragma mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DLog(@"%@", _facilityId);

    _annotationList = [NSMutableArray array];

    _locationManager = [[CLLocationManager alloc] init];

    // 初期化
    _mapView = [[YMKMapView alloc] initWithFrame:_mapParentView.bounds appid:kYahooMapAppId];
    _mapView.delegate = self;
    //地図のタイプを指定 標準の地図を指定
    _mapView.mapType = YMKMapTypeStandard;
    [_mapParentView addSubview:_mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 位置情報取得開始
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 位置情報取得停止
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
}

#pragma mark Event
- (void)arButtonTap:(id)sender {
    // YARKViewControllerインスタンス作成
    arViewController = [[YARKViewController alloc] init];
    // YARKViewControllerをYMKNaviControllerに設定
    [naviController setARKViewController:arViewController];
    // YARKViewController.Viewをwindowに追加
    arWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [arWindow setBackgroundColor:[UIColor clearColor]];
    [arWindow addSubview:arViewController.view];
    [arWindow makeKeyAndVisible];
    //案内処理を開始
    [naviController start];

    UIButton *end = [[UIButton alloc]
        initWithFrame:CGRectMake(arWindow.bounds.size.width - 100, arWindow.bounds.size.height - 44, 100, 44)];
    [end setTitle:@"地図へ" forState:UIControlStateNormal];
    [end addTarget:self action:@selector(mapButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [arWindow addSubview:end];
}

- (void)mapButtonTap:(id)sender {
    // YARKViewControllerをYMKNaviControllerから削除
    [naviController setARKViewController:nil];
    //案内処理を停止
    [naviController stop];
    //カメラ終了
    [arViewController hide];
    //親ビューから削除
    [arViewController.view removeFromSuperview];

    arWindow = nil;  // 保持していたやつを破棄

    // 地図モードで再開
    [naviController start];

    // 右上にARボタン
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"AR"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(arButtonTap:)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark CoreLocation
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        // 使用許可ダイアログを出す
        [_locationManager requestWhenInUseAuthorization];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // 使用NGのため、促す
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"位置情報エラー"
                                                message:@"位置情報の利用許可をお願いします。"
                                         preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways ||
               status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 使用OK
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // クリアしておく
    [_mapView removeAnnotations:_annotationList];
    [_annotationList removeAllObjects];

    // 位置情報を取り出す
    CLLocation *newLocation = [locations lastObject];

    // 地図を表示
    //地図の位置と縮尺を設定
    CLLocationCoordinate2D center = newLocation.coordinate;
    _mapView.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.002, 0.002));

    // 現在地
    _nowLocation = center;

    // 自前のPinを生成
    MKSSelfPinAnnotation *myAnnotation =
        [[MKSSelfPinAnnotation alloc] initWithLocationCoordinate:center title:@"現在地" subtitle:@"ここです。"];
    MKSFacilityModel *model = [[MKSFacilityModel alloc] init];
    model.name = @"現在地";
    model.coorinate = center;
    myAnnotation.model = model;
    [_annotationList addObject:myAnnotation];

    // YahooMapへアクセス
    MKSYahooMapAPIConnecter *connecter = [MKSYahooMapAPIConnecter sharedInstance];
    [connecter getFacilityDatasWithFacilityId:_facilityId
        coordinate:newLocation.coordinate
        success:^(id responce) {
            DLog(@"");
            for (MKSFacilityModel *model in responce) {
                MKSSearchResultAnnotaion *annotation =
                    [[MKSSearchResultAnnotaion alloc] initWithLocationCoordinate:model.coorinate
                                                                           title:model.name
                                                                        subtitle:nil];
                annotation.model = model;
                [_annotationList addObject:annotation];
            }
            [_mapView addAnnotations:_annotationList];
        }
        failure:^(NSError *error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                           message:@"通信エラー"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
}

#pragma YMKMapView
// Annotation追加イベント
- (YMKAnnotationView *)mapView:(YMKMapView *)mapView viewForAnnotation:(MKSPinAnnotationView *)annotation {
    //追加されたAnnotationがMyAnnotationか確認
    if ([annotation isKindOfClass:[MKSSelfPinAnnotation class]]) {
        // YMKPinAnnotationViewを作成
        YMKPinAnnotationView *pin =
            [[YMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SelfPin"];
        //アイコンイメージの変更
        pin.image = [UIImage imageNamed:@"pin_red_s"];
        //アイコンのイメージのどこを基準点にするか設定
        CGPoint centerOffset;
        centerOffset.x = 15;
        centerOffset.y = 15;
        [pin setCenterOffset:centerOffset];
        return pin;
    } else if ([annotation isKindOfClass:[MKSSearchResultAnnotaion class]]) {
        // YMKPinAnnotationViewを作成
        YMKPinAnnotationView *pin =
            [[YMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SearchPin"];
        //アイコンイメージの変更
        pin.image = [UIImage imageNamed:@"pin_purple_s"];
        //アイコンのイメージのどこを基準点にするか設定
        CGPoint centerOffset;
        centerOffset.x = 15;
        centerOffset.y = 15;
        [pin setCenterOffset:centerOffset];
        // サブを設定
        MKSAnnotationSubView *view = [MKSAnnotationSubView view];
        view.model = annotation.model;
        [view addTarget:self action:@selector(annoatationTap:) forControlEvents:UIControlEventTouchUpInside];
        [pin setRightCalloutAccessoryView:view];
        return pin;
    }
    return nil;
}

//吹き出しボタンイベント
- (void)annoatationTap:(id)sender {
    MKSAnnotationSubView *annoation = (MKSAnnotationSubView *)sender;
    DLog(@"annotationTap");

    // YMKRouteOverlayを作成
    YMKRouteOverlay *routeOrverlay = [[YMKRouteOverlay alloc] initWithAppid:kYahooMapAppId];
    // YMKRouteOverlayDelegateを設定
    routeOrverlay.delegate = self;
    //出発地ピンの吹き出し設定
    [routeOrverlay setStartTitle:@"Start"];
    //目的地ピンの吹き出し設定
    [routeOrverlay setGoalTitle:@"End"];
    //出発地、目的地、移動手段を設定
    [routeOrverlay
        setRouteStartPos:_nowLocation
             withGoalPos:annoation.model.coorinate
             withTraffic:(int)[[MKSUserDefault sharedInstance] integerValue:kMKSUserDefaultsKeySearchTraffic]];
    //ルートの検索
    [routeOrverlay search];
}

#pragma mark YMKRouteOverlay
//ルート検索が正常に終了した場合
- (void)finishRouteSearch:(YMKRouteOverlay *)routeOverlay {
    // アノテーションを消しておく
    [_mapView removeAnnotations:_annotationList];
    // YMKRouteOverlayをYMKMapViewに追加
    [_mapView addOverlay:routeOverlay];

    // YMKNaviControllerを作成しYMKRouteOverlayインスタンスを設定
    naviController = [[YMKNaviController alloc] initWithRouteOverlay:routeOverlay];

    // YMKMapViewインスタンスを設定
    [naviController setMapView:_mapView];

    // YMKNaviControllerDelegateを設定
    naviController.delegate = self;

    //案内処理を開始
    [naviController start];

    // 右上にARボタン
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"AR"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(arButtonTap:)];
    self.navigationItem.rightBarButtonItem = item;
}

//ルート検索が正常に終了しなかった場合
- (void)errorRouteSearch:(YMKRouteOverlay *)routeOverlay withError:(int)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                   message:@"検索エラー"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

// overlay追加イベント
- (YMKOverlayView *)mapView:(YMKMapView *)mapView viewForOverlay:(id<YMKOverlay>)overlay {
    //追加されたoverlayがYMKRouteOverlayか確認
    if ([overlay isKindOfClass:[YMKRouteOverlay class]]) {
        // YMKRouteOverlayViewを作成
        YMKRouteOverlayView *wkYMKOverlayView =
            (YMKRouteOverlayView *)[[YMKRouteOverlayView alloc] initWithRouteOverlay:overlay];
        //出発地ピンを非表示
        wkYMKOverlayView.startPinVisible = YES;
        //目的地ピンを非表示
        wkYMKOverlayView.goalPinVisible = YES;
        //経由点ピンを非表示
        wkYMKOverlayView.routePinVisible = YES;
        return wkYMKOverlayView;
    }
    return nil;
}

#pragma mark YMKNaviControllerDelegate
//現在位置更新された場合
- (void)naviController:(YMKNaviController *)naviControl didUpdateUserLocation:(YMKUserLocation *)userLocation {
}
//現在位置取得エラーが発生した場合
- (void)naviController:(YMKNaviController *)naviControl didFailToLocateUserWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                   message:@"位置情報取得エラー"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //案内処理を継続しない場合は停止させる
                         [naviControl stop];
                     }];
}

//現在位置の精度が悪い場合
- (void)naviControllerAccuracyBad:(YMKNaviController *)naviControl
            didUpdateUserLocation:(YMKUserLocation *)userLocation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                   message:@"位置情報取得の精度が悪い。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //案内処理を継続しない場合は停止させる
                         [naviControl stop];
                     }];
}

//ルートから外れたと判断された場合
- (void)naviControllerRouteOut:(YMKNaviController *)naviControl didUpdateUserLocation:(YMKUserLocation *)userLocation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                   message:@"ルートから外れました。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //案内処理を継続しない場合は停止させる
                         [naviControl stop];
                     }];
}

//目的地に到着した場合
- (void)naviControllerOnGoal:(YMKNaviController *)naviControl didUpdateUserLocation:(YMKUserLocation *)userLocation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"目的地到着"
                                                                   message:@"目的地に到着しました。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //案内処理を継続しない場合は停止させる
                         [naviControl stop];
                     }];
}

@end
