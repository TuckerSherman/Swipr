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

@interface MainViewController : UIViewController <UIAlertViewDelegate, DraggableViewBackgroundDelegate>

@property (strong, nonatomic) Item *item;

@property (strong, nonatomic) DraggableView *currentCard;
@property (strong, nonatomic) DraggableViewBackground *draggableBackground;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender;


@end
