//
//  GMStateBaseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMStateBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *stateArray;
@end

@interface GMStateModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *regionId;

@property (nonatomic, readonly, strong) NSString *stateName;

@property (nonatomic, readonly, strong) NSArray *cityArray;
@end

@interface GMCityModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *cityId;

@property (nonatomic, readonly, strong) NSString *cityName;
@end