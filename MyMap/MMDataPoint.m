//
//  MMDataPoint.m
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 Ricky Ayoub. All rights reserved.
//

#import "MMDataPoint.h"

@implementation MMDataPoint

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate andDate:(NSDate*)newDate {
    
    self = [super init];
    if (self) {
        _coordinate = newCoordinate;
        _title = @"Hello";
        _subtitle = [NSString stringWithFormat:@"%@", newDate];
        _date = newDate;
    }
    return self;
}

@end
