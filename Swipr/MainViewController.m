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
#import "TabLandingViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    NSMutableArray* unwantedItems;
    NSMutableArray* wantedItems;
    NSArray *ownersWhoWantYourStuff;
    PFObject *swipedCard;
    

    CLLocationCoordinate2D searchLocation;

    CGFloat searchRadius;
    NSArray* searchFilters;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [self setupLogo];
    
    // Setup cardView
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    self.draggableBackground.delegate = self;
    [self.subView addSubview:self.draggableBackground];
    
    //move storyboard UIElements to the top of the view stack
    [self.subView bringSubviewToFront:self.infoButton];
    [self.subView bringSubviewToFront:self.contentFilterButton];
    
    [self myWantedItems];
    if ([PFUser currentUser]) {
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

-(void)assignSearchRadius{
    
}
-(void)assignCurrentLocation{
    
}

#pragma mark - Working with Parse methods

-(void)retreiveFromParse {
    
    PFQuery* query = [self createParseQueryWithFilters:searchFilters location:searchLocation];
    
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

-(PFQuery*) createParseQueryWithFilters:(NSArray*)filters location:(CLLocationCoordinate2D)location{
    
    PFUser* currentUser = [PFUser currentUser];
    PFQuery* basicQuery = [PFQuery queryWithClassName:@"Item"];
    //we dont want to see items this user posted or has already swiped on
    [basicQuery whereKey:@"user" notEqualTo:currentUser.username];
    [basicQuery whereKey:@"usersWhoDontWant" notEqualTo:currentUser];
    [basicQuery whereKey:@"usersWhoWant" notEqualTo:currentUser];
    if (filters) {
        NSMutableArray* filterSubQueries = [NSMutableArray new];
        for (int i = 0; i < filters.count; i++) {
            PFQuery* filterQuery = [PFQuery queryWithClassName:@"Item"];
            [filterQuery whereKey:@"category" equalTo:filters[i]];
            [filterSubQueries addObject:filterQuery];
        }
        PFQuery* allFiltersQuery = [PFQuery orQueryWithSubqueries:filterSubQueries];
        [allFiltersQuery whereKey:@"user" notEqualTo:currentUser.username];
        [allFiltersQuery whereKey:@"usersWhoDontWant" notEqualTo:currentUser];
        [allFiltersQuery whereKey:@"usersWhoWant" notEqualTo:currentUser];
        return allFiltersQuery;

    }

    
    
    return basicQuery;
    
}

-(void) applySearchFilters:(NSArray*)filters{
    searchFilters = [NSArray arrayWithArray:filters];
    
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
    else if ([segue.identifier isEqualToString:@"filterSettings"]){
        TabLandingViewController* filterSelection = segue.destinationViewController;
        filterSelection.location = searchLocation;
        
        
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

#pragma Mark - location based stuff
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    NSLog(@"status changed to: %@",status);
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"user didnt approve");
        searchLocation = CLLocationCoordinate2DMake(-132.00, 49.32);

    }
    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"user approved");
        [_locationManager startUpdatingLocation];
         searchLocation = _locationManager.location.coordinate;
    }
    else if(status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"user approved");
        [_locationManager startUpdatingLocation];
        searchLocation = _locationManager.location.coordinate;
    }
}
-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    NSLog(@"well this happened");
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* currentLocation = locations[0];
    CLLocationCoordinate2D currentCoordinates = currentLocation.coordinate;
    searchLocation = currentCoordinates;
   
//    NSLog(@"location:%f, %f", searchLocation.latitude, searchLocation.longitude);

}


@end
