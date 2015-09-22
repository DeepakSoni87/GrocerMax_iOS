//
//  GMUserModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMUserModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *firstName;

@property (nonatomic, readonly, strong) NSString *lastName;

@property (nonatomic, readonly, strong) NSString *mobile;

@property (nonatomic, readonly, strong) NSString *email;

@property (nonatomic, readonly, strong) NSString *password;

@property (nonatomic, readonly, strong) NSString *otp;

@property (nonatomic, readwrite, assign) GMGenderType gender;

@property (nonatomic, readonly, strong) NSString *userId;

@property (nonatomic, readonly, strong) NSString *quoteId;

@property (nonatomic, readonly, strong) NSNumber *totalItem;

- (void)setFirstName:(NSString *)firstName;

- (void)setLastName:(NSString *)lastName;

- (void)setMobile:(NSString *)mobile;

- (void)setEmail:(NSString *)email;

- (void)setPassword:(NSString *)password;

- (void)setGender:(GMGenderType)gender;

- (void)setOtp:(NSString *)otp;

- (void)setUserId:(NSString *)userId;

- (void)setQuoteId:(NSString *)quoteId;

- (void)setTotalItem:(NSNumber *)totalItem;

+ (instancetype)loggedInUser;

- (void)persistUser;
@end
