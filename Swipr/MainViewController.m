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
            NSArray *doges = [[NSArray alloc] initWithArray:objects];
            
            NSMutableArray *dogetext = [[NSMutableArray alloc] init];
            
            for (PFObject *object in doges) {
                [dogetext addObject:[object objectForKey:@"text"]];
            }
            
            [self loadCardsFromParse:dogetext];
            
        } else {
            NSLog(@"Error grabbing from Parse!");
        }
    }];
    
}

-(void)loadCardsFromParse:(NSMutableArray *)objects {
    NSLog(@"%@", objects);
    self.draggableBackground.exampleCardLabels = @[objects[0], objects[1]];
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
