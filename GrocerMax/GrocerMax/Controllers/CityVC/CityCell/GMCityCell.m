//
//  GMCityCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCityCell.h"
#import "GMStateBaseModal.h"

@implementation GMCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCellWithData:(id)data {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GMCityModal *cityModal = (GMCityModal *)data;
    self.cityBtn.cityModal = cityModal;
    
    if(cityModal.isSelected) {
        self.cityBtn.selected = YES;
    }
    else {
        self.cityBtn.selected = NO;
    }
    [self.cityBtn setTitle:cityModal.cityName forState:UIControlStateNormal];
    [self.cityBtn setTitle:cityModal.cityName forState:UIControlStateNormal];
    [self.cityBtn setExclusiveTouch:YES];
}

+ (CGFloat)cellHeight {
    return 91;
}

@end
