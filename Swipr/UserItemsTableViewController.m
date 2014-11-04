//
//  UserItemsTableViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "UserItemsTableViewController.h"

@interface UserItemsTableViewController ()

@end

@implementation UserItemsTableViewController

- (void)viewDidLoad {
    self.itemsForUser = [self getItemsForUser:@"bill"];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray*)getItemsForUser:(NSString*)user{
    
    //Initialize some sample data
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dogs_hero" ofType:@"png"];
    NSData* dogImageData = [NSData dataWithContentsOfFile:path];
    Item* dog = [[Item alloc]initWithTitle:@"Dog" image:dogImageData thumbnailImage:dogImageData description:@"such allergies, much cutes, do not want"];
    
    NSArray* items = @[dog];
    
    return items;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.itemsForUser.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    Item* thisItem = self.itemsForUser[indexPath.row];
    cell.itemTitleLabel.text = thisItem.title;
    cell.itemThumbNailImageView.image = [UIImage imageWithData:thisItem.thumbnailImageData];
    
    // Configure the cell...
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ItemDetailViewController* detailItemViewController = [segue destinationViewController];
    NSLog(@"%@",sender);
    
//    [self.tableView cellForRowAtIndexPath:
    [detailItemViewController setItem:self.itemsForUser[0]];
    
    // Pass the selected object to the new view controller.
}


@end
