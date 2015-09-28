//
//  GMProductListTableViewCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMProductModal;
@class GMCartModal;

@protocol GMProductListCellDelegate <NSObject>

- (void)addProductModalInCart:(GMProductModal *)productModal;

@end

@interface GMProductListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet GMButton *addBtn;

@property (nonatomic, strong) id <GMProductListCellDelegate> delegate;

- (void)configureCellWithProductModal:(GMProductModal *)productModal andCartModal:(GMCartModal *)cartModal;

+ (CGFloat)cellHeightForNonPromotionalLabel;

+ (CGFloat)cellHeightForPromotionalLabel;

@end
