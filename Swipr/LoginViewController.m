//
//  LoginViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.loginUsernameTextfield.text password:self.loginPasswordTextfield.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Logged in");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (error) {
            
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Could not log in"
                                                                 message:@"Sorry, there was a problem logging in"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            [loginAlert show];
        }
    }];
    self.loginUsernameTextfield.text = nil;
    self.loginPasswordTextfield.text = nil;
}
@end
