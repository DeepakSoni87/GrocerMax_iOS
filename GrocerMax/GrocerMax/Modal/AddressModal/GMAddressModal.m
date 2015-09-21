//
//  GMAddressModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddressModal.h"

@interface GMAddressModal()

@property (nonatomic, readwrite, strong) NSArray *addressArray;
@end

@implementation GMAddressModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"addressArray"                  : @"BillingAddress"
             };
}

+ (NSValueTransformer *)addressArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMAddressModalData class]];
}
@end


@implementation GMAddressModalData


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"customer_address_id"     : @"customer_address_id",
             @"created_at"              : @"created_at",
             @"update_at"               : @"updated_at",
             @"city"                    : @"city",
             @"contryId"                : @"country_id",
             @"firstName"               : @"firstname",
             @"lastName"                : @"lastname",
             @"latitude"                : @"latitude",
             @"logidutude"              : @"longitude",
             @"pincode"                 : @"postcode",
             @"region"                  : @"region",
             @"region_id"               : @"region_id",
             @"street"                  : @"street",
             @"telephone"               : @"telephone",
             @"userType"                : @"usertype",
             @"is_default_billing"      : @"is_default_billing",
             @"is_default_shipping"     : @"is_default_shipping",
             };
}


@end
