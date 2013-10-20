//
//  MapViewController.m
//  HRGeolocating
//
//  Created by Hery on 10/14/13.
//  Copyright (c) 2013 Hery Ratsimihah. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    addAnnotationGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                                  action:@selector(addAnnotationForGestureRecognizer:)];
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

#pragma mark - Location Manager

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

#pragma mark - Annotations 

- (void)addAnnotationForGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    addAnnotationGestureRecognizer.enabled = NO;
    [self confirmPin];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    CGPoint location = [recognizer locationInView:_mainMap];
    CLLocationCoordinate2D locationInMap = [_mainMap convertPoint:location toCoordinateFromView:_mainMap];
    pointAnnotation.coordinate = locationInMap;
    [_mainMap addAnnotation:pointAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointAnnotation"];
    return annotationView;
}

- (void)confirmPin
{
    UIAlertView *confirmPinView = [[UIAlertView alloc] initWithTitle:@"Place a pin here?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Yes"
                                                   otherButtonTitles:@"No", nil];
    [confirmPinView show];
    addAnnotationGestureRecognizer.enabled = YES;
}

#pragma mark - Map Interactions

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
