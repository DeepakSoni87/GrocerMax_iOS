//
//  GMCartDetailModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartDetailModal.h"
#import "GMProductModal.h"

@implementation GMCartDetailModal

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_KEY(responseDict, @"items")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"items"];
            for (NSDictionary *productDict in items) {
                
                GMProductModal *productModal = [[GMProductModal alloc] initWithProductItemDict:productDict];
                [productItemsArr addObject:productModal];
            }
            _productItemsArray = productItemsArr;
        }
        
    }
    return self;
}
@end
