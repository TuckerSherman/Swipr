//
//  Item.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong,nonatomic) NSString* title;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSData* imageData;
@property (strong, nonatomic) NSData* thumbnailImageData;

-(id) initWithTitle:(NSString*)title image:(NSData*)imageData thumbnailImage:(NSData*)thumbnailImage description:(NSString*)desc;




@end
