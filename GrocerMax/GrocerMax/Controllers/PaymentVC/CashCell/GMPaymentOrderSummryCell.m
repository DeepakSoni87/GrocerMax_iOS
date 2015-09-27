//
//  GMPaymentOrderSummryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentOrderSummryCell.h"
#import "GMCartModal.h"

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


- (void) configerViewData:(GMCartDetailModal *)cartDetailModal {
    
    if(cartDetailModal.productItemsArray.count>0) {
        if(cartDetailModal.productItemsArray.count == 1) {
            self.totalItemLbl.text = [NSString stringWithFormat:@"%ld item",cartDetailModal.productItemsArray.count];
        } else {
            self.totalItemLbl.text = [NSString stringWithFormat:@"%ld items",cartDetailModal.productItemsArray.count];
        }
        
    } else {
        self.totalItemLbl.text = @"";
    }
    
    
    self.shippingPriceLbl.text = [NSString stringWithFormat:@"$%.2f",cartDetailModal.shippingAmount.doubleValue];
    
    double saving = 0;
    double subtotal = 0;
    double couponDiscount = 0;
    for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
        subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
    }
    if(NSSTRING_HAS_DATA(cartDetailModal.discountAmount)) {
        saving = saving - cartDetailModal.discountAmount.doubleValue;
        couponDiscount = cartDetailModal.discountAmount.doubleValue;;
    }
    [self.subTotalPriceLbl setText:[NSString stringWithFormat:@"$%.2f", subtotal]];
    [self.youSavedLbl setText:[NSString stringWithFormat:@"$%.2f", saving]];
    double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
    [self.totalPriceLbl setText:[NSString stringWithFormat:@"$%.2f", grandTotal]];
    
    [self.couponDiscountLbl setText:[NSString stringWithFormat:@"$%.2f", couponDiscount]];
    
}
@end
