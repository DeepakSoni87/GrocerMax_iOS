//
//  GMOrderHistoryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistoryCell.h"
#import "GMBaseOrderHistoryModal.h"

#define ORDER_ID @"Order Id: "
#define ORDER_DATE @"Order Date: "
#define ORDER_AMOUNT_PAID @"Amount Paid: "
#define ORDER_STATUS @"Status: "
#define ORDER_ITEMS @"Items: "

#define FIRST_FONTSIZE 13.0
#define TITLE_FONTSIZE 12.0

@implementation GMOrderHistoryCell

- (void)awakeFromNib {
    // Initialization code
    
//    [self.cellBgView.layer setCornerRadius:5.0f];
//    self.cellBgView.layer.borderWidth =1.0f;
//    self.cellBgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
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
    
    GMOrderHistoryModal *orderHistryModal = (GMOrderHistoryModal *)modal;
    
    
    
    NSString *mainStrign= @"";

    if(NSSTRING_HAS_DATA(orderHistryModal.orderId))
    {
        mainStrign = [NSString stringWithFormat:@"%@%@",ORDER_ID,orderHistryModal.orderId];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderDate))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_DATE,orderHistryModal.orderDate];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.paidAmount))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_AMOUNT_PAID,orderHistryModal.paidAmount];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.status))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_STATUS ,orderHistryModal.status];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.totalItem))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_ITEMS,orderHistryModal.totalItem];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
    
    if(NSSTRING_HAS_DATA(orderHistryModal.orderId))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderDate))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.paidAmount))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.paidAmount]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.paidAmount]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.status))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.status]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.status]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.totalItem))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.totalItem]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:[NSString stringWithFormat:@"%@%@",ORDER_ITEMS,orderHistryModal.totalItem]]];
    }
    

    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_ID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_DATE]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_AMOUNT_PAID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_STATUS]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_ITEMS]];
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_ID]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_DATE]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_AMOUNT_PAID]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_STATUS]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_ITEMS]];

    
    
    self.titleLbl.numberOfLines = 5;
    self.titleLbl.attributedText = attString;
//
    
}
@end
