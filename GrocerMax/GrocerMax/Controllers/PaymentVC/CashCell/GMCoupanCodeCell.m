//
//  GMCoupanCodeCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 29/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCoupanCodeCell.h"

@implementation GMCoupanCodeCell

- (void)awakeFromNib {
    // Initialization code
    self.textfeildBgView.layer.borderWidth = 0.8;
    self.textfeildBgView.layer.cornerRadius = 3.0;
    self.textfeildBgView.layer.borderColor = [UIColor colorWithRGBValue:224 green:224 blue:224].CGColor;
    self.applyCodeBtn.layer.cornerRadius = 3.0;
    [self.applyCodeBtn setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat) cellHeight {
    return 50.0f;
}


@end
