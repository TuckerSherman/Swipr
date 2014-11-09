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

@interface MainViewController : UIViewController <UIAlertViewDelegate, DraggableViewBackgroundDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) DraggableView *currentCard;
@property (strong, nonatomic) DraggableViewBackground *draggableBackground;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *contentFilterButton;

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender;
-(void)assignSearchRadius;
-(void)assignCurrentLocation;



@end
