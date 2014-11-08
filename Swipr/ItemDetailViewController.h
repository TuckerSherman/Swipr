//
//  ItemDetailViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ItemDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *contact;
@property (strong, nonatomic) PFObject* item;


@end
