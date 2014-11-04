//
//  Item.m
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id) initWithTitle:(NSString*)title image:(NSData*)imageData thumbnailImage:(NSData*)thumbnailImageData description:(NSString*)desc{
    self = [super init];
    if (self) {
        NSLog(@"new item!");
        self.title = title;
        self.desc = desc;
        self.imageData = imageData;
        self.thumbnailImageData = thumbnailImageData;
    }
    return self;
    
}

@end
