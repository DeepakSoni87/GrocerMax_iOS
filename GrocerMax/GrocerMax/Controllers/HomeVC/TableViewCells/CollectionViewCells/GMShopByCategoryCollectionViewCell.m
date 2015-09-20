//
//  GMShopByCategoryCollectionViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShopByCategoryCollectionViewCell.h"

@interface GMShopByCategoryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation GMShopByCategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bgImgView.layer.cornerRadius = 2.0;
    self.bgImgView.layer.masksToBounds = YES;
    
    self.offerBtn.layer.borderWidth = 0.50;
    self.offerBtn.layer.borderColor = [self.offerBtn.titleLabel.textColor colorWithAlphaComponent:0.3].CGColor;
}

#pragma mark - Configure Cell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
    GMCategoryModal *mdl = data;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];

    NSArray *activeCategories = [mdl.subCategories filteredArrayUsingPredicate:pred];
    NSMutableArray *strArr = [NSMutableArray new];
    
    for (GMCategoryModal *tempMdl in activeCategories) {
        [strArr addObject:tempMdl.categoryName];
    }
    
    NSDictionary* style1 = @{
                             NSFontAttributeName:FONT_LIGHT(16),
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName:FONT_LIGHT(12),
                             NSForegroundColorAttributeName : [UIColor lightGrayColor]
                             };
    
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",mdl.categoryName] attributes:style1];

    [attString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[strArr componentsJoinedByString:@","] attributes:style2]];
    
    self.titleLbl.attributedText = attString1;
    [self.offerBtn setTitle:@"20 OFFERS >" forState:UIControlStateNormal];
    self.offerBtn.tag = indexPath.item;
}

@end
