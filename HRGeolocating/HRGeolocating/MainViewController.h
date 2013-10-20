//
//  MainViewController.h
//  HRGeolocating
//
//  Created by Hery on 10/14/13.
//  Copyright (c) 2013 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MainViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mainMap;

- (IBAction)centerMap:(id)sender;

@end
