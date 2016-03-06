//
//  MKSNetworkConnecter.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#import <AFNetworking.h>
#import <Foundation/Foundation.h>

@interface MKSNetworkConnecter : NSObject

typedef void (^success)(id responce);

typedef void (^failure)(NSError *error);

@end
