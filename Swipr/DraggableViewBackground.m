//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"
#import "MainViewController.h"


@implementation DraggableViewBackground{

    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* checkButton;
    UIButton* xButton;
    
    CGSize containerSize;

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    containerSize = frame.size;
    
    if (self) {
        [super layoutSubviews];
        [self setupView];
        loadedCards = [[NSMutableArray alloc] init];
        self.pfItemsArray = [[NSMutableArray alloc] init];
        self.cardsLoadedIndex = 0;
//        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.3];

    xButton = [[UIButton alloc]initWithFrame:CGRectMake(containerSize.width/4-29, containerSize.height -100, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(((containerSize.width/4)*3)-29, containerSize.height -100, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:xButton];

    [self addSubview:checkButton];

}


-(DraggableView *)createCardWithPFItem:(PFObject*)item{
    
    DraggableView *card = [[DraggableView alloc]initWithFrame:CGRectMake(15, 80, containerSize.width-30, containerSize.height-200)];
    card.information.text = [item objectForKey:@"description"];
    card.itemImage.file = [item objectForKey:@"image"];
    card.owner = [item objectForKey:@"user"];
    card.pfItem = item;
    card.delegate = self;

    [card.itemImage loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            NSLog(@"loaded image for card");
        } else {
            NSLog(@"error attempting to load item image in background: %@",error);
        }
    }];
    return card;
}

// loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCardsFromArray:(NSArray*)data{
    
    for (PFObject* item in data) {
        DraggableView* newCard = [self createCardWithPFItem:item];
        [_pfItemsArray addObject:item];
        [loadedCards insertObject:newCard atIndex:0];
        [self insertSubview:newCard atIndex:0];
    }
}
-(void)clearDeck{
    for (DraggableView* card in loadedCards) {
        [card removeFromSuperview];
    }
    
    
}

// action called when the card goes to the left.
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    DraggableView *thisCard = (DraggableView *)card;
    PFUser* thisUser = [PFUser currentUser];
    [loadedCards removeObject:thisCard];
    
    PFRelation *relation = [thisCard.pfItem relationForKey:@"usersWhoDontWant"];
    [relation addObject:thisUser];
    [thisCard.pfItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate unloadCards];
                [self.delegate retreiveFromParse:1];
            });
        } else {
            NSLog(@"error saving item's preferences(positive): %@",error);
        }
    }];

    if ([loadedCards count] > 0) {
        [self.delegate currentCard:loadedCards[loadedCards.count]];
    }
    

}

// action called when the card goes to the right.
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    DraggableView *thisCard = (DraggableView *)card;
    PFUser* thisUser = [PFUser currentUser];
    [loadedCards removeObject:thisCard];

    PFRelation *relation = [thisCard.pfItem relationForKey:@"usersWhoDontWant"];
    [relation addObject:thisUser];
    [thisCard.pfItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate unloadCards];
                [self.delegate retreiveFromParse:1];
            });
        } else {
            NSLog(@"error saving item's preferences(positive): %@",error);
        }
    }];
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:loadedCards[loadedCards.count]];
    }
//
    
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:loadedCards[loadedCards.count]];
    }

}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:loadedCards [loadedCards.count]];
    }

}


@end
