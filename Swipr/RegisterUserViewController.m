//
//  RegisterUserViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "RegisterUserViewController.h"
#import <SCLAlertView.h>

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)registerButtonPressed:(UIButton *)sender {
    
    [self checkFieldsComplete];
}


-(void)checkFieldsComplete {
    
    if ([self.usernameTextfield.text isEqualToString:@""]|| [self.emailTextfield.text isEqualToString:@""] || [self.passwordTextfield.text isEqualToString:@""] || [self.confirmPasswordTextfield.text isEqualToString:@""]) {
        
        SCLAlertView *registerAlert = [[SCLAlertView alloc] init];
        
        [registerAlert showError:self title:@"Register Not Complete" subTitle:@"Please Fill Out All Textfields" closeButtonTitle:@"Ok" duration:0.0f];
        
    } else {
        [self checkPasswordMatch];
    }
    
}

-(void)checkPasswordMatch {
    
    if (![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextfield.text]) {
        
        SCLAlertView *passwordAlert = [[SCLAlertView alloc] init];
        
        [passwordAlert showError:self title:@"Passwords Don't Match" subTitle:@"Please ensure your passwords match" closeButtonTitle:@"Ok" duration:0.0f];

    } else {
        
        [self registerNewUser];
    }
    
}

-(void)registerNewUser {
    
    PFUser *newUser = [[PFUser alloc] init];
    newUser.username = self.usernameTextfield.text;
    newUser.email = self.emailTextfield.text;
    newUser.password = self.passwordTextfield.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Signed up!");
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"registered a new user!");
            }];
        } else {
            
            NSLog(@"Error in signing up: %@", error);
        }
    }];
    
    self.usernameTextfield.text = nil;
    self.emailTextfield.text = nil;
    self.passwordTextfield.text = nil;
    self.confirmPasswordTextfield.text = nil;
    
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
