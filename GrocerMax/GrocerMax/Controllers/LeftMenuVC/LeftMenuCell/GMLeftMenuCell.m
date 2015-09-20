//
//  GMLeftMenuCell.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuCell.h"

@interface GMLeftMenuCell()

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet UIImageView *expandArrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@end

NSUInteger const leftMargin = 15;

@implementation GMLeftMenuCell

- (void)configureWithCategoryName:(NSString *)categoryName {
    
    [self.categoryNameLabel setText:categoryName];
    [self.expandArrowImageView setHidden:NO];
//    [self.arrowImageView setHidden:NO];
}

- (void)configureCellWith:(GMCategoryModal *)categoryModal {
    
    [self.arrowImageView setHidden:YES];
    [self.categoryNameLabel setText:categoryModal.categoryName];
    [self.expandArrowImageView setHighlighted:categoryModal.isExpand];
    [self setIdentationLevelOfCustomCell:categoryModal.indentationLevel];
    if(categoryModal.isExpand)
        [self.expandArrowImageView setHidden:NO];
    else
        [self.expandArrowImageView setHidden:YES];
}

- (void)setIdentationLevelOfCustomCell:(NSUInteger)level {
    
    self.leftMarginConstraint.constant = leftMargin + (leftMargin * level);
}

+ (CGFloat)cellHeight {
    
    return 40.0f;
}

- (void)maskCellFromTop:(CGFloat)margin {
    self.layer.mask = [self visibilityMaskWithLocation:margin/self.frame.size.height];
    self.layer.masksToBounds = YES;
}

- (CAGradientLayer *)visibilityMaskWithLocation:(CGFloat)location {
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = self.bounds;
    mask.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor colorWithWhite:1 alpha:1] CGColor], nil];
    mask.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location], [NSNumber numberWithFloat:location], nil];
    return mask;
}

@end
