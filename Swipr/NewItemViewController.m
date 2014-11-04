//
//  NewItemViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-04.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "NewItemViewController.h"

@interface NewItemViewController () {
    
    PFUser *currentUser;
}

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemDescriptionTextField.delegate = self;
    self.item = [[Item alloc] init];
    currentUser = [PFUser currentUser];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveItemButtonPressed:(UIButton *)sender {
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    newItem[@"description"] = self.itemDescriptionTextField.text;
    newItem[@"image"] = [PFFile fileWithName:@"Image.jpg" data:self.item.imageData];
    PFRelation *owner = [newItem objectForKey:@"owner"];
    [owner addObject:currentUser];
    newItem[@"user"] = [currentUser objectForKey:@"username"];
    [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save successful!");
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else {
            NSLog(@"Error saving to Parse");
        }
    }];
    newItem = nil;
    
}

- (IBAction)itemImageButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    
    [self presentViewController:picker animated:YES completion:nil];
 
    
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    [image drawInRect: CGRectMake(0, 0, 300, 300)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.itemImageButton setBackgroundImage:smallImage forState:UIControlStateNormal];
    self.itemImageButton.imageView.image = nil;
    self.item.imageData = UIImagePNGRepresentation(smallImage);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
