//
//  GMOffersByDealTypeModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 24/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOffersByDealTypeModal.h"

@implementation GMOffersByDealTypeBaseModal


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"allArray"            : @"dealcategorylisting.all",
            @"deal_categoryArray"  : @"dealcategorylisting.dealsCategory",
            @"flag"                : @"flag"
            };//
//    return @{@"allArray"            : @"dealcategorylisting.all",
//             @"deal_categoryArray"  : @"dealcategorylisting.dealsCategory",
//             @"flag"                : @"flag"
//             };//
}

+ (NSValueTransformer *)allArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMOffersByDealTypeModal class]];
}

+ (NSValueTransformer *)deal_categoryArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMOffersByDealTypeModal class]];
}

@end

@implementation GMOffersByDealTypeModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"dealType"                  : @"dealType",
             @"ID"                        : @"id",
             @"img"                       : @"img"
             };
}


@end
