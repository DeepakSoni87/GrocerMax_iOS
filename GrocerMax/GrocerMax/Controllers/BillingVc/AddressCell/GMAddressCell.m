//
//  GMAddressCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddressCell.h"

@implementation GMAddressCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.borderWidth =0.70f;
    self.cellBgView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configerViewWithData:(id)modal {
    
    NSString *mainStrign= @"";
    
    NSString *str1 = @"Home";
        mainStrign = [NSString stringWithFormat:@"%@",str1];
    
    NSString *str2 = @"B - 323, Columbia Blvd W, Near 7/11, Lethbridge, T1k4B8";
    
        mainStrign = [NSString stringWithFormat:@"%@\n%@",mainStrign,str2];
   
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
    
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:[mainStrign rangeOfString:str2]];
    
    
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} range:[mainStrign rangeOfString:str2]];
    
    
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:str1]];
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[mainStrign rangeOfString:str1]];
    
    
    self.addressLbl.numberOfLines = 4;
    self.addressLbl.attributedText = attString;
}

@end
