//
//  MMViewController.m
//  MyMap
//
//  Created by Ricky Ayoub on 1/12/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "MMViewController.h"

@interface MMViewController ()

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // startup location stuffs
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        // request authorization to always use the location
        [self.locationManager requestAlwaysAuthorization];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClick:(id)sender
{
    // start updating location
    [self.locationManager startUpdatingLocation];
}

- (IBAction)stopClick:(id)sender
{
    // stop updating location
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center.longitude = location.coordinate.longitude;
    mapRegion.center.latitude = location.coordinate.latitude;
    mapRegion.span.latitudeDelta = 0.03;
    mapRegion.span.longitudeDelta = 0.03;
    [_mapView setRegion:mapRegion animated: YES];
        
    NSLog(@"HERE'S THE THING lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    // create an annocation for this position
    MKPointAnnotation *ant = [[MKPointAnnotation alloc] init];
    [ant setCoordinate:location.coordinate];
    [ant setTitle:@"You are Here!"];
    
    [_mapView addAnnotation:ant];
    
    
}

@end
