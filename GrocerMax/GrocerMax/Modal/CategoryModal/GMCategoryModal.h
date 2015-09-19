//
//  GMCategoryModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMCategoryModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *categoryId;

@property (nonatomic, readonly, strong) NSString *parentId;

@property (nonatomic, readonly, strong) NSString *categoryName;

@property (nonatomic, readonly, strong) NSString *isActive;

@property (nonatomic, readonly, strong) NSString *position;

@property (nonatomic, readonly, strong) NSString *level;

@property (nonatomic, readonly, strong) NSArray *subCategories;

@property (nonatomic, readonly, assign) BOOL isExpand;

+ (instancetype)loadRootCategory;

- (void)archiveRootCategory;

- (void)setCategoryId:(NSString *)categoryId;

- (void)setParentId:(NSString *)parentId;

- (void)setCategoryName:(NSString *)categoryName;

- (void)setIsActive:(NSString *)isActive;

- (void)setPosition:(NSString *)position;

- (void)setLevel:(NSString *)level;

- (void)setSubCategories:(NSArray *)subCategories;

- (void)setIsExpand:(BOOL)isExpand;
@end
