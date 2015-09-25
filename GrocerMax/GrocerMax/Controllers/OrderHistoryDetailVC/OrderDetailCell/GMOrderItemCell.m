//
//  GMOrderItemCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderItemCell.h"

@implementation GMOrderItemCell

- (void)awakeFromNib {
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 75.0;
}


- (void)configerViewData:(GMOrderItemDeatilModal *)orderItemDeatilModal {
    
    if(NSSTRING_HAS_DATA(orderItemDeatilModal.itemName)) {
        self.orderItemNameLbl.text = orderItemDeatilModal.itemName;
    } else {
        self.orderItemNameLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderItemDeatilModal.itemPrice)) {
        self.oredrItemPriceLbl.text =[NSString stringWithFormat:@"$%@",orderItemDeatilModal.itemPrice];
    } else {
        self.oredrItemPriceLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderItemDeatilModal.quantity)) {
        self.orderQuantityLbl.text =[NSString stringWithFormat:@"%@ item(s)",orderItemDeatilModal.quantity];
    } else {
        self.orderQuantityLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderItemDeatilModal.itemPrice) && NSSTRING_HAS_DATA(orderItemDeatilModal.quantity)) {
        self.totalOrderQuantityLbl.text =[NSString stringWithFormat:@"Quantity: %@ x $%@",orderItemDeatilModal.quantity,orderItemDeatilModal.itemPrice];
    } else {
        self.totalOrderQuantityLbl.text = @"";
    }
    
}
@end
