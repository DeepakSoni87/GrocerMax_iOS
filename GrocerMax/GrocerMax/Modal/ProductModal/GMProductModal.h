//
//  GMProductModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMProductListingBaseModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *productsListArray;
@property (assign, nonatomic) NSInteger totalcount;
@property (assign, nonatomic) BOOL flag;

@end

@interface GMProductModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *currencycode;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *Price;
@property (strong, nonatomic) NSString *productid;
@property (strong, nonatomic) NSString *promotion_level;
@property (strong, nonatomic) NSString *p_brand;
@property (strong, nonatomic) NSString *p_name;
@property (strong, nonatomic) NSString *p_pack;
@property (strong, nonatomic) NSString *sale_price;
@property (strong, nonatomic) NSString *Status;

@end