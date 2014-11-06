//
//  MainViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MainViewController.h"
#import "ItemDetailViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    // Setup draggable background
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    self.draggableBackground.delegate = self;
    [self.subView addSubview:self.draggableBackground];
    [self.subView bringSubviewToFront:self.infoButton];
    
    [self retreiveFromParse];
    
}

//@"username", @"itemsUserDoesWant", @"itemsUserDoesNotWant",
#pragma mark - Working with Parse methods

-(void)retreiveFromParse {
    NSString*thisUserString = [[PFUser currentUser] username];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"user" notEqualTo:thisUserString];
    
    [query whereKey:@"usersWhoDontWant" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"usersWhoWant" notEqualTo:[PFUser currentUser]];
    
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Copy objects array fetched from Parse to "items"
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:objects];
            self.draggableBackground.pfItemsArray = [items mutableCopy];
             NSLog(@"%d",(int)[self.draggableBackground.pfItemsArray count]);
            [self.draggableBackground loadCards];
            
        } else {
            NSLog(@"Error grabbing from Parse! %@",error);
        }
    }];
    
}



#pragma mark - Log Out Button Methods

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Log out"
                                                    message:@"Are you sure you want to log out?"
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Log out", nil];
    [logoutAlert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]){

    }else{
        [PFUser logOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Refresh button

- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    
    [self retreiveFromParse];

}



#pragma mark - Prepare for Segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"itemDetailSegue"]) {
        ItemDetailViewController *itemDetailVC = segue.destinationViewController;
        
        itemDetailVC.item = self.currentCard.pfItem;

    }
    
}

#pragma mark - DraggableViewBackground Method

-(void)currentCard:(DraggableView *)card {
    
    self.currentCard = card;
}

-(void)setUserPreference:(DraggableView *)card preference:(BOOL)userPreference{
    PFObject* thisItem = card.pfItem;
    PFUser* thisUser = [PFUser currentUser];

    if (userPreference == NO) {
        NSLog(@"USER DOES NOT WANTS : %@",[thisItem objectForKey:@"description"]);
        
        PFRelation *relation = [thisItem relationForKey:@"usersWhoDontWant"];
        [relation addObject:thisUser];
        [thisItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"added user to item");
            }
            if (error) {
                NSLog(@"error saving item's preferences(positive): %@",error);
            }
        }];

    }
    else if(userPreference == YES)
    {
        NSLog(@"USER WANTS : %@",[thisItem objectForKey:@"description"]);

        PFRelation *relation = [thisItem relationForKey:@"usersWhoWant"];
        [relation addObject:thisUser];

        [thisItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"added user to item");
            }
            if (error) {
                NSLog(@"error saving item's preferences(positive): %@",error);
            }
        }];
    }
}


-(void)matchItems:(PFObject *)item withWantedItems:(NSMutableArray *)wantedItems {

    for (PFObject *wanted in wantedItems) {

        NSString *wantedId = [wanted objectForKey:@"objectId"];
        NSString *itemId = [item objectForKey:@"objectId"];
        NSLog(@"Wanted ID: %@", wantedId);
        NSLog(@"Item ID: %@", itemId);
        
        if ([itemId isEqualToString:wantedId]) {
            
            UIAlertView *matchAlert = [[UIAlertView alloc] initWithTitle:@"Match!"
                                                                    message:@"You have matched items with another user!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"No thanks"
                                                          otherButtonTitles:@"Show me!", nil];
            
            [matchAlert show];

        }
       
    }
    
}


@end
