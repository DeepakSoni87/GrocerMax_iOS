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
    
    self.cellBgView.layer.borderColor = [UIColor colorFromHexString:@"BEBEBE"].CGColor;
    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
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
