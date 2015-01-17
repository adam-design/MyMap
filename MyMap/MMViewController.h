//
//  MMViewController.h
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MMTrail.h"
#import "MMAppDelegate.h"

@interface MMViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property MMTrail * trail;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *startB;
@property (weak, nonatomic) IBOutlet UIButton *stopB;
@property CLLocationManager *locationManager;
@property bool trackingLocation;
@property (nonatomic, strong) MKPolylineView *lineView;
@property (nonatomic, strong) MKPolyline *polyline;
@end
