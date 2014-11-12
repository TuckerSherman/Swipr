//
//  AppDelegate.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol locationManagerSearchUpdate <NSObject>

-(void) makeNewQueryWithLocation:(CLLocationCoordinate2D)location;


@end


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLLocationCoordinate2D userCoordinates;
@property (nonatomic,strong) id <locationManagerSearchUpdate> searchDelegate;




@end

