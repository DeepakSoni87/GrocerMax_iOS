//
//  GMProductListTableViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListTableViewCell.h"
#import "GMProductModal.h"
#import "GMCartModal.h"

#define kMAX_Quantity 500

@interface GMProductListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *promotionalLbl;

@property (weak, nonatomic) IBOutlet UIView *bgVeiw;

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLbl;

@property (weak, nonatomic) IBOutlet UILabel *productQuantityLbl;

@property (weak, nonatomic) IBOutlet UILabel *productBrandLabel;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *productPackLabel;

@property (weak, nonatomic) IBOutlet UILabel *productOfferLabel;

@property (weak, nonatomic) IBOutlet UIView *cartView;

@property (weak, nonatomic) IBOutlet UILabel *itemsNumberLabel;

@property (strong, nonatomic) GMProductModal *productModal;

@property (nonatomic, strong) GMCartModal *cartModal;

@property (nonatomic, assign) NSUInteger totalProductsInCart;
@end

@implementation GMProductListTableViewCell

- (void)awakeFromNib {
    // Initialization code

    self.addBtn.layer.cornerRadius = 5.0;
    self.addBtn.layer.masksToBounds = YES;

    self.bgVeiw.layer.cornerRadius = 5.0;
    self.bgVeiw.layer.masksToBounds = YES;
    
    self.bgVeiw.layer.borderWidth = 0.80;
    self.bgVeiw.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - GETTER/SETTER Methods

- (void)setCartView:(UIView *)cartView {
    
    _cartView = cartView;
    [_cartView setHidden:YES];
}

#pragma mark - Configure Cell

- (void)configureCellWithProductModal:(GMProductModal *)productModal andCartModal:(GMCartModal *)cartModal {
    
    self.productModal = productModal;
    self.cartModal = cartModal;
    self.addBtn.produtModal = productModal;
    
    [self.productImgView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.productBrandLabel setText:self.productModal.p_brand];
    [self.productNameLabel setText:self.productModal.p_name];
    [self.productPackLabel setText:self.productModal.p_pack];
    [self.productOfferLabel setText:[NSString stringWithFormat:@"₹%@ | ₹%@", self.productModal.sale_price, self.productModal.Price]];
    
    self.promotionalLbl.text = self.productModal.promotion_level;
    if ([self.productModal.productQuantity integerValue] == 0)
        self.productModal.productQuantity = @"1";
        self.productQuantityLbl.text = self.productModal.productQuantity;
    [self updateTotalProductItemsInCart];
}
    
#pragma mark - stepper (+/-) Button Action

- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    NSInteger quant = [self.productModal.productQuantity integerValue];
    
    if (quant > 1) {
        quant -= 1;
        self.productModal.productQuantity = [NSString stringWithFormat:@"%ld",quant];
        self.productQuantityLbl.text = self.productModal.productQuantity;
    }
}

- (IBAction)pluseBtnPressed:(UIButton *)sender {
    
    NSInteger quant = [self.productModal.productQuantity integerValue];

    if (quant < kMAX_Quantity) {
        quant += 1;
        self.productModal.productQuantity = [NSString stringWithFormat:@"%ld",quant];
        self.productQuantityLbl.text = self.productModal.productQuantity;
    }
}

- (IBAction)addButtonTapped:(id)sender {
    
    if ([[GMSharedClass sharedClass] isInternetAvailable]) {
        
        self.totalProductsInCart ++;
        [self.cartView setHidden:NO];
        [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.totalProductsInCart]];
    }
    if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
        [self.delegate addProductModalInCart:self.productModal];
}

- (void)updateTotalProductItemsInCart {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.productModal.productid];
    NSArray *totalProducts = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count ) {
        
        self.totalProductsInCart = totalProducts.count;
        [self.cartView setHidden:NO];
        [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.totalProductsInCart]];
    }
    else {
        
        self.totalProductsInCart = 0;
        [self.cartView setHidden:YES];
    }
}

#pragma mark - Cell height

+ (CGFloat)cellHeightForNonPromotionalLabel {
    
    return 143.0f;
}

+ (CGFloat)cellHeightForPromotionalLabel {
    
    return 168.0f;
}

@end
