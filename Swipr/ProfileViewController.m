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

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userBioTextFeild.text = [[PFUser currentUser]username];
    
    
    // Do any additional setup after loading the view.
}

//-(void)getUserInfo{
//    PFQuery *query= [PFUser query];
//    
//    [query whereKey:@"username" equalTo:[[PFUser currentUser]username]];
//    
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
//        
//        BOOL isPrivate = [[object objectForKey:@"isPrivate"]boolValue];
//        
//    }];
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userImageTap:(id)sender {
    
    //TODO: check if the user has a profile picture
    NSLog(@"you tapped my face");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhoto];
            break;
        case 1:
            [self pickOldPhoto];
        default:
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
    
    
    self.userProfileImageView.image = chosenImage;
    NSData* imageToBeUploaded = UIImageJPEGRepresentation(chosenImage, 75);
}
//
//    PFFile *file = [PFFile fileWithName:@"profileImage" data:imageToBeUploaded];
//    
//    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//        if (succeeded){
//        //Add the image to the object, and add the comment and the user
//        PFObject *userObject = [PFObject objectWithClassName:@"user"];
//        [imageObject setObject:file forKey:@"image"];
//        [imageObject setObject:[PFUser currentUser].username forKey:@"user"];
//        //3
//        [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            //4
//            if (succeeded){
//                //Go back to the wall
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                NSString *errorString = [[error userInfo] objectForKey:@"error"];
//                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [errorAlertView show];
//            }
//        }];
//    }
//     else{
//         //5
//         NSString *errorString = [[error userInfo] objectForKey:@"error"];
//         UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//         [errorAlertView show];
//     }
//     } progressBlock:^(int percentDone) {
//         NSLog(@"Uploaded: %d %%", percentDone);
//     }];
//    
//    }
//
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//
//    //TODO: change actual user profile image
//    self.userProfileImageView.userInteractionEnabled = NO;
//    

@end

