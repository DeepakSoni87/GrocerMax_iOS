//
//  GMSubCategoryVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryVC.h"
#import "GMSubCategoryHeaderView.h"
#import "GMSubCategoryHeaderView+GMSubcategoryConfiger.h"
#import "GMSubCategoryModal.h"
#import "GMSubCategoryCell.h"
#import "GMSubCategoryCell+GMSubCategory.h"

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
    [self testData];
}

-(void)testData {
    NSMutableArray *data = [[NSMutableArray alloc]init];
    [data addObject:@"Oil & Ghee"];
    [data addObject:@"Dry Fruit"];
    [data addObject:@"Salt & Masalas"];
    [data addObject:@"Salt & Masalas"];
    [data addObject:@"Dry Fruit"];
    [data addObject:@"Dry Fruit"];
    
    [data addObject:@"Oil & Ghee"];
    [data addObject:@"Dry Fruit"];
    [data addObject:@"Salt & Masalas"];
    [data addObject:@"Salt & Masalas"];
    [data addObject:@"Dry Fruit"];
    [data addObject:@"Dry Fruit"];
    
    
    
    
    for(int i = 0; i<data.count; i++)
    {
        GMSubCategoryModal *subCategoryModal = [[GMSubCategoryModal alloc]init];
        subCategoryModal.categoryName = [data objectAtIndex:i];
        subCategoryModal.categoryId  = [NSString stringWithFormat:@"%d",i];
        subCategoryModal.subcategoryArray = [[NSMutableArray alloc]init];
        if(i ==0)
        {
            self.expandedIndex = i;
            subCategoryModal.isExpand = TRUE;
            [subCategoryModal.subcategoryArray addObject:[NSString stringWithFormat:@"Dried Nuts %d0",i]];
        }
        for(int k = 0; k<i; k++)
        {
            [subCategoryModal.subcategoryArray addObject:[NSString stringWithFormat:@"Dried Nuts %d%d",i,k]];
        }
        [self.subcategoryDataArray addObject:subCategoryModal];
    }

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
   
        GMSubCategoryModal *subCategoryModal = [self.subcategoryDataArray objectAtIndex:section];
    if(subCategoryModal.isExpand) {
        if(subCategoryModal.subcategoryArray.count%3 == 0) {
            return subCategoryModal.subcategoryArray.count/3;
        }
        else {
            return (subCategoryModal.subcategoryArray.count/3) + 1;
        }
        
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMSubCategoryCell *subCategoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierSubCategoryCell];
    subCategoryCell.tag = indexPath.row;
    GMSubCategoryModal *subCategoryModal = [self.subcategoryDataArray objectAtIndex:indexPath.section];
    [subCategoryCell configerViewWithData:subCategoryModal.subcategoryArray];
    
    [subCategoryCell.subCategoryBtn3 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn3 setExclusiveTouch:YES];
    
    
    [subCategoryCell.subCategoryBtn2 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn2 setExclusiveTouch:YES];
    
    [subCategoryCell.subCategoryBtn1 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subCategoryCell.subCategoryBtn1 setExclusiveTouch:YES];
    
    return subCategoryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 45.0;
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
//    header.tag = section;
    if (!header) {
                    header = [[GMSubCategoryHeaderView alloc] initWithReuseIdentifier:kIdentifierSubCategoryHeader];
            }
    GMSubCategoryModal *subCategoryModal = [self.subcategoryDataArray objectAtIndex:section];
    header.subcategoryBtn.tag = section;
    [header.subcategoryBtn addTarget:self action:@selector(actionHeaderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header.subcategoryBtn setExclusiveTouch:YES];
    [header configerViewWithData:subCategoryModal];
     headerView = header;
    return headerView;
}

-(void)actionHeaderBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    if(self.expandedIndex != btnTag)
    {
        GMSubCategoryModal *subCategoryModal = [self.subcategoryDataArray objectAtIndex:btnTag];
        subCategoryModal.isExpand = TRUE;
        
        GMSubCategoryModal *tempSubCategoryModal = [self.subcategoryDataArray objectAtIndex:self.expandedIndex];
        tempSubCategoryModal.isExpand = FALSE;
        
        self.expandedIndex = btnTag;
        [self.subCategoryTableView reloadData];
    }
    
}

-(void)actionSubCategoryBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    GMSubCategoryModal *subCategoryModal = [self.subcategoryDataArray objectAtIndex:self.expandedIndex];
    
    [subCategoryModal.subcategoryArray objectAtIndex:btnTag];
    
    [[GMSharedClass sharedClass] showInfoMessage:[subCategoryModal.subcategoryArray objectAtIndex:btnTag]];
}



@end
