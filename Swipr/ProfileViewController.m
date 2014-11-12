//
//  ProfileViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//


#import "ProfileViewController.h"
#import <SCLAlertView.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    PFUser* _currentUser;
    BOOL editing;
    UIBarButtonItem* lockButton;
    UIBarButtonItem* unlockButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.3];
    _currentUser = [PFUser currentUser];
    
    lockButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lock"]
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(unlockUserTap:)];
    
    unlockButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Unlock"]
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(lockUserTap:)];
    
    self.navigationItem.rightBarButtonItem = lockButton;

    //default view has profile editing locked
    [self performSelector:@selector(lockUserTap:)withObject:nil];
    [self setupCurrentUser];
    

    
    
    
//    [self setQueryTableView];
}

-(void) setupCurrentUser{
    
    self.navigationItem.title = _currentUser.username;
    self.userEmailTextFeild.text = _currentUser.email;
    self.navigationItem.rightBarButtonItem = lockButton;

    //dowload user bio
    PFQuery *query= [PFUser query];
    [query whereKey:@"username" equalTo:_currentUser.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        NSString* userBio = [object objectForKey:@"bio"];
        NSLog(@"pulled down bio");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!userBio) {
                
                SCLAlertView *bioAlert = [[SCLAlertView alloc] init];
                [bioAlert showCustom:self image:[UIImage imageNamed:@"Notice"] color:[UIColor colorWithRed:113.0/255.0 green:177.0/255.0 blue:225.0/255.0 alpha:1] title:@"No User Bio" subTitle:@"You haven't written a user bio.  Tap the lock in the top right to edit your profile" closeButtonTitle:@"Ok" duration:0.0f];
                
            }
            
            self.userBioTextFeild.text = userBio;
            [self performSelector:@selector(lockUserTap:)withObject:nil];
        });
    }];
    
    //dowload profile pic
    PFFile* profileImageFile = (PFFile*)_currentUser[@"profileImage"];
    [self.userProfileImageView setFile:profileImageFile];
    [self.userProfileImageView loadInBackground:^(UIImage *image, NSError *error) {
        if (!error)
            NSLog(@"profilePic loadInBackground completed");
        else {
            NSLog(@"profilePic loadInBackground failed with error: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unlockUserTap:(id)sender {
    //enable all fields that accept user interaction - make everything editable slighly opaque - hide the unlock button and show the lock button
    self.userBioTextFeild.userInteractionEnabled=YES;
    self.userBioTextFeild.alpha=1;
    self.userEmailTextFeild.userInteractionEnabled = YES;
    self.userEmailTextFeild.alpha=1;
    self.userProfileImageView.userInteractionEnabled = YES;
    self.userProfileImageView.alpha =.7;
    
    self.navigationItem.rightBarButtonItem = unlockButton;

}
- (IBAction)lockUserTap:(id)sender {
    //disable all fields that accept user interaction - make everything totally opaque - hide the lock button and show the unlock button

    self.userBioTextFeild.userInteractionEnabled=NO;
    self.userBioTextFeild.alpha=.7;
    self.userBioTextFeild.textColor=[UIColor blackColor];
    self.userEmailTextFeild.userInteractionEnabled = NO;
    self.userEmailTextFeild.alpha=.7;
    self.userProfileImageView.userInteractionEnabled = NO;
    self.userProfileImageView.alpha=1;
    
    self.navigationItem.rightBarButtonItem = lockButton;

}

- (IBAction)userImageTap:(id)sender {
//this can only be triggered when the user's profile is "unlocked"
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - action sheet delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhoto];
            break;
        case 1:
            [self pickOldPhoto];
            break;
    }
}

-(void)takeNewPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)pickOldPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - image picker controller delegate calls

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.userProfileImageView.image = chosenImage;
    NSData* imageToBeUploaded = UIImageJPEGRepresentation(chosenImage, 50);
    PFFile *imageFile = [PFFile fileWithName:@"profileImage" data:imageToBeUploaded];
    [_currentUser setObject:imageFile forKey:@"profileImage"];
    [_currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded){
            NSLog(@"saved new user profile image");
        }
        else{
            NSLog(@"error saving profile image %@",error);
        }
    }];
}
#pragma mark - text view delegate calls

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.userBioTextFeild resignFirstResponder];
        return NO;
    }
    else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"bio"]= self.userBioTextFeild.text;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved user bio string");
        }
        else{
            NSLog(@"error saving bio string: %@",error);
        }
    }];
    [self.userEmailTextFeild becomeFirstResponder];
    textView.textColor = [UIColor blackColor];

}
#pragma mark - text feild delegate calls (only for the email feild)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//feild is only accessable if user profile is "unlocked"
    [textField resignFirstResponder];
        _currentUser[@"email"]= self.userEmailTextFeild.text;
        [_currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"saved user email string");
            }
            else{
                NSLog(@"error saving email string: %@",error);
            }
        }];
        return YES;
}

@end

