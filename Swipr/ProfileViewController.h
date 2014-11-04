//
//  ProfileViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Item.h"

@interface ProfileViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *userNameTextFeild;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UITextView *userBioTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *userEmailTextFeild;





@end
