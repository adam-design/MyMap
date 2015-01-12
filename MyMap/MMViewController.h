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

@interface MMViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *startB;
@property (weak, nonatomic) IBOutlet UIButton *stopB;
@property CLLocationManager *locationManager;
@end
