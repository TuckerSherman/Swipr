//
//  UserItemsTableViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"
#import "Item.h"
#import "ItemDetailViewController.h"

@interface UserItemsTableViewController : UITableViewController

@property (strong,nonatomic) NSArray* itemsForUser;


@end
