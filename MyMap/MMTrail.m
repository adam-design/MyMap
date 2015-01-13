//
//  MMTrail.m
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 Ricky Ayoub. All rights reserved.
//

#import "MMTrail.h"

@implementation MMTrail

- (MMTrail*) init
{
    _points = [[NSMutableArray alloc] init];
    return self;
}

- (void) addPoint:(MMDataPoint*) point
{
    // add this data point object to the points array
    [_points addObject: point];
}

- (NSString*) toTSV
{
    // initialize the text string
    NSMutableString* tsvText = [NSMutableString string];
    
//    // append the name of this trail
//    [cvsText appendString:self.name];
    NSLog(@"Thing: %@", _points);
    
    // go through all data points and append the text
    for (MMDataPoint* pt in _points)
    {
        // append name, lat, long, date
        [tsvText appendString:pt.title];
        [tsvText appendString:[NSString stringWithFormat:@"\t%f", pt.coordinate.latitude]];
        [tsvText appendString:[NSString stringWithFormat:@"\t%f", pt.coordinate.longitude]];
        [tsvText appendString:[NSString stringWithFormat:@"\t%@", pt.date]];
        
        // append the newline
        [tsvText appendString:@"\n"];
    }
    
    // return our string of tab separated values
    return tsvText;
}

@end
