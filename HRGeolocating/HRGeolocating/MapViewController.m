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
        alertViewCount = 0;
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
    CGPoint location = [recognizer locationInView:_mainMap];
    CLLocationCoordinate2D locationInMap = [_mainMap convertPoint:location toCoordinateFromView:_mainMap];
    pinLocation = locationInMap;
    [self confirmPin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointAnnotation"];
    return annotationView;
}

#pragma mark - Alert Views

- (void)confirmPin
{
    if (alertViewCount == 0)
    {
        alertViewCount++;
        UIAlertView *confirmPinView = [[UIAlertView alloc] initWithTitle:@"New Pin"
                                                                 message:@"Describe how to get there, when it is accessible, etc..."
                                                                delegate:self
                                                       cancelButtonTitle:@"Pin!"
                                                       otherButtonTitles:@"Back", nil];
        confirmPinView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [confirmPinView show];
    } else {
        alertViewCount = 0;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    addAnnotationGestureRecognizer.enabled = YES;
    if (buttonIndex == 0)
    {
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = pinLocation;
        pointAnnotation.title = [[alertView textFieldAtIndex:0] text];;
        [_mainMap addAnnotation:pointAnnotation];
    }
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
