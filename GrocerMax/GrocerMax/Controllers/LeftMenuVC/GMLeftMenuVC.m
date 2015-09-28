//
//  GMLeftMenuVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuVC.h"
#import "GMLeftMenuCell.h"
#import "GMCategoryModal.h"
#import "GMSectionView.h"
#import "GMLeftMenuDetailVC.h"
#import "GMOtpVC.h"
#import "GMHotDealBaseModal.h"

#pragma mark - Interface/Implementation SectionModal

@interface SectionModal : NSObject

@property (nonatomic, strong) NSString *sectionDisplayName;
@property (nonatomic, strong) NSMutableArray *rowArray;
@property (nonatomic, assign) BOOL isExpanded;

- (instancetype)initWithDisplayName:(NSString *)displayName andRowArray:(NSMutableArray *)rowArray;
@end

@implementation SectionModal

- (instancetype)initWithDisplayName:(NSString *)displayName andRowArray:(NSMutableArray *)rowArray {
    
    if(self = [super init]) {
        
        _sectionDisplayName = displayName;
        _rowArray = rowArray;
        _isExpanded = NO;
    }
    return self;
}
@end

#pragma mark - Interface/Implementation GMLeftMenuVC

@interface GMLeftMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftMenuTableView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic) SectionModal* preSelectedSectionMdl;

@end

static NSString * const kLeftMenuCellIdentifier                     = @"leftMenuCellIdentifier";

static NSString * const kShopByCategorySection                      =  @"SHOP BY CATEGORIES";
static NSString * const kShopByDealSection                          =  @"SHOP BY DEALS";
static NSString * const kGetInTouchSection                          =  @"GET IN TOUCH WITH US";
static NSString * const kPaymentSection                             =  @"PAYMENTS METHODS";


@implementation GMLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
//    [self createSectionArray];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self createSectionArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    [self.leftMenuTableView registerNib:[UINib nibWithNibName:@"GMLeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCellIdentifier];
}

- (void)createSectionArray {
    
    NSMutableArray *shopByCatArray = [self fetchShopByCategoriesFromDB];
    NSMutableArray *hotDeals = [self fetchHotDealsFromDB];

    [self.sectionArray removeAllObjects];
    SectionModal *shopByCat = [[SectionModal alloc] initWithDisplayName:kShopByCategorySection andRowArray:shopByCatArray];
    [self.sectionArray addObject:shopByCat];
    SectionModal *shopByDeal = [[SectionModal alloc] initWithDisplayName:kShopByDealSection andRowArray:hotDeals];
    [self.sectionArray addObject:shopByDeal];
    SectionModal *getInTouch = [[SectionModal alloc] initWithDisplayName:kGetInTouchSection andRowArray:nil];
    [self.sectionArray addObject:getInTouch];
    SectionModal *payment = [[SectionModal alloc] initWithDisplayName:kPaymentSection andRowArray:nil];
    [self.sectionArray addObject:payment];
    [self.leftMenuTableView reloadData];
}

- (NSMutableArray *)fetchShopByCategoriesFromDB {
    
    GMCategoryModal *rootModal = [GMCategoryModal loadRootCategory];
    GMCategoryModal *defaultCategoryModal = rootModal.subCategories.firstObject;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    NSMutableArray *shopBycatArray = [NSMutableArray arrayWithArray:[defaultCategoryModal.subCategories filteredArrayUsingPredicate:pred]];
    return shopBycatArray;
}

- (NSMutableArray *)fetchHotDealsFromDB {
    
    return [[GMHotDealBaseModal loadHotDeals].hotDealArray mutableCopy];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)sectionArray {
    
    if(!_sectionArray) _sectionArray = [NSMutableArray array];
    return _sectionArray;
}

#pragma mark - UITableView Delegates/Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection])
    {
        if (sectionModal.isExpanded) {
            return sectionModal.rowArray.count;
        }else{
            return 0;
        }
    }
    else if([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection])
    {
        if (sectionModal.isExpanded) {
            return sectionModal.rowArray.count;
        }else{
            return 0;
        }
    }

        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [GMSectionView sectionHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMLeftMenuCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionModal *sectionMdl = [self.sectionArray objectAtIndex:section];
    GMSectionView *sectionView = [[[NSBundle mainBundle] loadNibNamed:@"GMSectionView" owner:self options:nil] lastObject];
    [sectionView.sectionButton addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.sectionButton setTag:section];
    [sectionView configureWithSectionDisplayName:sectionMdl.sectionDisplayName];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:indexPath.section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection]) {
        
        GMCategoryModal *categoryModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuCell *leftMenuCell = (GMLeftMenuCell *)[tableView dequeueReusableCellWithIdentifier:kLeftMenuCellIdentifier];
        [leftMenuCell configureWithCategoryName:categoryModal.categoryName];
        return leftMenuCell;
        
    }else if([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection]){
        
        GMHotDealModal *hotDealModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuCell *leftMenuCell = (GMLeftMenuCell *)[tableView dequeueReusableCellWithIdentifier:kLeftMenuCellIdentifier];
        
        [leftMenuCell configureWithCategoryName:hotDealModal.dealType];// confuse to use new func OR same
        return leftMenuCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:indexPath.section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection]) {
        
        GMCategoryModal *categoryModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuDetailVC *leftMenuDetailVC = [[GMLeftMenuDetailVC alloc] initWithNibName:@"GMLeftMenuDetailVC" bundle:nil];
        leftMenuDetailVC.subCategoryModal = categoryModal;
        [self.navigationController pushViewController:leftMenuDetailVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (GMLeftMenuCell *cell in self.leftMenuTableView.visibleCells) {
        
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + [GMLeftMenuCell cellHeight] - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell maskCellFromTop:hiddenFrameHeight];
        }
    }
}

#pragma mark - IBAction Methods

- (void)sectionButtonTapped:(UIButton *)sender {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:sender.tag];
    
    // Expand collapse
    if ([self.preSelectedSectionMdl.sectionDisplayName isEqualToString:sectionModal.sectionDisplayName]) {
            sectionModal.isExpanded = !sectionModal.isExpanded;
    }else{
        self.preSelectedSectionMdl.isExpanded = NO;
        sectionModal.isExpanded = !sectionModal.isExpanded;
        self.preSelectedSectionMdl = sectionModal;
    }
    
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection]) {
        
    }
    else if ([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection]) {
        
    }
    else if ([sectionModal.sectionDisplayName isEqualToString:kGetInTouchSection]) {
        
    }
    else if ([sectionModal.sectionDisplayName isEqualToString:kPaymentSection]) {
        
        GMOtpVC *otpVC = [GMOtpVC new];
        [APP_DELEGATE setTopVCOnCenterOfDrawerController:otpVC];
    }
    
    [self.leftMenuTableView reloadData];//]Sections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)homeButtonTapped:(id)sender {
    
    AppDelegate *appDel = APP_DELEGATE;
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
