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
    self.textfeildBgView.layer.borderWidth = BORDER_WIDTH;
    self.textfeildBgView.layer.cornerRadius = CORNER_RADIUS;
    self.textfeildBgView.layer.borderColor = BORDER_COLOR;
    self.applyCodeBtn.layer.cornerRadius = CORNER_RADIUS;
    [self.applyCodeBtn setClipsToBounds:YES];
    [self.applyCodeBtn setBackgroundColor:[UIColor gmRedColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat) cellHeight {
    return 50.0f;
}


@end
