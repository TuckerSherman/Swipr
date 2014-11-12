//
//  FilterTableViewController.h
//  Swipr
//
//  Created by Tucker Sherman on 11/9/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol filterSelectionDelegate <NSObject>

-(void) applySearchFilters:(NSArray*)filters;

@end


@interface FilterTableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) NSArray* availableCategories;
@property (strong, nonatomic) NSMutableArray* selectedCategories;

@property (nonatomic) id <filterSelectionDelegate> delegate;


@end
