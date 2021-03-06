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
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1


@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    containerSize = frame.size;
    
    if (self) {
        [super layoutSubviews];
        [self setupView];
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        self.cardsLoadedIndex = 0;
        [self loadCards];
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

//%%% creates a card and returns it. 
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index{
    
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(15, 80, containerSize.width-30, containerSize.height-200)];
    
    PFObject* currentObject = [self.pfItemsArray objectAtIndex:index];
    
    draggableView.pfItem = currentObject;
    
    
    draggableView.information.text = [currentObject objectForKey:@"description"];
    draggableView.itemImage.file = [currentObject objectForKey:@"image"];
    draggableView.owner = [currentObject objectForKey:@"user"];
//    draggableView.objectId = [currentObject objectForKey:@"objectId"];
    
    [draggableView.itemImage loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            NSLog(@"loaded image for card");
//            DraggableView* thisCard = [loadedCards objectAtIndex:index];
//            thisCard.itemImage.image = image;
        }
        else{
            NSLog(@"error attempting to load item image in background");
            
        }
    }];
    
    
    draggableView.delegate = self;
    return draggableView;
}

// loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([self.pfItemsArray count] > 0) {
        NSInteger numLoadedCardsCap =(([self.pfItemsArray count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.pfItemsArray count]);
        // if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        // loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[self.pfItemsArray count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
                if ([loadedCards count] > 0) {
                    [self.delegate currentCard:[loadedCards objectAtIndex:0]];
                }
            }
        }
        // displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            self.cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
    
}

// action called when the card goes to the left.
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    DraggableView *thisCard = (DraggableView *)card;
    [self.delegate setUserPreference:[loadedCards objectAtIndex:0] preference:NO];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (self.cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:self.cardsLoadedIndex]];
        self.cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    if ([loadedCards count] > 0) {
    [self.delegate currentCard:[loadedCards objectAtIndex:0]];
    }
    

}

// action called when the card goes to the right.
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    DraggableView *thisCard = (DraggableView *)card;
    [self.delegate setUserPreference:[loadedCards objectAtIndex:0] preference:YES];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (self.cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:self.cardsLoadedIndex]];
        self.cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:[loadedCards objectAtIndex:0]];
    }

    
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:[loadedCards objectAtIndex:0]];
    }

}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
    if ([loadedCards count] > 0) {
        [self.delegate currentCard:[loadedCards objectAtIndex:0]];
    }

}


@end
