//
//  User.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* bio;
@property (strong, nonatomic) NSData* profilePic;
@property (strong, nonatomic) NSArray* items;


@end
