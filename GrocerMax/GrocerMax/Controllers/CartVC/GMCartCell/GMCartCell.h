//
//  GMTOfferListCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMProductModal;

@interface GMCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellBgView;
@property (strong, nonatomic) IBOutlet UIImageView *productListImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *quantityLbl;
@property (strong, nonatomic) IBOutlet UILabel *priceWithOfferLbl;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong, nonatomic) IBOutlet UIView *addSubstractView;
@property (strong, nonatomic) IBOutlet UIButton *substractBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UILabel *addSubstractLbl;

@property (weak, nonatomic) IBOutlet GMButton *deleteButton;


+ (CGFloat) getCellHeight;

- (void)configureViewWithProductModal:(GMProductModal *)productModal;
@end
