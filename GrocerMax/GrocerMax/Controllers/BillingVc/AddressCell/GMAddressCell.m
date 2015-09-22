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
    self.cellBgView.layer.borderColor = [UIColor colorWithRed:216.0/256.0 green:216.0/256.0 blue:216.0/256.0 alpha:1].CGColor;
    self.cellBgView.layer.borderWidth = 2.0;
    self.cellBgView.layer.cornerRadius = 4.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configerViewWithData:(id)modal {
    
    GMAddressModalData *addressModalData = (GMAddressModalData *)modal;
    self.selectUnSelectBtn.addressModal = addressModalData;
    self.editAddressBtn.addressModal = addressModalData;
    
    if(addressModalData.isSelected)
    {
        self.selectUnSelectBtn.selected = YES;
    }
    else
    {
        self.selectUnSelectBtn.selected = NO;
    }
    
    NSString *mainStrign= @"";
    
    
//    NSString *str1 = @"";
//    
//    if([addressModalData.userType isEqualToString:@"individual"])
//    {
//        str1 = @"Home";
//    }
//    else
//    {
//        str1 = @"Work";
//    }
//        mainStrign = [NSString stringWithFormat:@"%@",str1];
    
    NSString *str2 = addressModalData.street;;
    
        mainStrign = [NSString stringWithFormat:@"%@\n%@",mainStrign,str2];
   
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
    
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:[mainStrign rangeOfString:str2]];
    
    
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:[mainStrign rangeOfString:str2]];
    
    
//    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:str1]];
//    
//    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[mainStrign rangeOfString:str1]];
    
    
    self.addressLbl.numberOfLines = 4;
    self.addressLbl.attributedText = attString;
}

+ (CGFloat)cellHeight {
    
    return 116.0f;
}
@end
