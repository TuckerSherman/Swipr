//
//  MainItemDetailViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-05.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MainItemDetailViewController.h"

@interface MainItemDetailViewController ()

@end

@implementation MainItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setFile:self.imageFile];
    [self.imageView loadInBackground];
    self.itemDescriptionTextField.text = self.item.desc;

}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
