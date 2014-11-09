//
//  TabLandingViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/8/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "TabLandingViewController.h"

@interface TabLandingViewController ()

@end

@implementation TabLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Log out"
                                                          message:@"Are you sure you want to log out?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Log out", nil];
    logoutAlert.tag = 0;
    [logoutAlert show];
    
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
