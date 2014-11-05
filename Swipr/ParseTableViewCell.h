//
//  ParseTableViewCell.h
//  Swipr
//
//  Created by Tucker Sherman on 11/4/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <Parse/Parse.h>

@interface ParseTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *parseItemTitleLabel;
@property (strong, nonatomic) IBOutlet PFImageView *itemThumbnailPFImageView;

@end
