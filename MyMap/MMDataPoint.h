//
//  MMDataPoint.h
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 Ricky Ayoub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MMDataPoint : NSObject <MKAnnotation>

// the time at which it occurred
@property NSDate* date;
- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andDate: (NSDate*) newDate;

// other point things
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
