//
//  GMProductListTableViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListTableViewCell.h"
#import "GMProductModal.h"


@interface GMProductListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *promotionalLbl;

@property (weak, nonatomic) IBOutlet UIView *bgVeiw;

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionalLblHeightConstraints;
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

#pragma mark - Configure Cell

- (void)configureCellWithProductModal:(GMProductModal *)productModal {
    
    GMProductModal *mdl = productModal;
    self.addBtn.produtModal = productModal;
    
    [self.productImgView setImageWithURL:[NSURL URLWithString:mdl.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
     
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",mdl.p_brand] attributes:@{
    NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor redColor]}];
    
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",mdl.p_name] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",mdl.p_pack] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@ | ",mdl.sale_price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(12),NSForegroundColorAttributeName : [UIColor blackColor]}]];

    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@",mdl.Price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(12),NSForegroundColorAttributeName : [UIColor redColor],NSStrikethroughStyleAttributeName : @1.0}]];

    self.productDescriptionLbl.attributedText = attString;
    
    if (productModal.promotion_level.length > 1 )
        self.promotionalLblHeightConstraints.constant = 20;
    else
        self.promotionalLblHeightConstraints.constant = 0;
    
    self.promotionalLbl.text = mdl.promotion_level;

}

#pragma mark - Cell height

+ (CGFloat)cellHeightForNonPromotionalLabel {
    
    return 140.0f;
}

+ (CGFloat)cellHeightForPromotionalLabel {
    
    return 160.0f;
}

@end
