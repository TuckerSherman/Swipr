//
//  MainViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

#import "DraggableViewBackground.h"
#import "DraggableView.h"
#import "AppDelegate.h"
#import "FilterTableViewController.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate, DraggableViewBackgroundDelegate,locationManagerSearchUpdate, filterSelectionDelegate>


@property (strong, nonatomic) DraggableView *currentCard;
@property (strong, nonatomic) DraggableViewBackground *draggableBackground;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *contentFilterButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FilterTableViewController* filterSelectionTable;

@property (strong, nonatomic) NSArray* searchFilters;



- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender;

-(void)applySearchFilters:(NSArray*)filters;

-(void)swipedACard;


@end
