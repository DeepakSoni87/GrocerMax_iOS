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
    
//    [self testData];
    
    self.subcategoryDataArray = [[NSMutableArray alloc]init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    self.subcategoryDataArray = [[self.rootCategoryModal.subCategories filteredArrayUsingPredicate:pred] mutableCopy];
    
    self.navigationController.title = self.rootCategoryModal.categoryName;
//    [self.subcategoryDataArray addObjectsFromArray:self.rootCategoryModal.subCategories];
    //[self testData];
}

-(void)testData {
    
    GMCategoryModal *rootModal = [GMCategoryModal loadRootCategory];
    GMCategoryModal *defaultCategory = rootModal.subCategories.firstObject;
    self.rootCategoryModal = defaultCategory.subCategories.firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    [subCategoryCell.subCategoryBtn3 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn3 setExclusiveTouch:YES];
    
    
    [subCategoryCell.subCategoryBtn2 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn2 setExclusiveTouch:YES];
    
    [subCategoryCell.subCategoryBtn1 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn1 setExclusiveTouch:YES];
    
    return subCategoryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 62.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return 115.0f;
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

-(void)actionHeaderBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:btnTag];
    
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
        
    }
    
    
}

-(void)actionSubCategoryBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:self.expandedIndex];;
    
    GMCategoryModal *categoryModal1 = [categoryModal.subCategories objectAtIndex:btnTag];
    //Rahut put your code here
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:categoryModal1.subCategories];
    [arr insertObject:categoryModal1 atIndex:0];
    
    GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
    rootVC.pageData = arr;
    rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
    [self.navigationController pushViewController:rootVC animated:YES];
}


@end
