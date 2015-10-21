//
//  GMSubCategoryHeaderView.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryHeaderView.h"

@implementation GMSubCategoryHeaderView

- (void)configerViewWithData:(id)modal {
    
    
    self.cellBgView.layer.borderColor = [UIColor colorFromHexString:@"BEBEBE"].CGColor;
    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
    GMCategoryModal *subCategoryModal = (GMCategoryModal *)modal;
       NSString *categoryImageUrlStr = [NSString stringWithFormat:@"%@%@.png", [[GMSharedClass sharedClass] getCategoryImageBaseUrl],subCategoryModal.categoryId];
    [self.subcategoryImageView setImageWithURL:[NSURL URLWithString:categoryImageUrlStr] placeholderImage:[UIImage subCategoryPlaceHolderImage]];

}

@end
