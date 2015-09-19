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
    
    GMSubCategoryModal *subCategoryModal = (GMSubCategoryModal *)modal;
    
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
