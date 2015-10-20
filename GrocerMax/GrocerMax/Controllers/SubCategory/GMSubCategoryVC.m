//
//  GMSubCategoryVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryVC.h"
#import "GMSubCategoryHeaderView.h"
#import "GMCategoryModal.h"
#import "GMSubCategoryCell.h"
#import "GMRootPageViewController.h"

static NSString *kIdentifierSubCategoryHeader = @"subcategoryIdentifierHeader";
static NSString *kIdentifierSubCategoryCell = @"subcategoryIdentifierCell";


@interface GMSubCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *subCategoryTableView;

@property (assign, nonatomic) NSInteger  expandedIndex;
@end

@implementation GMSubCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    self.navigationController.navigationBarHidden = NO;
    self.subcategoryDataArray = [[NSMutableArray alloc]init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    self.subcategoryDataArray = [[self.rootCategoryModal.subCategories filteredArrayUsingPredicate:pred] mutableCopy];
    
    self.navigationController.title = self.rootCategoryModal.categoryName;
    if(NSSTRING_HAS_DATA(self.rootCategoryModal.categoryName)) {
        self.title = self.rootCategoryModal.categoryName;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(NSSTRING_HAS_DATA(self.rootCategoryModal.categoryName)) {
        self.title = self.rootCategoryModal.categoryName;
    }
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_SubCategory_Screen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMSubCategoryHeaderView" bundle:[NSBundle mainBundle]];
    [self.subCategoryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierSubCategoryHeader];
    
    nib = [UINib nibWithNibName:@"GMSubCategoryCell" bundle:[NSBundle mainBundle]];
    [self.subCategoryTableView registerNib:nib forCellReuseIdentifier:kIdentifierSubCategoryCell];
    
}

#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.subcategoryDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:section];
    
    if(categoryModal.isExpand)
    {
        if(section == self.expandedIndex) {
            if(categoryModal.subCategories.count%3 == 0) {
                return categoryModal.subCategories.count/3;
            }
            else {
                return (categoryModal.subCategories.count/3) + 1;
            }
            
        }
        else {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMSubCategoryCell *subCategoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierSubCategoryCell];
    subCategoryCell.tag = indexPath.row;
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:indexPath.section];
    [subCategoryCell configerViewWithData:categoryModal.subCategories];
    
//    [subCategoryCell.subCategoryBtn3 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [subCategoryCell.subCategoryBtn3 setExclusiveTouch:YES];
    
    
    [subCategoryCell.subCategoryBtn2 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn2 setExclusiveTouch:YES];
    
    [subCategoryCell.subCategoryBtn1 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn1 setExclusiveTouch:YES];
    
    return subCategoryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 114.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView;
   GMSubCategoryHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierSubCategoryHeader];
    if (!header) {
                    header = [[GMSubCategoryHeaderView alloc] initWithReuseIdentifier:kIdentifierSubCategoryHeader];
            }
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:section];
    header.subcategoryBtn.tag = section;
    [header.subcategoryBtn addTarget:self action:@selector(actionHeaderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header.subcategoryBtn setExclusiveTouch:YES];
    [header configerViewWithData:categoryModal];
     headerView = header;
    return headerView;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubcategoryScroller withCategory:@"" label:nil value:nil];
}

#pragma mark -

-(void)actionHeaderBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:btnTag];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubCategorySelection withCategory:@"" label:categoryModal.categoryName value:nil];
    if(categoryModal.isExpand)
    {
        if(self.expandedIndex != btnTag)
        {
            self.expandedIndex = btnTag;
            [self.subCategoryTableView reloadData];
        }
    }
    else
    {
        //Rahut put your code here
        
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:categoryModal.subCategories];
//        [arr insertObject:categoryModal atIndex:0];
//        
//        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
//        rootVC.pageData = arr;
//        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
//        [self.navigationController pushViewController:rootVC animated:YES];
        
        [self fetchProductListingDataForCategory:categoryModal];
    }
}

- (void)actionSubCategoryBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:self.expandedIndex];;
    
    GMCategoryModal *categoryModal1 = [categoryModal.subCategories objectAtIndex:btnTag];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubCategoryNext withCategory:@"" label:categoryModal1.categoryName value:nil];
    
    [self fetchProductListingDataForCategory:categoryModal1];

}

#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    
    [self showProgress];
    [[GMOperationalHandler handler] productListAll:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = categoryModal.categoryName;
        [self.navigationController pushViewController:rootVC animated:YES];

    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

@end
