//
//  MapViewController.h
//  HRGeolocating
//
//  Created by Hery on 10/14/13.
//  Copyright (c) 2013 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D pinLocation;
    UILongPressGestureRecognizer *addAnnotationGestureRecognizer;
    int alertViewCount;
}

@property (weak, nonatomic) IBOutlet MKMapView *mainMap;

- (IBAction)centerMap:(id)sender;

@end
