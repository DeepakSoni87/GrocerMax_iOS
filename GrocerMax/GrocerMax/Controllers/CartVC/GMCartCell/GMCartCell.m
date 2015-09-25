//
//  GMTOfferListCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartCell.h"

@interface GMCartCell()

@property (nonatomic, strong) GMProductModal *productModal;
@end

@implementation GMCartCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cellBgView.layer.borderColor = [UIColor colorFromHexString:@"BEBEBE"].CGColor;
    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
}

#pragma mark - GETTER/SETTER Methods

- (void)setProductListImageView:(UIImageView *)productListImageView {
    
    _productListImageView = productListImageView;
    [_productListImageView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_productListImageView.layer setBorderWidth:1.0];
}

- (void)configureViewWithProductModal:(GMProductModal *)productModal {
    
    self.productModal = productModal;
    [self.productListImageView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.titleLbl setText:self.productModal.p_brand];
    [self.subTitleLbl setText:self.productModal.p_name];
    [self.quantityLbl setText:self.productModal.p_pack];
    [self.priceLbl setText:[NSString stringWithFormat:@"%ld", (long)self.productModal.sale_price.integerValue]];
    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x %ld | %ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
    [self.priceWithOfferLbl setText:priceQuantityStr];
    [self.addSubstractLbl setText:self.productModal.productQuantity];
}

- (IBAction)actionSubstractProduct:(UIButton *)sender {
    
    int items = [self.addSubstractLbl.text intValue];
    if(items != 0)
    {
        self.addSubstractLbl.text = [NSString stringWithFormat:@"%d",items-1];
    }
    
}

- (IBAction)actionAddProduct:(UIButton *)sender {
    
    int items = [self.addSubstractLbl.text intValue];
    
        self.addSubstractLbl.text = [NSString stringWithFormat:@"%d",items+1];
}

+ (CGFloat) getCellHeight {
    
    return 119.0;
}
@end
