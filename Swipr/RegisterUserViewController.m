//
//  RegisterUserViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "RegisterUserViewController.h"

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
        
        UIAlertView *registerAlert = [[UIAlertView alloc] initWithTitle:@"Register not complete"
                                                        message:@"Please fill out all textfields"
                                                        delegate:self
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];
        
        [registerAlert show];
    } else {
        [self checkPasswordMatch];
    }
    
}

-(void)checkPasswordMatch {
    
    if (![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextfield.text]) {
        
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Passwords Do Not Match"
                                                                message:@"Please ensure your passwords match"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
        
        [passwordAlert show];

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
    
    self.usernameTextfield = nil;
    self.emailTextfield = nil;
    self.passwordTextfield = nil;
    self.confirmPasswordTextfield = nil;
    
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
