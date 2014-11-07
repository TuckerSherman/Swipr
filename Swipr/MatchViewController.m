//
//  MatchViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-06.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MatchViewController.h"


@interface MatchViewController () {
    MFMailComposeViewController *mailComposer;
    NSString *email;
}

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemYouWantImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.yourItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *itemOwnerName = [self.itemYouWant objectForKey:@"user"];
    
    [self queryMyItem:itemOwnerName];
    [self queryForEmail:itemOwnerName];

    self.itemOwnerLabel.text = [NSString stringWithFormat:@"%@ wants to trade for this!", itemOwnerName];
    
    
    self.itemYouWantImageView.file = [self.itemYouWant objectForKey:@"image"];
    [self.itemYouWantImageView loadInBackground];
}

-(void)queryForEmail:(NSString *)itemOwnerName {
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:itemOwnerName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"No error");
            if (objects) {
                PFObject *user = [objects objectAtIndex:0];
                email = [user objectForKey:@"email"];
            
            } else {
                NSLog(@"No objects");
            }
        } else {
            NSLog(@"%@", error);
        }
       
    }];
    
    
}

-(void)queryMyItem:(NSString *)itemOwnerName {
    
    NSString*thisUser = [[PFUser currentUser] username];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"user" equalTo:itemOwnerName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Go through my items and query for relation usersWhoWant, see if anyone liked my items
            for (PFObject *myItem in objects) {
                PFRelation *wanted = [myItem relationForKey:@"usersWhoWant"];
                PFQuery *wantedQuery = [wanted query];
                
                [wantedQuery whereKey:@"username" equalTo:thisUser];
                [wantedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects) {
                        NSLog(@"in wantedQuery findObjectsInBackgroundWithBlock with error %@", error);
                        self.yourItem = myItem;
                        
                        self.yourItemImageView.file = [self.yourItem objectForKey:@"image"];
                        [self.yourItemImageView loadInBackground];
                        
                        
                        }
                   
                }];
                break;
            }
            
        } else {
            NSLog(@"Error grabbing from Parse! %@",error);
        }
    }];

}



- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)emailButtonPressed:(UIButton *)sender {
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    NSMutableArray *emailMutableArray = [[NSMutableArray alloc] initWithObjects:email, nil];
    NSArray *emailArray = [NSArray arrayWithArray:emailMutableArray];
    [mailComposer setToRecipients:emailArray];
    [mailComposer setSubject:@"I'm interested in trading items!"];

    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
