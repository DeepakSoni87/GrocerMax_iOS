//
//  GMHotDealModal.m
//  GrocerMax
//
//  Created by arvind gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealBaseModal.h"

@interface GMHotDealBaseModal()

@property (nonatomic, readwrite, strong) NSArray *hotDealArray;

@end

@implementation GMHotDealBaseModal


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"hotDealArray"  : @"deal_type"
             };
}

+ (NSValueTransformer *)hotDealArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMHotDealModal class]];
}

@end

@interface GMHotDealModal()

@property (nonatomic, readwrite, strong) NSString *dealId;

@property (nonatomic, readwrite, strong) NSString *dealType;

@property (nonatomic, readwrite, strong) NSString *imageName;

@property (nonatomic, readwrite, strong) NSString *imageURL;

@end

@implementation GMHotDealModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"dealId"                    : @"id",
             @"dealType"                  : @"dealType",
             @"imageName"                 : @"img",
             @"imageURL"                  : @"img_url"
             };
}

@end
