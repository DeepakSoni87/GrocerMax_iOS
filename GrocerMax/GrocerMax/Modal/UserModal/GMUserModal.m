//
//  GMUserModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMUserModal.h"
#import "GMEnums.h"

@interface GMUserModal()

@property (nonatomic, readwrite, strong) NSString *firstName;

@property (nonatomic, readwrite, strong) NSString *lastName;

@property (nonatomic, readwrite, strong) NSString *mobile;

@property (nonatomic, readwrite, strong) NSString *email;

@property (nonatomic, readwrite, strong) NSString *password;

@property (nonatomic, readwrite, strong) NSString *otp;

@property (nonatomic, readwrite, strong) NSString *userId;

@property (nonatomic, readwrite, strong) NSString *newpassword;

@property (nonatomic, readwrite, strong) NSString *conformPassword;

@end

static NSString * const kFirstNameKey                       = @"firstName";
static NSString * const kLastNameKey                        = @"lastName";
static NSString * const kMobileNumberKey                    = @"mobileNumber";
static NSString * const kEmailKey                           = @"email";
static NSString * const kPasswordKey                        = @"password";
static NSString * const kUserIdKey                          = @"userId";

static GMUserModal *loggedInUser;

@implementation GMUserModal

+ (instancetype)loggedInUser {
    
    if(!loggedInUser) {
        
        loggedInUser = [GMUserModal loadLoggedInUser];
    }
    return loggedInUser;
}


+ (GMUserModal *)loadLoggedInUser {
    
    GMUserModal *archivedUser = [[GMSharedClass sharedClass] getLoggedInUser];
    return archivedUser;
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.firstName forKey:kFirstNameKey];
    [aCoder encodeObject:self.lastName forKey:kLastNameKey];
    [aCoder encodeObject:self.mobile forKey:kMobileNumberKey];
    [aCoder encodeObject:self.email forKey:kEmailKey];
    [aCoder encodeObject:self.password forKey:kPasswordKey];
    [aCoder encodeObject:self.userId forKey:kUserIdKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.firstName = [aDecoder decodeObjectForKey:kFirstNameKey];
        self.lastName = [aDecoder decodeObjectForKey:kLastNameKey];
        self.mobile = [aDecoder decodeObjectForKey:kMobileNumberKey];
        self.email = [aDecoder decodeObjectForKey:kEmailKey];
        self.password = [aDecoder decodeObjectForKey:kPasswordKey];
        self.userId = [aDecoder decodeObjectForKey:kUserIdKey];
    }
    return self;
}

- (void)persistUser {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[GMSharedClass sharedClass] saveLoggedInUserWithData:encodedObject];
    loggedInUser = nil;
}

@end
