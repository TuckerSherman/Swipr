//
//  ItemDetailViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Item.h"

@interface ItemDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UITextField *itemDescriptionTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *userContactTextFeild;
@property (strong, nonatomic) PFObject* item;


@end
