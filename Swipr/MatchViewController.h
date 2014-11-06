//
//  MatchViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-06.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchViewController : UIViewController
- (IBAction)backButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet PFImageView *yourItemImageView;
@property (weak, nonatomic) IBOutlet PFImageView *itemYouWantImageView;
@property (strong, nonatomic) PFObject *yourItem;
@property (strong, nonatomic) PFObject *itemYouWant;

- (IBAction)emailButtonPressed:(UIButton *)sender;

@end
