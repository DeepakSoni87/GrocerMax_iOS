//
//  GMSearchVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 01/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSearchVC.h"
#import "GMSearchResultModal.h"
#import "GMRootPageViewController.h"

@interface GMSearchVC ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;

@end

@implementation GMSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Search";
    self.searchBarView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage backBtnImage]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(homeButtonPressed:)];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabSearch withCategory:@"" label:nil value:nil];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OpenSearch withCategory:@"" label:nil value:nil];

}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Search_Screen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button action

- (void)homeButtonPressed:(UIBarButtonItem*)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - Search bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBarView resignFirstResponder];
    
    if (!NSSTRING_HAS_DATA(self.searchBarView.text) || self.searchBarView.text.length < 3)
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterKeyword")];
        return;
    }
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:self.searchBarView.text forKey:kEY_keyword];
    
    [self performSearchOnServerWithParam:localDic];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - API Task

- (void)performSearchOnServerWithParam:(NSDictionary*)param {
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SearchQuery withCategory:@"" label:[param  objectForKey:kEY_keyword] value:nil];
    
    [self showProgress];
    [[GMOperationalHandler handler] search:param withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMSearchResultModal *searchResultModal = responceData;
        [self createCategoryModalFromSearchResult:searchResultModal];
        
        
        if (searchResultModal.categorysListArray.count == 0) {
            [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"noResultFound")];
            return;
        }
        
        [self.tabBarController setSelectedIndex:3];

        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = searchResultModal.categorysListArray;
        rootVC.navigationTitleString = self.searchBarView.text;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.isFromSearch = YES;
        [self.navigationController pushViewController:rootVC animated:YES];

    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (void)createCategoryModalFromSearchResult:(GMSearchResultModal *)searchModal {
    
    
    for (GMCategoryModal *catModal in searchModal.categorysListArray) {
        
        NSString *categoryId = catModal.categoryId;
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
            
            NSArray *categoriesIdArr = evaluatedObject.categoryIdArray;
            if([categoriesIdArr containsObject:categoryId])
                return YES;
            else
                return NO;
        }];
        NSArray *productListArr = [searchModal.productsListArray filteredArrayUsingPredicate:pred];
        catModal.productListArray = productListArr;
        catModal.totalCount = productListArr.count;
    }
}
@end
