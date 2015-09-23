//
//  GMHotDealModal.h
//  GrocerMax
//
//  Created by arvind gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMHotDealBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *hotDealArray;

+ (instancetype)loadHotDeals;

- (void)archiveHotDeals;
@end

@interface GMHotDealModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *dealId;

@property (nonatomic, readonly, strong) NSString *dealType;

@property (nonatomic, readonly, strong) NSString *imageName;

@property (nonatomic, readonly, strong) NSString *imageURL;

- (void) setDealId:(NSString *)dealId;

- (void) setDealType:(NSString *)dealType;

- (void) setImageName:(NSString *)imageName;

- (void) setImageURL:(NSString *)imageURL;


@end
