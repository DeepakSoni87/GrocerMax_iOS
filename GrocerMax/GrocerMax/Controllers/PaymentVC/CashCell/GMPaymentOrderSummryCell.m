//
//  GMPaymentOrderSummryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentOrderSummryCell.h"

@implementation GMPaymentOrderSummryCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.borderWidth = 0.5;
    self.cellBgView.layer.borderColor = [UIColor colorWithRGBValue:236 green:236 blue:236].CGColor;
    self.cellBgView.layer.cornerRadius = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeight {
    return 161.0;
}

@end
