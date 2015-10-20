//
//  GMHomeBannerModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 04/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHomeBannerModal.h"

@implementation GMHomeBannerBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"bannerListArray"  : @"banner"};
}

+ (NSValueTransformer *)bannerListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMHomeBannerModal class]];
}

@end

@implementation GMHomeBannerModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"name"        : @"name",
             @"linkUrl"     : @"linkurl",
             @"imageUrl"    : @"imageurl"
             };
}


- (GMHomeBannerModal *) initWithDictionary:(NSDictionary *)notificationDetailDic {
    
    if([notificationDetailDic objectForKey:@"name"]) {
        [self setName:[NSString stringWithFormat:@"%@",[notificationDetailDic objectForKey:@"name"]]];
    }
    if([notificationDetailDic objectForKey:@"linkurl"]) {
        [self setLinkUrl:[NSString stringWithFormat:@"%@",[notificationDetailDic objectForKey:@"linkurl"]]];
    }
    if([notificationDetailDic objectForKey:@"imageurl"]) {
        [self setImageUrl:[NSString stringWithFormat:@"%@",[notificationDetailDic objectForKey:@"imageurl"]]];
    }
    
    return self;
    
}

@end
