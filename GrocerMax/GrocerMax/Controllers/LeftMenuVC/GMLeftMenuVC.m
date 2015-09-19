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

#pragma mark - Interface/Implementation SectionModal

@interface SectionModal : NSObject

@property (nonatomic, strong) NSString *sectionDisplayName;

@property (nonatomic, strong) NSMutableArray *rowArray;

- (instancetype)initWithDisplayName:(NSString *)displayName andRowArray:(NSMutableArray *)rowArray;
@end

@implementation SectionModal

- (instancetype)initWithDisplayName:(NSString *)displayName andRowArray:(NSMutableArray *)rowArray {
    
    if(self = [super init]) {
        
        _sectionDisplayName = displayName;
        _rowArray = rowArray;
    }
    return self;
}
@end

#pragma mark - Interface/Implementation GMLeftMenuVC

@interface GMLeftMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftMenuTableView;

@property (nonatomic, strong) NSMutableArray *sectionArray;
@end

static NSString * const kLeftMenuCellIdentifier             = @"leftMenuCellIdentifier";

static NSString * const kShopByCategorySection                      =  @"SHOP BY CATEGORIES";
static NSString * const kShopByDealSection                          =  @"SHOP BY DEALS";
static NSString * const kGetInTouchSection                          =  @"GET IN TOUCH WITH US";
static NSString * const kPaymentSection                             =  @"PAYMENTS METHODS";


@implementation GMLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    [self.leftMenuTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCellIdentifier];
}

- (void)createSectionArray {
    
    NSMutableArray *shopByCatArray = [self fetchShopByCategoriesFromDB];
    SectionModal *shopByCat = [[SectionModal alloc] initWithDisplayName:kShopByCategorySection andRowArray:shopByCatArray];
    [self.sectionArray addObject:shopByCat];
    SectionModal *shopByDeal = [[SectionModal alloc] initWithDisplayName:kShopByDealSection andRowArray:nil];
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

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)sectionArray {
    
    if(!_sectionArray) _sectionArray = [NSMutableArray array];
    return _sectionArray;
}



#pragma mark - IBAction Methods

- (IBAction)homeButtonTapped:(id)sender {
    
    [self.drawerController toggleDrawerSide:XHDrawerSideLeft animated:YES completion:nil];
}


@end
