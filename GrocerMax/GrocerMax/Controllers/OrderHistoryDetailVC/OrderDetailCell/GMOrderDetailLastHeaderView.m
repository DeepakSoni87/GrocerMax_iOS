//
//  GMOrderDetailLastHeaderView.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderDetailLastHeaderView.h"

@implementation GMOrderDetailLastHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CGFloat)headerHeight {
    return 110.0;
}

- (void) configerViewData:(GMOrderDeatilBaseModal *)orderDeatilBaseModal {
        if(NSSTRING_HAS_DATA(orderDeatilBaseModal.subTotal)) {
            self.subTotalLbl.text = [NSString stringWithFormat:@"₹%.2f", orderDeatilBaseModal.subTotal.floatValue];;
        } else {
            self.subTotalLbl.text = @"";
        }
    
        if(NSSTRING_HAS_DATA(orderDeatilBaseModal.deliveryCharge)) {
            self.deliveryChargeLbl.text = [NSString stringWithFormat:@"₹%.2f", orderDeatilBaseModal.deliveryCharge.floatValue];
        } else {
            self.deliveryChargeLbl.text = @"";
        }
    
    if(NSSTRING_HAS_DATA(orderDeatilBaseModal.totalPrice)) {
        self.totalCharge.text = [NSString stringWithFormat:@"₹%.2f", orderDeatilBaseModal.totalPrice.floatValue];
    } else {
        self.deliveryChargeLbl.text = @"";
    }
}

@end
