//
//  ProfileViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//


#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    PFUser* _currentUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentUser = [PFUser currentUser];

    //default view has profile editing locked
    [self performSelector:@selector(lockUserTap:)withObject:nil];
    [self setupCurrentUser];
//    [self setQueryTableView];
}

-(void) setupCurrentUser{
    self.userNameTextFeild.text = _currentUser.username;
    self.userEmailTextFeild.text = _currentUser.email;
    
//dowload user bio
    PFQuery *query= [PFUser query];
    [query whereKey:@"username" equalTo:_currentUser.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        NSString* userBio = [object objectForKey:@"bio"];
        NSLog(@"pulled down bio");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!userBio) {
                self.userBioTextFeild.text = nil;
                [self.userBioTextFeild becomeFirstResponder];
                [self performSelector:@selector(unlockUserTap:)withObject:nil];
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

//-(void) setQueryTableView{
//    PFQueryTableViewController* ourPFTableView = self.childViewControllers[0];
//    ourPFTableView.parseClassName = @"item";
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unlockUserTap:(id)sender {
    //enable all fields that accept user interaction - make everything editable slighly opaque - hide the unlock button and show the lock button
    self.userNameTextFeild.userInteractionEnabled = YES;
    self.userBioTextFeild.userInteractionEnabled=YES;
    self.userBioTextFeild.alpha=.7;
    self.userEmailTextFeild.userInteractionEnabled = YES;
    self.userEmailTextFeild.alpha=.7;
    self.userProfileImageView.userInteractionEnabled = YES;
    self.userProfileImageView.alpha =.7;
    self.unlockButton.hidden = YES;
    self.unlockButton.userInteractionEnabled = NO;
    self.lockButton.hidden = NO;
    self.lockButton.userInteractionEnabled=YES;
    self.userProfileImageView.alpha =.5;
}
- (IBAction)lockUserTap:(id)sender {
    //disable all fields that accept user interaction - make everything totally opaque - hide the lock button and show the unlock button
    self.userNameTextFeild.userInteractionEnabled=NO;
    self.userBioTextFeild.userInteractionEnabled=NO;
    self.userBioTextFeild.alpha=1;
    self.userBioTextFeild.textColor=[UIColor blackColor];
    self.userEmailTextFeild.userInteractionEnabled = NO;
    self.userEmailTextFeild.alpha=1;
    self.userProfileImageView.userInteractionEnabled = NO;
    self.userProfileImageView.alpha=1;
    self.lockButton.hidden = YES;
    self.lockButton.userInteractionEnabled=NO;
    self.unlockButton.hidden = NO;
    self.unlockButton.userInteractionEnabled = YES;
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
    picker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
    
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
    NSData* imageToBeUploaded = UIImageJPEGRepresentation(chosenImage, 75);
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

