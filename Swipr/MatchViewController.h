//
//  MatchViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-06.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface MatchViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)backButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet PFImageView *yourItemImageView;
@property (weak, nonatomic) IBOutlet PFImageView *itemYouWantImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemOwnerLabel;
@property (strong, nonatomic) PFObject *ownerWhoWantsYourItem;
@property (strong, nonatomic) PFObject *itemYouWant;
@property (strong, nonatomic) PFObject *yourItem;



- (IBAction)emailButtonPressed:(UIButton *)sender;

@end
