//
//  GMOrderItemCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderItemCell.h"

@implementation GMOrderItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 75.0;
}

@end
