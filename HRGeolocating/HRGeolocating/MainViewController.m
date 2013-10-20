//
//  MainViewController.m
//  HRGeolocating
//
//  Created by Hery on 10/14/13.
//  Copyright (c) 2013 Hery Ratsimihah. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startStandardUpdates];
    UILongPressGestureRecognizer *addAnnotationGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                                  action:@selector(addAnnotation:)];
    [_mainMap addGestureRecognizer:addAnnotationGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _mainMap.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startStandardUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
        
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 500;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
}

- (void)addAnnotation:(id)sender
{
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = currentLocation.coordinate;
    [_mainMap addAnnotation:pointAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointAnnotation"];
    return annotationView;
}

- (void)centerMapToCurrentUserLocation
{
    MKCoordinateRegion region = _mainMap.region;
    region.span.longitudeDelta /= 1024.0;
    region.span.latitudeDelta /= 1024.0;
    region.center = currentLocation.coordinate;
    [_mainMap setRegion:region animated:YES];
}

- (IBAction)centerMap:(id)sender {
    [self centerMapToCurrentUserLocation];
}
@end
