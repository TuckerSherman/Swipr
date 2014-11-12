//
//  FilterViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/10/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (IBAction)dismissFilterView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"back to main");
        FilterTableViewController* childTableView = self.childViewControllers.lastObject;
        childTableView.selectionsMade = YES;

    }];
}
-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FilterTableViewController* childTableView = self.childViewControllers.lastObject;
//    if (self.selections) {
//        childTableView.selectedCategories = [NSMutableArray arrayWithArray:self.selections];
//    }
    [childTableView parentDidLoad];
    
//    [childTableView.tableView reloadData];


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
