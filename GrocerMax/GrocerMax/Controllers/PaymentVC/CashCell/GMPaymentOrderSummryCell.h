//
//  GMPaymentOrderSummryCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMPaymentOrderSummryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBgView;

@property (weak, nonatomic) IBOutlet UILabel *totalItemLbl;


@property (weak, nonatomic) IBOutlet UILabel *totalItemPriceLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTotalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *shippingPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponDiscountLbl;
@property (weak, nonatomic) IBOutlet UILabel *youSavedLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;

+ (CGFloat) cellHeight;

- (void) configerViewData:(GMCartDetailModal *)cartDetailModal;
@end
