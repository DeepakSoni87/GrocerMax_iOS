//
//  GMSubCategoryHeaderView.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryHeaderView.h"

@implementation GMSubCategoryHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)configerViewWithData:(id)modal {
    
    
    self.cellBgView.layer.borderColor = [UIColor colorFromHexString:@"BEBEBE"].CGColor;
    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
    GMCategoryModal *subCategoryModal = (GMCategoryModal *)modal;
    
    if(subCategoryModal.isExpand)
    {
        self.stripView.layer.borderColor = [UIColor blackColor].CGColor;
        self.stripView.layer.borderWidth = 0.40;
        self.stripView.hidden = FALSE;
    }
    else
    {
        self.stripView.hidden = TRUE;
    }
    
    if(NSSTRING_HAS_DATA(subCategoryModal.categoryName))
    {
        self.titleLbl.text = subCategoryModal.categoryName;
    }
    else
    {
        self.titleLbl.text = @"";
    }
    
}

@end
