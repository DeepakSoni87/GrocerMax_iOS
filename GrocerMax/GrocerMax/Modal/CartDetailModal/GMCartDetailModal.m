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
        _deletedProductItemsArray = [NSMutableArray array];
        
        if(HAS_DATA(responseDict, @"grand_total"))
            _grandTotal = responseDict[@"grand_total"];
        
        if(HAS_DATA(responseDict, @"subtotal"))
            _subTotal = responseDict[@"subtotal"];
        
        if(HAS_DATA(responseDict, @"coupon_code"))
            _couponCode = responseDict[@"coupon_code"];
        
        NSDictionary *shippingDict = responseDict[@"shipping_address"];
        
        if(HAS_DATA(shippingDict, @"tax_amount"))
            _taxAmount = shippingDict[@"tax_amount"];
        
        if(HAS_DATA(shippingDict, @"shipping_amount"))
            _shippingAmount = shippingDict[@"shipping_amount"];
        
        if(HAS_DATA(shippingDict, @"discount_amount"))
            _discountAmount = shippingDict[@"discount_amount"];
    }
    return self;
}
@end
