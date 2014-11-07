//
//  ItemDetailViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController () {
    
    NSString *email;
}

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemImageView.file = [self.item objectForKey:@"image"];
    [self.itemImageView loadInBackground];
    
    NSString *userName = [self.item objectForKey:@"user"];
    [self queryForEmail:userName];
    
    

    self.itemDescriptionLabel.text = [self.item objectForKey:@"description"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userTapsBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)queryForEmail:(NSString *)itemOwnerName {
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:itemOwnerName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"No error");
            if (objects) {
                PFObject *user = [objects objectAtIndex:0];
                email = [user objectForKey:@"email"];
                self.contactInfoLabel.text = [NSString stringWithFormat:@"Name: %@\nEmail: %@", itemOwnerName, email];
            } else {
                NSLog(@"No objects");
            }
        } else {
            NSLog(@"%@", error);
        }
        
    }];
    
    
}

@end
