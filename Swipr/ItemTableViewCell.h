//
//  ItemTableViewCell.h
//  Swipr
//
//  Created by Tucker Sherman on 11/3/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemThumbNailImageView;
@property (strong, nonatomic) IBOutlet UILabel *itemTitleLabel;
@end
