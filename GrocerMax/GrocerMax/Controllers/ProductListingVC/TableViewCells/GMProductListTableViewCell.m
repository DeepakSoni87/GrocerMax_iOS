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

#define kMAX_Quantity 1000

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

@property (nonatomic, assign) NSUInteger quantityValue;
@end

@implementation GMProductListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.addBtn.layer.cornerRadius = 5.0;
    self.addBtn.layer.masksToBounds = YES;
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

- (void)setBgVeiw:(UIView *)bgVeiw {
    
    _bgVeiw = bgVeiw;
    _bgVeiw.layer.cornerRadius = 5.0;
    _bgVeiw.layer.masksToBounds = YES;
    _bgVeiw.layer.borderWidth = 0.8;
    _bgVeiw.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

#pragma mark - Configure Cell

- (void)configureCellWithProductModal:(GMProductModal *)productModal andCartModal:(GMCartModal *)cartModal {
    
    self.productModal = productModal;
    self.cartModal = cartModal;
    self.addBtn.produtModal = productModal;
    self.imgBtn.produtModal = productModal;
    
    [self.productImgView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.productBrandLabel setText:self.productModal.p_brand.uppercaseString];
    [self.productNameLabel setText:self.productModal.p_name];
    [self.productPackLabel setText:self.productModal.p_pack];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmBlackColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@ | ",self.productModal.sale_price] attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@", self.productModal.Price] attributes:style2]];

    [self.productOfferLabel setAttributedText:attString];
    
//    [self.productOfferLabel setText:[NSString stringWithFormat:@"₹%@ | ₹%@", self.productModal.sale_price, self.productModal.Price]];
    
    self.promotionalLbl.text = self.productModal.promotion_level;
    self.quantityValue = self.productModal.productQuantity.integerValue > 0 ? self.productModal.productQuantity.integerValue : 1;
    self.productQuantityLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    [self updateTotalProductItemsInCart];
}

#pragma mark - stepper (+/-) Button Action

- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    if(self.quantityValue > 1) {
        
        self.quantityValue --;
        NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
        [self.productQuantityLbl setText:productQuantity];
        [self.productModal setProductQuantity:productQuantity];
    }
}

- (IBAction)pluseBtnPressed:(UIButton *)sender {
    
    self.quantityValue ++;
    NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    [self.productQuantityLbl setText:productQuantity];
    [self.productModal setProductQuantity:productQuantity];
}

- (IBAction)addButtonTapped:(id)sender {
    
    if ([[GMSharedClass sharedClass] isInternetAvailable]) {
        
        if([self isProductAddedIntoCart]) {
            
            NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.productModal];
            GMProductModal *productCartModal = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            [self.cartModal.cartItems addObject:productCartModal];
            [self.cartModal archiveCart];
            if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
                [self.delegate addProductModalInCart:self.productModal];
        }
        else {
            
            [self.cartModal archiveCart];
            if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
                [self.delegate addProductModalInCart:self.productModal];
        }
        self.productModal.productQuantity = nil;
        self.quantityValue = 1;
        self.productQuantityLbl.text = @"1";
    }
    else
        if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
            [self.delegate addProductModalInCart:self.productModal];
}

- (void)updateTotalProductItemsInCart {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.productModal.productid];
    NSArray *totalProducts = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count ) {
        
        GMProductModal *cartProductModal = [totalProducts firstObject];
        self.totalProductsInCart = cartProductModal.productQuantity.integerValue;
        [self.cartView setHidden:NO];
        [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.totalProductsInCart]];
    }
    else {
        
        self.totalProductsInCart = 0;
        [self.cartView setHidden:YES];
    }
}

- (BOOL)isProductAddedIntoCart {
    
    NSUInteger totalQuantity = self.quantityValue;
    totalQuantity += self.totalProductsInCart;
    [self.cartView setHidden:NO];
    [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%ld", totalQuantity]];
    self.productModal.productQuantity = [NSString stringWithFormat:@"%ld",totalQuantity];
    self.totalProductsInCart = totalQuantity;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.productModal.productid];
    NSArray *totalProducts = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count) {
        
        GMProductModal *cartProductModal = [totalProducts firstObject];
        [cartProductModal setProductQuantity:[NSString stringWithFormat:@"%ld", totalQuantity]];
        return NO;
    }
    return YES;
}

#pragma mark - Cell height

+ (CGFloat)cellHeightForNonPromotionalLabel {
    
    return 143.0f;
}

+ (CGFloat)cellHeightForPromotionalLabel {
    
    return 168.0f;
}

@end
