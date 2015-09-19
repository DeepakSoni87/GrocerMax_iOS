//
//  GMTOfferListCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMTOfferListCell.h"

@implementation GMTOfferListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cellBgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.cellBgView.layer.borderWidth = 0.50;
    
    self.addSubstractView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.addSubstractView.layer.borderWidth = 0.40;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configerViewWithData:(id)modal {
    
    [self.substractBtn addTarget:self action:@selector(actionSubstractProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self.substractBtn setExclusiveTouch:YES];
    
    
    [self.addBtn addTarget:self action:@selector(actionAddProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn setExclusiveTouch:YES];
    
}

-(void)actionSubstractProduct:(UIButton *)sender {
    
    int items = [self.addSubstractLbl.text intValue];
    if(items != 0)
    {
        self.addSubstractLbl.text = [NSString stringWithFormat:@"%d",items-1];
    }
    
}

-(void)actionAddProduct:(UIButton *)sender {
    
    int items = [self.addSubstractLbl.text intValue];
    
        self.addSubstractLbl.text = [NSString stringWithFormat:@"%d",items+1];
}
@end
