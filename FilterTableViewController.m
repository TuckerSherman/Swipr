//
//  FilterTableViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/9/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "FilterTableViewController.h"
#import "FilterViewController.h"
#import "MainViewController.h"
#import "SwaprConstants.h"

@interface FilterTableViewController ()

@end

@implementation FilterTableViewController{
    ////
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.availableCategories = @[@"small things", @"big things", @"clothes", @"books", @"tools", @"services"];
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelection = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

}

-(void)parentDidLoad{
    FilterViewController* parent = self.parentViewController;
    MainViewController* cardView = parent.modalParent;
    self.delegate = cardView;
    
    if (!cardView.searchFilters) {
        self.selectedCategories = [NSMutableArray new];
        NSLog(@"i set up a new categories array");
    } else {
        self.selectedCategories = [NSMutableArray arrayWithArray:cardView.searchFilters];
        
        [self.tableView reloadData];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.availableCategories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString* thisCategory = self.availableCategories[indexPath.row];
    cell.textLabel.text = thisCategory;
    if ([self.selectedCategories containsObject:thisCategory]) {

        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    }
    
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* selection = self.availableCategories[indexPath.row];
    [self.selectedCategories addObject:selection];
    self.selectionsMade = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedFilters" object:nil];
    [self.delegate applySearchFilters:self.selectedCategories];

    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString* selection = self.availableCategories[indexPath.row];
    if ([self.selectedCategories containsObject:selection]) {
        [self.selectedCategories removeObject:selection];
    }
    [self.delegate applySearchFilters:self.selectedCategories];

}
-(void)viewDidDisappear:(BOOL)animated{
    [self.delegate applySearchFilters:self.selectedCategories];
    [self.delegate checkRecipt];


}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
