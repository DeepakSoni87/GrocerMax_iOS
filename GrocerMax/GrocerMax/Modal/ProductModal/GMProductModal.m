//
//  GMProductModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductModal.h"

static NSString * const kCurrencyCodeKey                        = @"currencycode";
static NSString * const kProductImageKey                        = @"Image";
static NSString * const kNameKey                                = @"Name";
static NSString * const kPriceKey                               = @"Price";
static NSString * const kProductionKey                          = @"productid";
static NSString * const kPromotionLevelKey                      = @"promotion_level";
static NSString * const kP_BrandKey                             = @"p_brand";
static NSString * const kP_NameKey                              = @"p_name";
static NSString * const kP_PackKey                              = @"p_pack";
static NSString * const kSalePriceKey                           = @"sale_price";
static NSString * const kStatusKey                              = @"Status";
static NSString * const kProductQuantityKey                     = @"productQuantity";

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

#pragma mark -

- (instancetype)initWithResponseDict:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_KEY(responseDict, @"hotproduct")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"hotproduct"];
            
            for (NSDictionary *productDict in items) {
                GMCategoryModal *productModal = [[GMCategoryModal alloc] initWithProductListDictionary:productDict];
                [productItemsArr addObject:productModal];
            }
            _hotProductListArray = productItemsArr;
        }
        
        if(HAS_KEY(responseDict, @"ProductList")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"ProductList"];
            
            for (NSDictionary *productDict in items) {
                GMCategoryModal *productModal = [[GMCategoryModal alloc] initWithProductListDictionary:productDict];
                [productItemsArr addObject:productModal];
            }
            _productsListArray = productItemsArr;
        }
        
        if(HAS_DATA(responseDict, @"Totalcount"))
            _totalcount = [responseDict[@"Totalcount"] integerValue];
        
        if(HAS_DATA(responseDict, @"flag"))
            _flag = [responseDict[@"flag"] boolValue];
        
    }
    
    return self;
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
             @"Status"             : @"Status"
//             @"categoryidArray"    : @"categoryid"
             };
}

//+ (NSValueTransformer *)categoryidArrayJSONTransformer {
//    
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}

- (instancetype)initWithProductItemDict:(NSDictionary *)productDict {
    
    if(self = [super init]) {
        
        if(HAS_DATA(productDict, @"p_brand"))
            _p_brand = productDict[@"p_brand"];
        
        if(HAS_DATA(productDict, @"p_name"))
            _p_name = productDict[@"p_name"];
        
        if(HAS_DATA(productDict, @"p_pack"))
            _p_pack = productDict[@"p_pack"];
        
        if(HAS_DATA(productDict, @"mrp"))
            _Price = productDict[@"mrp"];
        
        if(HAS_DATA(productDict, @"product_thumbnail"))
            _image = productDict[@"product_thumbnail"];
        
        if(HAS_DATA(productDict, @"name"))
            _name = productDict[@"name"];
        
        if(HAS_DATA(productDict, @"product_id"))
            _productid = productDict[@"product_id"];
        
        if(HAS_DATA(productDict, @"sku"))
            _sku = productDict[@"sku"];
        
        if(HAS_DATA(productDict, @"promotion_level"))
            _promotion_level = productDict[@"promotion_level"];
        
        if(HAS_DATA(productDict, @"no_discount"))
            _noDiscount = productDict[@"no_discount"];
        
        if(HAS_DATA(productDict, @"price"))
            _sale_price = productDict[@"price"];
        
        if(HAS_KEY(productDict, @"qty"))
            _productQuantity = [NSString stringWithFormat:@"%@", productDict[@"qty"]];
        
    }
    return self;
}

- (instancetype)initWithProductModal:(GMProductModal *)productModal {
    
    if(self = [super init]) {
        
        _p_brand = productModal.p_brand;
        _p_pack = productModal.p_pack;
        _Price = productModal.Price;
        _image = productModal.image;
        _name = productModal.name;
        _productid = productModal.productid;
        _sku = productModal.sku;
        _promotion_level = productModal.promotion_level;
        _noDiscount = productModal.noDiscount;
        _sale_price = productModal.sale_price;
        _productQuantity = productModal.productQuantity;
    }
    return self;
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.currencycode forKey:kCurrencyCodeKey];
    [aCoder encodeObject:self.image forKey:kProductImageKey];
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.Price forKey:kPriceKey];
    [aCoder encodeObject:self.productid forKey:kProductionKey];
    [aCoder encodeObject:self.promotion_level forKey:kPromotionLevelKey];
    [aCoder encodeObject:self.p_brand forKey:kP_BrandKey];
    [aCoder encodeObject:self.p_name forKey:kP_NameKey];
    [aCoder encodeObject:self.p_pack forKey:kP_PackKey];
    [aCoder encodeObject:self.sale_price forKey:kSalePriceKey];
    [aCoder encodeObject:self.Status forKey:kStatusKey];
    [aCoder encodeObject:self.productQuantity forKey:kProductQuantityKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.currencycode = [aDecoder decodeObjectForKey:kCurrencyCodeKey];
        self.image = [aDecoder decodeObjectForKey:kProductImageKey];
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.Price = [aDecoder decodeObjectForKey:kPriceKey];
        self.productid = [aDecoder decodeObjectForKey:kProductionKey];
        self.promotion_level = [aDecoder decodeObjectForKey:kPromotionLevelKey];
        self.p_brand = [aDecoder decodeObjectForKey:kP_BrandKey];
        self.p_name = [aDecoder decodeObjectForKey:kP_NameKey];
        self.p_pack = [aDecoder decodeObjectForKey:kP_PackKey];
        self.sale_price = [aDecoder decodeObjectForKey:kSalePriceKey];
        self.Status = [aDecoder decodeObjectForKey:kStatusKey];
        self.productQuantity = [aDecoder decodeObjectForKey:kProductQuantityKey];
    }
    return self;
}


@end
