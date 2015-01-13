//
//  MMTrail.h
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 Ricky Ayoub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MMDataPoint.h"

@interface MMTrail : NSObject
- (void) addPoint:(MMDataPoint*) point;
- (NSString*) toTSV;
@property NSMutableArray* points;
@property NSString* name;

@end
