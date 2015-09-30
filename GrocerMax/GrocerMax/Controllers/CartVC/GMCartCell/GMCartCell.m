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

@property (nonatomic, assign) NSUInteger quantityValue;

@property (weak, nonatomic) IBOutlet UILabel *promotionLabel;

@property (weak, nonatomic) IBOutlet UILabel *zeroPriceLabel;

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
    
    self.deleteButton.produtModal = productModal;
    self.productModal = productModal;
    [self.productListImageView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.titleLbl setText:self.productModal.p_brand];
    [self.subTitleLbl setText:self.productModal.p_name];
    [self.quantityLbl setText:self.productModal.p_pack];
//    [self.priceLbl setText:[NSString stringWithFormat:@"%ld", (long)self.productModal.sale_price.integerValue]];
    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x ₹%ld | ₹%ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
    [self.priceWithOfferLbl setText:priceQuantityStr];
    [self.addSubstractLbl setText:self.productModal.productQuantity];
    self.quantityValue = self.productModal.productQuantity.integerValue;
    [self.promotionLabel setText:self.productModal.promotion_level];
    if(NSSTRING_HAS_DATA(self.productModal.promotion_level))
        [self.promotionLabel setHidden:NO];
    else
        [self.promotionLabel setHidden:YES];
    [self updatePriceLabel];
}

- (void)updatePriceLabel {
    
    double totalPrice = self.productModal.sale_price.doubleValue * self.productModal.productQuantity.integerValue;
    [self.priceLbl setText:[NSString stringWithFormat:@"₹%.2f", totalPrice]];
    
    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x ₹%ld | ₹%ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
    [self.priceWithOfferLbl setText:priceQuantityStr];
    
    if(self.productModal.sale_price.integerValue == 0) {
        
        [self.addSubstractView setHidden:YES];
        [self.deleteButton setHidden:YES];
        [self.zeroPriceLabel setHidden:NO];
        [self.zeroPriceLabel setText:self.productModal.productQuantity];
    }
    else {
        
        [self.addSubstractView setHidden:NO];
        [self.deleteButton setHidden:NO];
        [self.zeroPriceLabel setHidden:YES];
    }
}

- (IBAction)actionSubstractProduct:(UIButton *)sender {
    
    if(self.quantityValue > 1) {
        
        self.quantityValue --;
        NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
        [self.addSubstractLbl setText:productQuantity];
        [self.productModal setProductQuantity:productQuantity];
        [self updatePriceLabel];
        if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
            [self.delegate productQuantityValueChanged];
    }
}

- (IBAction)actionAddProduct:(UIButton *)sender {
    
    self.quantityValue ++;
    NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    [self.addSubstractLbl setText:productQuantity];
    [self.productModal setProductQuantity:productQuantity];
    [self updatePriceLabel];
    if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
        [self.delegate productQuantityValueChanged];
}

+ (CGFloat)cellHeightWithNoPromotion {
    
    return 120.0;
}

+ (CGFloat)cellHeightWithPromotion {
    
    return 145.0;
}
@end
