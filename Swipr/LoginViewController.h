//
//  LoginViewController.h
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextfield;
- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
