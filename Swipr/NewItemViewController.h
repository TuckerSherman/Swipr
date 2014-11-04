//
//  NewItemViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-04.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import <Parse/Parse.h>

@interface NewItemViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) Item *item;
@property (weak, nonatomic) IBOutlet UIButton *itemImageButton;
@property (weak, nonatomic) IBOutlet UITextField *itemDescriptionTextField;

- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)saveItemButtonPressed:(UIButton *)sender;
- (IBAction)itemImageButtonPressed:(UIButton *)sender;


@end
