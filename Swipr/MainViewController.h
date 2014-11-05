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
#import "Item.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) DraggableViewBackground *draggableBackground;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) Item *item;

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender;


@end
