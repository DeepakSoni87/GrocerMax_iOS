//
//  GMRootPageAPIController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageAPIController.h"
#import "GMProductModal.h"

@implementation GMRootPageAPIController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalDic = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(GMCategoryModal*)catModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:catModal.categoryId forKey:kEY_cat_id];
    
    if ([self.modalDic objectForKey:catModal.categoryId]) {
        GMProductListingBaseModal *baseModal = [self.modalDic objectForKey:catModal.categoryId];
        
        if (baseModal.totalcount == baseModal.productsListArray.count) {
            
            return; // no more api hit
        }
        
        NSInteger pageNumber = (baseModal.productsListArray.count/10) + 1;
        [localDic setObject:@(pageNumber) forKey:kEY_page];
        
    }else{
        [localDic setObject:@"1" forKey:kEY_page];
    }
    
    [[GMOperationalHandler handler] productList:localDic withSuccessBlock:^(id responceData) {
        
        GMProductListingBaseModal *oldModal = [self.modalDic objectForKey:catModal.categoryId];
        
        GMProductListingBaseModal *newModal = responceData;
        if (oldModal.productsListArray.count != 0) {
            newModal.productsListArray = [oldModal.productsListArray arrayByAddingObjectsFromArray:newModal.productsListArray];
        }
        [self.modalDic setObject:newModal forKey:catModal.categoryId];
        
        if ([self.delegate respondsToSelector:@selector(rootPageAPIControllerDidFinishTask:)]) {
            [self.delegate rootPageAPIControllerDidFinishTask:self];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

@end
