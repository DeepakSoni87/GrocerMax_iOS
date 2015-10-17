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

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSoldout;

@property (weak, nonatomic) IBOutlet UIImageView *offerImg;

@end

NSString * const kFreePromotionString = @"Sorry, Requested item is sold out. Please remove from cart to proceed.";

@implementation GMCartCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
}

- (void)setCellBgView:(UIView *)cellBgView {
    
    _cellBgView = cellBgView;
    _cellBgView.layer.cornerRadius = 5.0;
    _cellBgView.layer.masksToBounds = YES;
    _cellBgView.layer.borderWidth = 0.8;
    _cellBgView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

#pragma mark - GETTER/SETTER Methods

- (void)setProductListImageView:(UIImageView *)productListImageView {
    
    _productListImageView = productListImageView;
//    [_productListImageView.layer setBorderColor:[UIColor grayColor].CGColor];
//    [_productListImageView.layer setBorderWidth:1.0];
}

- (void)configureViewWithProductModal:(GMProductModal *)productModal {
    
    self.deleteButton.produtModal = productModal;
    self.productModal = productModal;
    [self.productListImageView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.titleLbl setText:self.productModal.p_brand.uppercaseString];
    [self.subTitleLbl setText:self.productModal.p_name];
    [self.quantityLbl setText:self.productModal.p_pack];
//    [self.priceLbl setText:[NSString stringWithFormat:@"%ld", (long)self.productModal.sale_price.integerValue]];
    
    
//    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x ₹%ld | ₹%ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmGrayColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ₹%ld | ", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue] attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%ld", (long)self.productModal.Price.integerValue] attributes:style2]];
    
    [self.priceWithOfferLbl setAttributedText:attString];
    
    [self.addSubstractLbl setText:self.productModal.productQuantity];
    self.quantityValue = self.productModal.productQuantity.integerValue;
    [self.promotionLabel setText:self.productModal.promotion_level];
    if(NSSTRING_HAS_DATA(self.productModal.promotion_level))
        [self.promotionLabel setHidden:NO];
    else
        [self.promotionLabel setHidden:YES];
    
    if ([self.productModal.Status isEqualToString:@"0"]) {
        self.imgViewSoldout.hidden = NO;
        self.addSubstractView.hidden = YES;
        [self.promotionLabel setText:kFreePromotionString];
    }else{
        self.imgViewSoldout.hidden = YES;
        self.addSubstractView.hidden = NO;
    }
    
    
    if (self.productModal.promotion_level.length > 1 && self.productModal.sale_price.integerValue == 0) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage freeImage]];
    }
    else if (self.productModal.promotion_level.length > 1 && self.productModal.sale_price.integerValue != 0) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage offerImage]];
    }
    else if (self.productModal.sale_price.integerValue == 0 ) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage freeImage]];
    }
    else {
        self.offerImg.hidden = YES;
    }
    [self updatePriceLabel];
}

- (void)updatePriceLabel {
    
    double totalPrice = self.productModal.sale_price.doubleValue * self.productModal.productQuantity.integerValue;
    [self.priceLbl setText:[NSString stringWithFormat:@"₹%.2f", totalPrice]];
    
//    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x ₹%ld | ₹%ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
//    [self.priceWithOfferLbl setText:priceQuantityStr];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor grayColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor redColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ₹%ld | ", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue] attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%ld", (long)self.productModal.Price.integerValue] attributes:style2]];
    
    [self.priceWithOfferLbl setAttributedText:attString];

    
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

+ (CGFloat)cellHeightForPromotionalLabelWithText:(NSString*)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: FONT_LIGHT(15)};
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 15, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];
    
    return 120 + rect.size.height + 5;
}

@end
