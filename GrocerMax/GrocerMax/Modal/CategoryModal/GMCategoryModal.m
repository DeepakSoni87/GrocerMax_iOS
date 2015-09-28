 //
//  GMCategoryModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCategoryModal.h"

@interface GMCategoryModal()

@property (nonatomic, readwrite, strong) NSString *categoryId;

@property (nonatomic, readwrite, assign) NSInteger parentId;

@property (nonatomic, readwrite, strong) NSString *categoryName;

@property (nonatomic, readwrite, strong) NSString *isActive;

@property (nonatomic, readwrite, strong) NSString *position;

@property (nonatomic, readwrite, strong) NSString *level;

@property (nonatomic, readwrite, strong) NSArray *subCategories;

@property (nonatomic, readwrite, assign) BOOL isExpand;

@property (nonatomic, readwrite, assign) NSUInteger indentationLevel;

@property (nonatomic, readwrite, assign) BOOL isSelected;
@end

static GMCategoryModal *rootCategoryModal;

static NSString * const kCategoryIdKey                      = @"categoryId";
static NSString * const kParentIdKey                        = @"parentId";
static NSString * const kCategoryNameKey                    = @"categoryName";
static NSString * const kIsActiveKey                        = @"isActive";
static NSString * const kPositionKey                        = @"position";
static NSString * const kLevelKey                           = @"level";
static NSString * const kSubCategoriesKey                   = @"subCategories";
static NSString * const kIsExpandKey                        = @"isExpand";

@implementation GMCategoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"categoryId"                  : @"category_id",
             @"parentId"                    : @"parent_id",
             @"categoryName"                : @"name",
             @"isActive"                    : @"is_active",
             @"position"                    : @"position",
             @"level"                       : @"level",
             @"subCategories"               : @"children"
             };
}

+ (NSValueTransformer *)subCategoriesJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCategoryModal class]];
}

+ (instancetype)loadRootCategory {
    
    rootCategoryModal = [self unarchiveRootCategory];
    return rootCategoryModal;
}

+ (GMCategoryModal *)unarchiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"category"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        GMCategoryModal *rootCategoryModal  = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return rootCategoryModal;
    }
    return nil;
}

- (void)archiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"category"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    DLOG(@"archived : %d",success);
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.categoryId forKey:kCategoryIdKey];
    [aCoder encodeInteger:self.parentId forKey:kParentIdKey];
    [aCoder encodeObject:self.categoryName forKey:kCategoryNameKey];
    [aCoder encodeObject:self.isActive forKey:kIsActiveKey];
    [aCoder encodeObject:self.position forKey:kPositionKey];
    [aCoder encodeObject:self.level forKey:kLevelKey];
    [aCoder encodeObject:self.subCategories forKey:kSubCategoriesKey];
    [aCoder encodeObject:@(self.isExpand) forKey:kIsExpandKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.categoryId = [aDecoder decodeObjectForKey:kCategoryIdKey];
        self.parentId = [aDecoder decodeIntegerForKey:kParentIdKey];
        self.categoryName = [aDecoder decodeObjectForKey:kCategoryNameKey];
        self.isActive = [aDecoder decodeObjectForKey:kIsActiveKey];
        self.position = [aDecoder decodeObjectForKey:kPositionKey];
        self.level = [aDecoder decodeObjectForKey:kLevelKey];
        self.subCategories = [aDecoder decodeObjectForKey:kSubCategoriesKey];
        self.isExpand = [[aDecoder decodeObjectForKey:kIsExpandKey] boolValue];
    }
    return self;
}

@end
