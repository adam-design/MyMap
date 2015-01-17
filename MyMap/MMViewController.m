//
//  MMViewController.m
//  MyMap
//
//  Created by Ricky and Adam on 1/12/15.
//

#import "MMViewController.h"
#import "MMDataPoint.h"

@interface MMViewController ()

@end

@implementation MMViewController

- (NSManagedObjectContext *)managedObjectContext
{
    // Code for CoreData
    NSManagedObjectContext *context = nil;
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create a new map trail object
    _trail = [[MMTrail alloc] init];
    
    // set the map to show our location
    [_mapView setShowsUserLocation:YES];
    
    // startup location stuffs
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // create a distance filter to reduce noise from staying in one place
    self.locationManager.distanceFilter = 20.0f;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        // request authorization to always use the location
        [self.locationManager requestAlwaysAuthorization];
    }

}

- (IBAction)save:(id)sender
{
    // Code for saving the trail data to the database
    
    NSManagedObjectContext* context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject* newTrail = [NSEntityDescription insertNewObjectForEntityForName:@"Trail" inManagedObjectContext:context];
    
    // set the date to the last point's date
    [newTrail setValue:((MMDataPoint*)[_trail.points lastObject]).date forKey:@"date"];
    
    // set the name of the trail TODO: prompt the user and load old name
    [newTrail setValue:@"New Trail X" forKey:@"name"];
    
    // create an ordered set to store the pins in
    NSMutableOrderedSet* orderedSet = [[NSMutableOrderedSet alloc] init];
    
    // bundle the points data into managed objects
    for (MMDataPoint* dp in _trail.points)
    {
        // create a new managed object
        NSManagedObject* curPoint = [NSEntityDescription insertNewObjectForEntityForName:@"Pin" inManagedObjectContext:context];
        
        // set the properties about the point to its object in the database
        [curPoint setValue:dp.title forKey:@"name"];
        [curPoint setValue:dp.date forKey:@"date"];
        [curPoint setValue: [[NSNumber alloc] initWithDouble:dp.coordinate.latitude] forKey:@"lat"];
        [curPoint setValue: [[NSNumber alloc] initWithDouble:dp.coordinate.longitude] forKey:@"long"];
        
        // add this object to the ordered set
        [orderedSet addObject: curPoint];
    }
    
    // make a relationship to this ordered set with the trail
    [newTrail setValue:orderedSet forKey:@"has"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClick:(id)sender
{
    
    if (_trackingLocation)
        // stop updating location
        [self.locationManager stopUpdatingLocation];
    else
        // start updating location
        [self.locationManager startUpdatingLocation];
    
    // change the button title based on the boolean
    [sender setTitle: (_trackingLocation? @"Resume" : @"Pause") forState: UIControlStateNormal];
    
    // flip the tracking boolean
    _trackingLocation = !_trackingLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // get the location object
    CLLocation *location = [locations lastObject];
    
    // create a data point object with the current loc and date
    MMDataPoint* pt = [[MMDataPoint alloc] initWithCoordinate:location.coordinate andDate:[NSDate date]];

    // set the title
    pt.title = [NSString stringWithFormat: @"Point %lu", ([_trail.points count]+1)];
    
    // add this point to display on the map
    [self.mapView addAnnotation:pt];
    
    // add this point to the trail object
    [_trail addPoint:pt];
    
    // zoom to the proper dimensions for the current path
    [self zoomPath];
    
    // draw the actual lines between points
    [self drawLines:self];
    
    // print the trail so far
    NSLog(@"NEW TRAIL");
    NSLog(@"%@", [_trail toTSV]);
    NSLog(@"\n");
    
}


- (IBAction)drawLines:(id)sender {
    
    // HACK: for some reason this only updates the map view every other time
    // and because life is too frigging short, let's just call it TWICE
    
    [self drawLineSubroutine];
    [self drawLineSubroutine];
    
}

- (void)drawLineSubroutine {
    
    // remove polyline if one exists
    [self.mapView removeOverlay:self.polyline];
    
    // create an array of coordinates from allPins
    CLLocationCoordinate2D coordinates[_trail.points.count];
    int i = 0;
    for (MMDataPoint* currentPin in _trail.points) {
        coordinates[i] = currentPin.coordinate;
        i++;
    }
    
    // create a polyline with all cooridnates
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:_trail.points.count];
    [self.mapView addOverlay:polyline];
    self.polyline = polyline;
    
    // create an MKPolylineView and add it to the map view
    self.lineView = [[MKPolylineView alloc]initWithPolyline:self.polyline];
    self.lineView.strokeColor = [UIColor redColor];
    self.lineView.lineWidth = 5;
    
    
}

- (void) zoomPath
{
    // determine the extents of the trip points that were passed in, and zoom in to that area.
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int idx = 0; idx < _trail.points.count; idx++)
    {
        CLLocation* currentLocation = [_trail.points objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    
    MKCoordinateRegion region;
    region.center.latitude = (maxLat + minLat) / 2;
    region.center.longitude = (maxLon + minLon) / 2;
    region.span.latitudeDelta = (maxLat - minLat) * 1.2;
    region.span.longitudeDelta = (maxLon - minLon) * 1.2;
    
    [self.mapView setRegion:region];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    return self.lineView;
}


@end
