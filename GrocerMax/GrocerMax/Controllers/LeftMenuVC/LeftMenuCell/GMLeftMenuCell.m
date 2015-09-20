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
@end

@implementation GMLeftMenuCell

- (void)configureWithCategoryName:(NSString *)categoryName {
    
    [self.categoryNameLabel setText:categoryName];
}

+ (CGFloat)cellHeight {
    
    return 40.0f;
}

@end
