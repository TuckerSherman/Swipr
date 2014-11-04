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
    CIImage *originalImage;
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
    
    // Setting filter
    CIContext *context = [CIContext contextWithOptions:nil];
    originalImage = [CIImage imageWithData:UIImagePNGRepresentation(smallImage)];

    CIImage *outputImage = [self oldPhoto:originalImage withAmount:0.6];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [[UIImage alloc] initWithCGImage:cgimg];
    [self.itemImageButton setBackgroundImage:newImage forState:UIControlStateNormal];
    self.itemImageButton.imageView.image = nil;
    self.item.imageData = UIImagePNGRepresentation(newImage);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Add hipster filter method

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    
    // 4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[originalImage extent]];
    
    // 5
    CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [composite setValue:sepia.outputImage forKey:kCIInputImageKey];
    [composite setValue:croppedImage forKey:kCIInputBackgroundImageKey];
    
    // 6
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setValue:composite.outputImage forKey:kCIInputImageKey];
    [vignette setValue:@(intensity * 2) forKey:@"inputIntensity"];
    [vignette setValue:@(intensity * 30) forKey:@"inputRadius"];
    
    // 7
    return vignette.outputImage;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
