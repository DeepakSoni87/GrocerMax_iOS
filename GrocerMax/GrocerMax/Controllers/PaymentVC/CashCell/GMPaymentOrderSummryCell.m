//
//  GMPaymentOrderSummryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentOrderSummryCell.h"
#import "GMCartModal.h"
#import "GMCoupanCartDetail.h"

@implementation GMPaymentOrderSummryCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.borderWidth = BORDER_WIDTH;
    self.cellBgView.layer.borderColor = BORDER_COLOR;
    self.cellBgView.layer.cornerRadius = CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeight {
    return 161.0;
}


- (void) configerViewData:(GMCartDetailModal *)cartDetailModal coupanCartDetail:(GMCoupanCartDetail *)coupanCartDetail {
    
    if(cartDetailModal.productItemsArray.count>0) {
        if(cartDetailModal.productItemsArray.count == 1) {
            self.totalItemLbl.text = [NSString stringWithFormat:@"%d item",cartDetailModal.productItemsArray.count];
        } else {
            self.totalItemLbl.text = [NSString stringWithFormat:@"%d items",cartDetailModal.productItemsArray.count];
        }
        
    } else {
        self.totalItemLbl.text = @"";
    }
    
    if(coupanCartDetail) {
        if(NSSTRING_HAS_DATA(coupanCartDetail.ShippingCharge)) {
            self.shippingPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.ShippingCharge.doubleValue];
        } else {
            self.shippingPriceLbl.text = [NSString stringWithFormat:@"₹0.00"];
        }
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.subtotal)) {
            self.subTotalPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.subtotal.doubleValue];
        } else {
            self.subTotalPriceLbl.text = [NSString stringWithFormat:@"₹0.00"];
        }
        if(NSSTRING_HAS_DATA(coupanCartDetail.you_save)) {
            double saving = 0;
            for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
                saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
            }
            if(NSSTRING_HAS_DATA(cartDetailModal.discountAmount)) {
                saving = saving - cartDetailModal.discountAmount.doubleValue;
            }
            self.youSavedLbl.text = [NSString stringWithFormat:@"₹-%.2f",coupanCartDetail.you_save.doubleValue+saving];
        } else {
            self.youSavedLbl.text = [NSString stringWithFormat:@"₹0.00"];
        }
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.grand_total)) {
            self.totalPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.grand_total.doubleValue];
            [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹%.2f",coupanCartDetail.grand_total.doubleValue]];
        } else {
            self.totalPriceLbl.text = [NSString stringWithFormat:@"₹0.00"];
            [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹0.00"]];
        }
        if(NSSTRING_HAS_DATA(coupanCartDetail.you_save)) {
            self.couponDiscountLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.you_save.doubleValue];
        } else {
            self.couponDiscountLbl.text = [NSString stringWithFormat:@"₹0.00"];
        }
        
    }
    else {
        self.shippingPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",cartDetailModal.shippingAmount.doubleValue];
        
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
        [self.subTotalPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", subtotal]];
        [self.youSavedLbl setText:[NSString stringWithFormat:@"₹%.2f", saving]];
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        [self.totalPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", grandTotal]];
        [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", grandTotal]];
        [self.couponDiscountLbl setText:[NSString stringWithFormat:@"₹%.2f", couponDiscount]];
    }
    
}

@end
