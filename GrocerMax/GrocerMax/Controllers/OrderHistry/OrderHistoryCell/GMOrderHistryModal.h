//
//  GMOrderHistryModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMOrderHistryModal : NSObject

@property(nonatomic,strong) NSString *orderId;
@property(nonatomic,strong) NSString *orderDate;
@property(nonatomic,strong) NSString *orderAmountPaid;
@property(nonatomic,strong) NSString *orderStatus;
@property(nonatomic,strong) NSString *orderItems;

@end
