//
//  GMProductModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductModal.h"

@implementation GMProductListingBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"productsListArray"  : @"Product",
             @"totalcount"         : @"Totalcount",
             @"flag"               : @"flag"
             };
}

+ (NSValueTransformer *)productsListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMProductModal class]];
}

@end

@implementation GMProductModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"currencycode"       : @"currencycode",
             @"image"              : @"Image",
             @"name"               : @"Name",
             @"Price"              : @"Price",
             @"productid"          : @"productid",
             @"promotion_level"    : @"promotion_level",
             @"p_brand"            : @"p_brand",
             @"p_name"             : @"p_name",
             @"p_pack"             : @"p_pack",
             @"sale_price"         : @"sale_price",
             @"Status"             : @"Status",
             };
}

@end
