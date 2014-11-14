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
#import "FilterViewController.h"
//#import "FilterTableViewController.h"
#import <SCLAlertView.h>

@interface MainViewController ()

@end

@implementation MainViewController{
    
    NSArray *ownersWhoWantYourStuff;
    PFObject *swipedCard;
    PFGeoPoint* searchLocation;
    CGFloat searchRadius;
    AppDelegate *appDelegate;
    BOOL alreadyLoadedCards;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    alreadyLoadedCards = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:)
                                                 name:@"refreshView" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applySearchFilters) name:@"selectedFilters" object:nil];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.userCoordinates.latitude!=0) {
        [self refreshView:nil];
    }
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    [self setupLogo];
    [self setupDeck];
    
    [self myWantedItems];

    
}


-(void)setupDeck{
    
    // Setup cardView
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    self.draggableBackground.delegate = self;
    [self.subView addSubview:self.draggableBackground];

    //move storyboard UI elements to the top of the view stack
    [self.subView bringSubviewToFront:self.infoButton];
    [self.subView bringSubviewToFront:self.contentFilterButton];

    
}
-(void)refreshView:(NSNotification *) notification{
    searchLocation = [PFGeoPoint geoPointWithLatitude:appDelegate.userCoordinates.latitude longitude:appDelegate.userCoordinates.longitude];
    searchRadius = 100.0;
    if (!alreadyLoadedCards) {
        [self retreiveFromParse];
    }
}


-(void)setupLogo{
    CGFloat navWidth = self.navigationController.navigationBar.frame.size.width;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIImageView* logo =[[UIImageView alloc]initWithFrame:CGRectMake(navWidth/2.0, navHeight/2.0, 200, 40)];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"WhiteLogo"];
    
    self.navigationItem.titleView = logo;
}

-(void)assignSearchRadius:(NSInteger)radius{
    
}


#pragma mark - Working with Parse methods

-(void)retreiveFromParse {
    
    PFQuery* query = [self createParseQueryWithFilters:self.searchFilters location:searchLocation];
    
    [query orderByAscending:@"createdAt"];
//    query.limit = 2;
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
                if (!alreadyLoadedCards) {
                    // Copy objects array fetched from Parse to "items"
                    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:objects];
                    self.draggableBackground.pfItemsArray = [items mutableCopy];
                    [self.draggableBackground loadCards];
                    alreadyLoadedCards = YES;
                }

        } else {
            NSLog(@"Error grabbing from Parse! %@",error);
        }
    }];
    
}

-(PFQuery*) createParseQueryWithFilters:(NSArray*)filters location:(PFGeoPoint*)location{
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* baseQuery;
    
    NSLog(@"making parseQuery");
    
    if (filters && ![filters isEqual:@[]]) {
        NSMutableArray* filterSubQueries = [NSMutableArray new];
        for (int i = 0; i < filters.count; i++) {
            PFQuery* filterQuery = [PFQuery queryWithClassName:@"Item"];
            [filterQuery whereKey:@"category" equalTo:filters[i]];
            [filterSubQueries addObject:filterQuery];
        }
        baseQuery = [PFQuery orQueryWithSubqueries:filterSubQueries];
//        baseQuery = [PFQuery queryWithClassName:@"Item"];

    } else {
        baseQuery = [PFQuery queryWithClassName:@"Item"];
    }
    
    [baseQuery whereKey:@"user" notEqualTo:currentUser.username];
    [baseQuery whereKey:@"usersWhoDontWant" notEqualTo:currentUser];
    [baseQuery whereKey:@"usersWhoWant" notEqualTo:currentUser];
    
    if(location){
        [baseQuery whereKey:@"location" nearGeoPoint:location withinKilometers:searchRadius];
    }
    
    return baseQuery;
    
}

-(void) applySearchFilters:(NSArray*)filters{
    
    self.searchFilters = [NSArray arrayWithArray:filters];
    
}


#pragma mark - Log Out Button Methods

- (IBAction)logOutButtonPressed:(UIBarButtonItem *)sender {
    
    SCLAlertView *logOutAlert = [[SCLAlertView alloc] init];
    [logOutAlert addButton:@"Log Out" actionBlock:^{
        [PFUser logOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [logOutAlert showCustom:self image:[UIImage imageNamed:@"logOutIcon"]
                      color:[UIColor colorWithRed:113.0/255.0 green:177.0/255.0 blue:225.0/255.0 alpha:1]
                      title:@"Log Out"
                   subTitle:@"Are you sure you want to log out?"
           closeButtonTitle:@"Cancel" duration:0.0f];

}

#pragma mark - Prepare for Segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"itemDetailSegue"]) {
        ItemDetailViewController *itemDetailVC = segue.destinationViewController;
        itemDetailVC.item = self.currentCard.pfItem;
    }
    else if ([segue.identifier isEqualToString:@"filterSettings"]){
        
        FilterViewController* filterSelection = segue.destinationViewController;
        filterSelection.modalParent = self;
        filterSelection.selections = self.searchFilters;
        
//        self.filterSelectionTable=  filterSelection.childViewControllers[0];
//        self.filterSelectionTable = [searchFilters mutableCopy];
    }
    
}

-(void)checkRecipt{
    NSLog(@"I see you have selected:%@",self.searchFilters);
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
//        NSLog(@"USER DOES NOT WANTS : %@",[thisItem objectForKey:@"description"]);
        
        PFRelation *relation = [thisItem relationForKey:@"usersWhoDontWant"];
        [relation addObject:thisUser];
        [thisItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"error saving item's preferences(positive): %@",error);
            }
        }];

    }
    else if(userPreference == YES)
    {
//        NSLog(@"USER WANTS : %@",[thisItem objectForKey:@"description"]);
        
        [self matchItems:thisItem withOwnerArray:ownersWhoWantYourStuff];

        PFRelation *relation = [thisItem relationForKey:@"usersWhoWant"];
        [relation addObject:thisUser];

        [thisItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"error saving item's preferences(positive): %@",error);
            }
        }];
    }
    alreadyLoadedCards = NO;

    [self retreiveFromParse];
    
}

#pragma mark - Match Methods

-(void)matchItems:(PFObject *)item withOwnerArray:(NSArray *)array {
    
    // query an item for it's owner
    NSString *itemsOwner = [item objectForKey:@"user"];
    
    // Check all owners in array to see if it match the item's owner
    for (PFObject *owners in array) {
        NSString *owner = [owners objectForKey:@"username"];
        if ([itemsOwner isEqualToString:owner]) {
            SCLAlertView *matchAlert = [[SCLAlertView alloc] init];
            [matchAlert addButton:@"Show Me"
                           target:self
                         selector:@selector(goToMatch)];
            [matchAlert showCustom:self
                             image:[UIImage imageNamed:@"Handshake"]
                             color:[UIColor colorWithRed:113.0/255.0 green:177.0/255.0 blue:225.0/255.0 alpha:1]
                             title:@"You Got A Match!"
                          subTitle:@"Someone wanted your item too!"
                  closeButtonTitle:@"Ok"
                          duration:0.0f];
        }
    }
}

// Do query for all items that belong to me, and see if there is a user that wants them
-(void)myWantedItems {
    // Query my Items
    PFUser* thisUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"user" equalTo:thisUser.username];
    
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
