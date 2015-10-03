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
//    self.searchBarView.barTintColor = [UIColor clearColor];
//    self.searchBarView.backgroundImage = [UIImage new];
//    self.searchBarView.backgroundColor = [UIColor clearColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBarView resignFirstResponder];
    
    if (!NSSTRING_HAS_DATA(self.searchBarView.text) || self.searchBarView.text.length < 3)
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterKeyword")];
        return;
    }
    
    [self performSearchOnServer];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView resignFirstResponder];
}

#pragma mark - API Task

-(void)performSearchOnServer {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:self.searchBarView.text forKey:kEY_keyword];
    
    [self showProgress];
    [[GMOperationalHandler handler] search:localDic withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMSearchResultModal *searchResultModal = responceData;
        
        if (searchResultModal.categorysListArray.count == 0) {
            [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"noResultFound")];
            return;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = searchResultModal.categorysListArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        [self.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

@end
