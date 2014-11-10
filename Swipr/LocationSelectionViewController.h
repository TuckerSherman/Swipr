//
//  LocationSelectionViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/8/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 


@interface LocationSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (nonatomic) CLLocationCoordinate2D searchLocation;
@property (strong, nonatomic) NSDictionary* cities;


@end
