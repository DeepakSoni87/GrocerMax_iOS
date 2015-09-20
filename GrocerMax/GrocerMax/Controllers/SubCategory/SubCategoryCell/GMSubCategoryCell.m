//
//  GMSubCategoryCell.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryCell.h"

@implementation GMSubCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configerViewWithData:(id)modal {
    
    NSMutableArray *subcategoryArray = (NSMutableArray *)modal;
    
    
    NSInteger cellTag = self.tag *3;
    self.subCategoryBtn1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.subCategoryBtn1.layer.borderWidth = 1.0;
    
    self.subCategoryBtn2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.subCategoryBtn2.layer.borderWidth = 1.0;
    
    self.subCategoryBtn3.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.subCategoryBtn3.layer.borderWidth = 1.0;
    
    if(subcategoryArray.count >= cellTag+3 )
    {
        self.subCategoryBtn3 .hidden = FALSE;
        self.subCategoryBtn2 .hidden = FALSE;
        self.subCategoryBtn1 .hidden = FALSE;
        
        self.subCategoryBtn3.tag = cellTag+2;
        self.subCategoryBtn2.tag = cellTag+1;
        self.subCategoryBtn1.tag = cellTag;
        GMCategoryModal *categoryModal3 = [subcategoryArray objectAtIndex:cellTag+2];
        GMCategoryModal *categoryModal2 = [subcategoryArray objectAtIndex:cellTag+1];
        GMCategoryModal *categoryModal1 = [subcategoryArray objectAtIndex:cellTag];
        
        [self.subCategoryBtn3 setTitle:categoryModal3.categoryName forState:UIControlStateNormal];
        [self.subCategoryBtn2 setTitle:categoryModal2.categoryName forState:UIControlStateNormal];
        [self.subCategoryBtn1 setTitle:categoryModal1.categoryName forState:UIControlStateNormal];
    }
    else if(subcategoryArray.count >= cellTag+2)
    {
        self.subCategoryBtn3 .hidden = TRUE;
        self.subCategoryBtn2 .hidden = FALSE;
        self.subCategoryBtn1 .hidden = FALSE;
        
        self.subCategoryBtn2.tag = cellTag+1;
        self.subCategoryBtn1.tag = cellTag;
        
        
        GMCategoryModal *categoryModal2 = [subcategoryArray objectAtIndex:cellTag+1];
        GMCategoryModal *categoryModal1 = [subcategoryArray objectAtIndex:cellTag];
        
        [self.subCategoryBtn2 setTitle:categoryModal2.categoryName forState:UIControlStateNormal];
        [self.subCategoryBtn1 setTitle:categoryModal1.categoryName forState:UIControlStateNormal];
    }
    else if(subcategoryArray.count >= cellTag+1 )
    {
        self.subCategoryBtn3 .hidden = TRUE;
        self.subCategoryBtn2 .hidden = TRUE;
        self.subCategoryBtn1 .hidden = FALSE;
        
        self.subCategoryBtn1.tag = cellTag;
        
        GMCategoryModal *categoryModal1 = [subcategoryArray objectAtIndex:cellTag];
        
        [self.subCategoryBtn1 setTitle:categoryModal1.categoryName forState:UIControlStateNormal];
    }
    else
    {
        self.subCategoryBtn3 .hidden = TRUE;
        self.subCategoryBtn2 .hidden = TRUE;
        self.subCategoryBtn2 .hidden = TRUE;
    }
    
    
}
@end