//
//  GMAddressCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddressCell.h"

@implementation GMAddressCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.borderColor = [UIColor colorWithRed:216.0/256.0 green:216.0/256.0 blue:216.0/256.0 alpha:1].CGColor;
    self.cellBgView.layer.borderWidth = 2.0;
    self.cellBgView.layer.cornerRadius = 4.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
}

#pragma mark - GETTER/SETTER Methods

- (void)setEditAddressBtn:(GMButton *)editAddressBtn {
    
    _editAddressBtn = editAddressBtn;
    [_editAddressBtn setExclusiveTouch:YES];
}

- (void)setSelectUnSelectBtn:(GMButton *)selectUnSelectBtn {
    
    _selectUnSelectBtn = selectUnSelectBtn;
    [_selectUnSelectBtn setExclusiveTouch:YES];
}

- (void)configerViewWithData:(id)modal {
    
    GMAddressModalData *addressModalData = (GMAddressModalData *)modal;
    self.selectUnSelectBtn.addressModal = addressModalData;
    self.editAddressBtn.addressModal = addressModalData;
    
    if(addressModalData.isSelected)
        self.selectUnSelectBtn.selected = YES;
    else
        self.selectUnSelectBtn.selected = NO;
    
    NSString *mainStrign= @"";
    NSString *str1 = @"";
    
    self.addressLbl.numberOfLines = 3;
    mainStrign = [NSString stringWithFormat:@"%@",str1];
    
    if(NSSTRING_HAS_DATA(addressModalData.street)) {
        
        NSString *str2 = addressModalData.street;
        self.addressLbl.text = str2;
    }
    else
         self.addressLbl.text = @"";
    
//        mainStrign = [NSString stringWithFormat:@"%@\n%@",mainStrign,str2];
//   
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
//    
//    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:[mainStrign rangeOfString:str2]];
//    
//    
//    
//    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:[mainStrign rangeOfString:str2]];
//    
//    
//    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:str1]];
//    
//    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[mainStrign rangeOfString:str1]];
    
    
    
}

+ (CGFloat)cellHeight {
    
    return 116.0f;
}
@end
