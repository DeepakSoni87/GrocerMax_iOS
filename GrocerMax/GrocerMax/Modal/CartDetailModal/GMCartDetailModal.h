//
//  GMCartDetailModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMCartDetailModal : NSObject

@property (nonatomic, strong) NSMutableArray *productItemsArray;

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)responseDict;
@end
