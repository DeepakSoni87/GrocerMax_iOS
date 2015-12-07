//
//  GMPaymentCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentCell.h"

@implementation GMPaymentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeight {
    return 45.0;
}
- (void)configerViewData:(NSString *)paymentName {
    self.bottomHorizentalSepretorLbl.hidden = TRUE;
    self.checkBoxBtn.hidden = FALSE;
    [self.checkBoxBtn setExclusiveTouch:YES];
//    Arvind : PayU
    if([paymentName isEqualToString:@"payTM"]) {
        self.paymentImage.hidden = FALSE;
        self.paymentLbl.hidden = TRUE;
        [self.paymentImage setImage:[UIImage imageNamed:@"payU"]];
    } else if([paymentName isEqualToString:@"mobikwik"]) {
        self.paymentImage.hidden = FALSE;
        self.paymentLbl.hidden = TRUE;
        [self.paymentImage setImage:[UIImage imageNamed:@"mobikit"]];
        
    } else if([paymentName isEqualToString:@"My Wallet"]) {
        self.paymentImage.hidden = TRUE;
        self.paymentLbl.hidden = FALSE;
        
        GMUserModal *userModal = [GMUserModal loggedInUser];
        float balence = 0.00;
        if(NSSTRING_HAS_DATA(userModal.balenceInWallet) && [userModal.balenceInWallet floatValue]>0.01) {
            balence = [userModal.balenceInWallet floatValue];
        } else {
            self.checkBoxBtn.hidden = TRUE;
        }
        NSString *balenceStr = [NSString stringWithFormat:@"%@ (₹%.2f)",paymentName,balence];
        self.paymentLbl.text = balenceStr;
        
        
    } else {
        self.paymentImage.hidden = TRUE;
        self.paymentLbl.hidden = FALSE;
        if(NSSTRING_HAS_DATA(paymentName)) {
            self.paymentLbl.text = paymentName;
        } else {
            self.paymentLbl.text = @"";
        }
    }
   
}
@end
