//
//  GMOrderHistoryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistoryCell.h"
#import "GMOrderHistryModal.h"

#define ORDER_ID @"Order Id: "
#define ORDER_DATE @"Order Date: "
#define ORDER_AMOUNT_PAID @"Amount Paid: "
#define ORDER_STATUS @"Status: "
#define ORDER_ITEMS @"Items: "

#define FIRST_FONTSIZE 15.0
#define TITLE_FONTSIZE 15.0

@implementation GMOrderHistoryCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.cellBgView.layer setCornerRadius:5.0f];
    self.cellBgView.layer.borderWidth =1.0f;
    self.cellBgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configerViewWithData:(id)modal {
    
    GMOrderHistryModal *orderHistryModal = (GMOrderHistryModal *)modal;
    
    
    
    NSString *mainStrign= @"";

    if(NSSTRING_HAS_DATA(orderHistryModal.orderId))
    {
        mainStrign = [NSString stringWithFormat:@"%@%@",ORDER_ID,orderHistryModal.orderId];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderDate))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_DATE,orderHistryModal.orderDate];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderAmountPaid))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_AMOUNT_PAID,orderHistryModal.orderAmountPaid];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderStatus))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_STATUS ,orderHistryModal.orderStatus];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderItems))
    {
        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_ITEMS,orderHistryModal.orderItems];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
    
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderAmountPaid]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderStatus]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderItems]];
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderAmountPaid]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderStatus]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:[NSString stringWithFormat:@"%@%@",ORDER_ITEMS,orderHistryModal.orderItems]]];

    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:ORDER_ID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:ORDER_DATE]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:ORDER_AMOUNT_PAID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:ORDER_STATUS]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:ORDER_ITEMS]];
    
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
