//
//  NewItemViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-04.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Item.h"
#import "AppDelegate.h"

@interface NewItemViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) Item *item;
@property (strong, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;

- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)saveItemButtonPressed:(UIButton *)sender;


@end
