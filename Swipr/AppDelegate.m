
//
//  AppDelegate.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate{
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self themeNavController];
    [self startTrackingLocation];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];

    // Override point for customization after application launch.
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    
    [PFImageView class];
    [PFQueryTableViewController class];
    [PFTableViewCell class];
    
    [Parse setApplicationId:@"BnoNW84s5syR018qZP1zDSWP6hTPNXrvS1vQh3dq"
                  clientKey:@"s62gxiYrmlcG44SoTIKpSedO8Fl1MKGpAZapNVZ5"];
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced in iOS 7).
        // In that case, we skip tracking here to avoid double counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else
#endif
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }

    return YES;
}

-(void)themeNavController{

        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:113.0/255.0 green:177.0/255.0 blue:225.0/255.0 alpha:1]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

}


-(void)configureParse{
    
}

-(void)startTrackingLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma Mark - location based stuff
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //    NSLog(@"status changed to: %@",status);
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"user didnt approve");
        self.userCoordinates = CLLocationCoordinate2DMake(-132.00, 49.32);
        
    }
    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"user approved");
        [_locationManager startUpdatingLocation];
        self.userCoordinates = self.locationManager.location.coordinate;
    }
    else if(status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"user approved");
        [self.locationManager startUpdatingLocation];
        self.userCoordinates = self.locationManager.location.coordinate;
    }
}
-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"well this happened");
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* currentLocation = locations[0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];

//    [self.searchDelegate makeNewQueryWithLocation:currentLocation.coordinate];
    self.userCoordinates = currentLocation.coordinate;
    NSLog(@"UPDATED YOUR COORDINATES YO");
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
