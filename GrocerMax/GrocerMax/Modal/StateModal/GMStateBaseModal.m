//
//  GMStateBaseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMStateBaseModal.h"

@interface GMStateBaseModal()

@property (nonatomic, readwrite, strong) NSArray *stateArray;
@end

@implementation GMStateBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"stateArray"                  : @"state"
             };
}

+ (NSValueTransformer *)stateArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMStateModal class]];
}

@end

@interface GMStateModal()

@property (nonatomic, readwrite, strong) NSString *regionId;

@property (nonatomic, readwrite, strong) NSString *stateName;

@property (nonatomic, readwrite, strong) NSArray *cityArray;
@end

@implementation GMStateModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"regionId"                  : @"region_id",
             @"stateName"                 : @"default_name",
             @"cityArray"                 : @"city"
             };
}

+ (NSValueTransformer *)cityArraySlotArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCityModal class]];
}
@end

@interface GMCityModal()

@property (nonatomic, readwrite, strong) NSString *cityId;

@property (nonatomic, readwrite, strong) NSString *cityName;
@end

@implementation GMCityModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"cityId"                  : @"id",
             @"cityName"                : @"name"
             };
}

@end