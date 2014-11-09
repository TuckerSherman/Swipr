//
//  LocationSelectionViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/8/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "LocationSelectionViewController.h"

@interface LocationSelectionViewController ()

@end

@implementation LocationSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityPicker.delegate = self;
    
    self.cityPicker.dataSource = self.cities;
    
    // Do any additional setup after loading the view.
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
