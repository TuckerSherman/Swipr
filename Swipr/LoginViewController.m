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

-(void)viewWillAppear:(BOOL)animated {
    // If user is currently logged in, they will be automatically moved to the next screen
    PFUser *user = [PFUser currentUser];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (user.username != nil) {
        [self performSegueWithIdentifier:@"logIn" sender:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginPasswordTextfield.delegate = self;
    self.loginUsernameTextfield.delegate = self;
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.loginUsernameTextfield.text password:self.loginPasswordTextfield.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Logged in");
            [self performSegueWithIdentifier:@"logIn" sender:self];
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


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
@end
