//
//  MainViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MainViewController.h"
#import "ItemDetailViewController.h"
#import "MatchViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    NSMutableArray* unwantedItems;
    NSMutableArray* wantedItems;
    NSArray *ownersWhoWantYourStuff;
    PFObject *swipedCard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    // Setup draggable background
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    self.draggableBackground.delegate = self;
    [self.subView addSubview:self.draggableBackground];
    [self.subView bringSubviewToFront:self.infoButton];
    [self myWantedItems];
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
    logoutAlert.tag = 0;
    [logoutAlert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == [alertView cancelButtonIndex]){

        }else{
            [PFUser logOut];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 1) {
        
        if ([alertView buttonTitleAtIndex:1]) {
            [self goToMatch];
        }
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
    swipedCard = thisItem;

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
        
        [self matchItems:thisItem withOwnerArray:ownersWhoWantYourStuff];

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

#pragma mark - Match Methods

-(void)matchItems:(PFObject *)item withOwnerArray:(NSArray *)array {
    
    // query an item for it's owner
    NSString *itemsOwner = [item objectForKey:@"user"];
    
    // Check all owners in array to see if it match the item's owner
    for (PFObject *owners in array) {
        NSString *owner = [owners objectForKey:@"username"];
        if ([itemsOwner isEqualToString:owner]) {
            UIAlertView *matchAlert = [[UIAlertView alloc] initWithTitle:@"You Got A Match!"
                                                                    message:@"Someone wanted your item too!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:@"Show Me", nil];
            matchAlert.tag = 1;
            
            [matchAlert show];
    
        }
        
    }
}

// Do query for all items that belong to me, and see if there is a user that wants them
-(void)myWantedItems {
    // Query my Items
    NSString*thisUser = [[PFUser currentUser] username];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"user" equalTo:thisUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Go through my items and query for relation usersWhoWant, see if anyone liked my items
            for (PFObject *myItem in objects) {
                PFRelation *wanted = [myItem relationForKey:@"usersWhoWant"];
                PFQuery *wantedQuery = [wanted query];
                
                [wantedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    ownersWhoWantYourStuff = objects;
                    
                }];
            }
            
        } else {
            NSLog(@"Error grabbing from Parse! %@",error);
        }
    }];
}

-(void)goToMatch {
    MatchViewController *matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchViewController"];
    matchVC.itemYouWant = swipedCard;
    matchVC.ownerWhoWantsYourItem = [ownersWhoWantYourStuff objectAtIndex:0];
    [self presentViewController:matchVC animated:YES completion:nil];
}

@end
