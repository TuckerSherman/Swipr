//
//  FilterViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/10/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewController.h"

@class MainViewController;

@interface FilterViewController : UIViewController

@property (strong,nonatomic) NSArray* selections;
@property (weak, nonatomic) MainViewController* modalParent;



@end
