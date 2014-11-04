//
//  MainViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableViewBackground.h"
#import "DraggableView.h"
#import <Parse/Parse.h>

@interface MainViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) DraggableViewBackground *draggableBackground;
- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender;

@end
