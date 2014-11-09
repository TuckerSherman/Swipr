//
//  TabLandingViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/8/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "TabLandingViewController.h"
#import "FilterTableViewController.h"
#import "LocationSelectionViewController.h"

@interface TabLandingViewController ()

@end

@implementation TabLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FilterTableViewController* filterSelectionVC=  self.childViewControllers[1];
    LocationSelectionViewController* locationSelectionVC = self.childViewControllers[0];
    locationSelectionVC.searchLocation = self.location;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
