//
//  UserItemsTableViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseTableViewCell.h"
#import "PFItem.h"
#import "ItemDetailViewController.h"

@interface UserItemsTableViewController : PFQueryTableViewController

//@property (strong,nonatomic) NSArray* itemsForUser;


- (id)initWithCoder:(NSCoder *)aCoder;


@end
