//
//  MainViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MainViewController.h"
#import "MainItemDetailViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

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


#pragma mark - Working with Parse methods

-(void)retreiveFromParse {
    NSString*thisUser = [[PFUser currentUser] username];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"user" notEqualTo:thisUser];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Copy objects array fetched from Parse to "items"
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:objects];
            self.draggableBackground.items = [items mutableCopy];
             NSLog(@"%d",(int)[self.draggableBackground.items count]);
            [self.draggableBackground loadCards];
            self.currentCard = [self.draggableBackground.allCards objectAtIndex:0];
            
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
        
        MainItemDetailViewController *itemDetailVC = segue.destinationViewController;
        itemDetailVC.item = [[Item alloc] init];
        itemDetailVC.imageFile = self.currentCard.itemImage.file;
        itemDetailVC.item.desc = self.currentCard.information.text;
        NSLog(@"%@", itemDetailVC.item.desc);
    }
    
}

#pragma mark - DraggableViewBackground Method

-(void)currentCard:(DraggableView *)card {
    
    self.currentCard = card;
    NSLog(@"%@", self.currentCard.information.text);
    
}

@end
