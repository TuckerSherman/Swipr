//
//  MainViewController.m
//  Swipr
//
//  Created by Jacob Cho on 2014-11-03.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup draggable background
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.draggableBackground];
    
    [self retreiveFromParse];
    
}

-(void)retreiveFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"TestObjects"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
        if (!error) {
            // Copy objects array fetched from Parse to "items"
            NSArray *items = [[NSArray alloc] initWithArray:objects];
            
            NSMutableArray *itemText = [[NSMutableArray alloc] init];
            
            for (PFObject *object in items) {
                [itemText addObject:[object objectForKey:@"text"]];
                // Add all items for key "text" from items array to itemText
            }
            // Add everything from itemText arry to the cards
            [self loadCardsFromParse:itemText];
            
        } else {
            NSLog(@"Error grabbing from Parse!");
        }
    }];
    
}

-(void)loadCardsFromParse:(NSMutableArray *)objects {
    self.draggableBackground.exampleCardLabels = [objects mutableCopy];
    // loadCards needs to be called when array is loaded;
    [self.draggableBackground loadCards];

}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
