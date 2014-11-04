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
    NSLog(@"tapped");
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
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            
            NSLog(@"Error in signing up");
        }
    }];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
