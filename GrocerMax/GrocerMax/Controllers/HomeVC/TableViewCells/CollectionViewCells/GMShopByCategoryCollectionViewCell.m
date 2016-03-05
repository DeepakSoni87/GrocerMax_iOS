//
//  GMShopByCategoryCollectionViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShopByCategoryCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

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
    self.offerBtn.layer.borderColor = [UIColor colorWithRGBValue:249 green:224 blue:221].CGColor;
}

- (void)setTitleLbl:(UILabel *)titleLbl {
    
    _titleLbl = titleLbl;
    [_titleLbl setHidden:YES];
}

#pragma mark - Configure Cell

- (void)configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
    GMCategoryModal *mdl = data;
//    NSString *categoryImageUrlStr = [NSString stringWithFormat:@"%@%@.png", [[GMSharedClass sharedClass] getCategoryImageBaseUrl],mdl.categoryId];
//    [self.bgImgView setImageWithURL:[NSURL URLWithString:categoryImageUrlStr] placeholderImage:nil];
//    [self.bgImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cat-%@", mdl.categoryId]]];
    
    [self.bgImgView setImageWithURL:[NSURL URLWithString:mdl.categoryImageURL] placeholderImage:[UIImage categoryPlaceHolderImage]];
    
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
    [self.offerBtn setTitle:[NSString stringWithFormat:@"%li OFFERS",(long)[mdl.offercount integerValue]] forState:UIControlStateNormal];
    self.offerBtn.tag = indexPath.item;
}

@end
