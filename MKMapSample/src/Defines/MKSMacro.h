//
//  MKSMacro.h
//  MKMapSample
//
//  Created by Yuto on 2016/03/05.
//  Copyright © 2016年 Yuto. All rights reserved.
//

#ifndef MKSMacro_h
#define MKSMacro_h

#ifdef DEBUG
#define DLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...)
#endif

#endif /* MKSMacro_h */
