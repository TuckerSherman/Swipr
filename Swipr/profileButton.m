//
//  profileButton.m
//  Swipr
//
//  Created by Tucker Sherman on 11/6/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "profileButton.h"

@implementation profileButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    
    self.image = [UIImage imageNamed:@"profileIcon"];
    
    return self;
    
}
@end
