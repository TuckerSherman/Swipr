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

- (id)initWithCoder:(NSCoder *)aCoder {
    //because we are using a Parse Framework Table View controller inside a storyboard we have to add a few methods to initWithCoder in order to configure our table view to query the correct parse class
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        self.parseClassName = @"Item";
        self.objectsPerPage = 25;

        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadObjects];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable{
    // Customize the parse query that populates the table's data source
    PFUser* thisUser = [PFUser currentUser];
     NSLog(@"user = '%@'",thisUser.username);
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"user" equalTo:thisUser.username];
    [query orderByAscending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    ParseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (!cell) {
        cell = [[ParseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
    }
    cell.parseItemTitleLabel.text = [object objectForKey:@"description"];
    cell.itemThumbnailPFImageView.image = [UIImage imageNamed:@"itemImagePlaceholder"];
    cell.itemThumbnailPFImageView.file = [object objectForKey:@"image"];
    
    [cell.itemThumbnailPFImageView loadInBackground:^(UIImage *image, NSError *error) {
        if(!error){
            NSLog(@"downloaded cell image");
        }
        else{
            NSLog(@"error downloading cell image:%@", error);
        }
    }];

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(ParseTableViewCell*)sender {
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    ItemDetailViewController* detailItemViewController = [segue destinationViewController];

    [detailItemViewController setItem:self.objects[path.row]];
    
}




#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return self.itemsForUser.count;
//}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableViewController *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}







@end
