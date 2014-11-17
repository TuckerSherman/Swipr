//
//  NewItemViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-04.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "NewItemViewController.h"
#import "SwaprConstants.h"



@implementation NewItemViewController{
    PFUser *currentUser;
    CIImage *originalImage;
    NSArray *items;
    NSArray* categories;
    NSString* selectedCategory;
    
}

#define kOFFSET_FOR_KEYBOARD 160

- (void)viewDidLoad {
    [super viewDidLoad];
    self.item = [[Item alloc] init];
    currentUser = [PFUser currentUser];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    categories =  @[@"small things", @"big things", @"clothes", @"books", @"tools", @"services"];;

    
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    if ([self.itemDescriptionTextView.text isEqualToString:@"Tap here to input a description"]) {
        self.itemDescriptionTextView.text = nil;
        self.itemDescriptionTextView.textColor = [UIColor blackColor];
        
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender{
    if  (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }

}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}



#pragma mark - IBActions
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveItemButtonPressed:(UIButton *)sender {
    
    
    
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    newItem[@"description"] = self.itemDescriptionTextView.text;
    newItem[@"image"] = [PFFile fileWithName:@"Image.jpg" data:self.item.imageData];
    PFRelation *owner = [newItem relationForKey:@"owner"];
    [owner addObject:currentUser];
    newItem[@"user"] = [currentUser objectForKey:@"username"];
    newItem[@"category"]= selectedCategory;
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFGeoPoint* userLocation = [PFGeoPoint geoPointWithLatitude: appDelegate.userCoordinates.latitude
                                                      longitude: appDelegate.userCoordinates.longitude];
    
    newItem[@"location"] = userLocation;
    

    PFACL *groupACL = [PFACL ACL];
    [groupACL setPublicWriteAccess:YES];
    [groupACL setPublicReadAccess:YES];
    newItem.ACL = groupACL;
    
    [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save successful!");
            
        }
        else {
            NSLog(@"Error saving to Parse");
        }
    }];
//    [self saveItemArrayToParse:newItem];
//    newItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)imageTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    

}

- (IBAction)itemImageButtonPressed:(UIButton *)sender {
    
    
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

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    // Set views
    self.placeholderImageView.image= newImage;
    
    self.item.imageData = UIImagePNGRepresentation(newImage);
    
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

#pragma mark - UITextViewDelegate



- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.itemDescriptionTextView resignFirstResponder];
        return NO;
    }
    else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.itemDescriptionTextView.textColor = [UIColor blackColor];
}




-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return categories.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    return categories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    switch (row) {
        case 0:{
             //if the user has allowed location services use their current location
            selectedCategory = @"small things";
            break;
        }
            
        case 1:{
            selectedCategory = @"big things";
            break;
        }

        case 2:{
            selectedCategory = @"clothes";
            break;
        }
        case 3:{
            selectedCategory = @"books";
            break;
        }
        case 4:{
            selectedCategory = @"tools";
            break;
        }
        case 5:{
            selectedCategory = @"services";
            break;
        }
        
    }
}


#pragma mark - Parse helper method

//-(void)saveItemArrayToParse:(PFObject *)item {
//    items = [currentUser objectForKey:@"items"];
//    NSLog(@"%@", items);
//    NSMutableArray *itemsMutable = [[NSMutableArray alloc] initWithArray:items];
//    [itemsMutable addObject:item];
//    
//    items = [itemsMutable mutableCopy];
//    NSLog(@"%@", items);
//    
//    [currentUser setObject:items forKey:@"items"];
//    
//    [currentUser saveInBackground];
//}

@end
