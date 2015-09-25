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
            self.subTotalLbl.text = [NSString stringWithFormat:@"$%@", orderDeatilBaseModal.subTotal];;
        } else {
            self.subTotalLbl.text = @"";
        }
    
        if(NSSTRING_HAS_DATA(orderDeatilBaseModal.deliveryCharge)) {
            self.deliveryChargeLbl.text = [NSString stringWithFormat:@"$%@", orderDeatilBaseModal.deliveryCharge];
        } else {
            self.deliveryChargeLbl.text = @"";
        }
    
    if(NSSTRING_HAS_DATA(orderDeatilBaseModal.totalPrice)) {
        self.totalCharge.text = [NSString stringWithFormat:@"$%@", orderDeatilBaseModal.totalPrice];
    } else {
        self.deliveryChargeLbl.text = @"";
    }
}

@end
