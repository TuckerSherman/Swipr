//
//  MainItemDetailViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-05.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Item.h"

@interface MainItemDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *itemDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *userInfoTextField;
@property (strong, nonatomic) Item *item;
@property (strong, nonatomic) PFFile *imageFile;


- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
