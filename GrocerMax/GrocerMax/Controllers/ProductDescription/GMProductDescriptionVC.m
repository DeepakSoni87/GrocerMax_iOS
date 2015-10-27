//
//  GMProductDescriptionVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductDescriptionVC.h"
#import "GMProductDetailModal.h"

#define kMAX_Quantity 500

@interface GMProductDescriptionVC ()

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *producInfo;

@property (weak, nonatomic) IBOutlet UILabel *productCostLbl;

@property (weak, nonatomic) IBOutlet UILabel *productQuantityLbl;

@property (weak, nonatomic) IBOutlet UILabel *producDescriptionLbl;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *promotionalLbl;

@property (assign, nonatomic) NSInteger productQuantity;

@property (strong, nonatomic) GMProductDetailModal *proDetailModal;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSoldout;

@property (weak, nonatomic) IBOutlet UIView *cartView;

@property (weak, nonatomic) IBOutlet UILabel *itemsInCartLabel;
@property (weak, nonatomic) IBOutlet UIView *productItemView;
@property (weak, nonatomic) IBOutlet UILabel *ProductNumberLbl;


@end

@implementation GMProductDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Product Description";
    [self configureView];
    [self getDataFromServer];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ProducDetail_Screen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - configureView

-(void)configureView {
    
    self.productQuantity = 1;
    self.productItemView.hidden = TRUE;
    self.promotionalLbl.layer.cornerRadius = 2.0;
    self.promotionalLbl.layer.masksToBounds = YES;

    self.addBtn.layer.cornerRadius = 5.0;
    self.addBtn.layer.masksToBounds = YES;
}

#pragma mark - Get data from server

-(void)getDataFromServer {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:self.modal.productid forKey:kEY_pro_id];
    
    [self showProgress];
    [[GMOperationalHandler handler] productDetail:localDic withSuccessBlock:^(id responceData) {
        
       GMProductDetailBaseModal* baseMdl = (GMProductDetailBaseModal*)responceData;
        self.proDetailModal = baseMdl.productDetailArray.firstObject;
        [self updateProductDescription];
        [self updateProductQuantity];
        [self updateProctuctInCart];
        [self removeProgress];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

#pragma mark - stepper (+/-) Button Action

- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    if (self.productQuantity > 1) {
        self.productQuantity -= 1;
        [self updateProductQuantity];
    }
}

- (IBAction)pluseBtnPressed:(UIButton *)sender {
    
    if (self.productQuantity < kMAX_Quantity) {
        self.productQuantity += 1;
        [self updateProductQuantity];
    }
}

- (IBAction)addToCartBtnPressed:(UIButton *)sender {
    
    if (![[GMSharedClass sharedClass] isInternetAvailable]) {
        
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"no_internet_connection")];
        return;
    }
    
    [self.modal setProductQuantity:[NSString stringWithFormat:@"%ld",self.productQuantity]];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.modal];
    GMProductModal *productCartModal = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    [self.parentVC.cartModal.cartItems addObject:productCartModal];
    [self.parentVC.cartModal archiveCart];
    
    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] addToCartParameterDictionaryFromProductModal:productCartModal];
    [[GMOperationalHandler handler] addTocartGust:requestParam withSuccessBlock:nil failureBlock:nil];
    
    // first save the modal with there updated quantity then reset the quantity value to 1
    [self.modal setProductQuantity:@"1"];
    self.productQuantity = 1;
    [self updateProductQuantity];
    [self updateProctuctInCart];
    [self.tabBarController updateBadgeValueOnCartTab];
}
//
//- (BOOL)isProductAddedIntoCart {
//    
//    NSUInteger totalQuantity = self.quantityValue;
//    totalQuantity += self.totalProductsInCart;
//    [self.cartView setHidden:NO];
//    [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%ld", totalQuantity]];
//    self.productModal.productQuantity = [NSString stringWithFormat:@"%ld",totalQuantity];
//    self.totalProductsInCart = totalQuantity;
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.modal.productid];
//    NSArray *totalProducts = [self.parentVC.cartModal.cartItems filteredArrayUsingPredicate:pred];
//    if(totalProducts.count) {
//        
//        GMProductModal *cartProductModal = [totalProducts firstObject];
//        [cartProductModal setProductQuantity:[NSString stringWithFormat:@"%ld", totalQuantity]];
//        return NO;
//    }
//    return YES;
//}
#pragma mark - Update Cost and quantity lbl

- (void)updateProductDescription {
    
    NSMutableAttributedString *attStringPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@",self.proDetailModal.sale_price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor gmRedColor]}];
    
    [attStringPrice appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" | " attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor gmBlackColor]}]];
    
    [attStringPrice appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@",self.proDetailModal.product_price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor gmBlackColor],NSStrikethroughStyleAttributeName : @1.0}]];
    
    self.productCostLbl.attributedText = attStringPrice;

    NSString *brandString =  @"";
    if(NSSTRING_HAS_DATA(self.proDetailModal.p_brand)) {
        brandString = [NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_brand];
        
    }
    NSMutableAttributedString *attStringDes = [[NSMutableAttributedString alloc] initWithString:brandString attributes:@{
    NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor redColor]}];
    
    if(NSSTRING_HAS_DATA(self.proDetailModal.p_name)) {
    [attStringDes appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_name] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(13),NSForegroundColorAttributeName : [UIColor blackColor]}]];
    }
    if(NSSTRING_HAS_DATA(self.proDetailModal.p_pack)) {
    [attStringDes appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_pack] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(12),NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    }
    
    self.producInfo.attributedText = attStringDes;
    self.producDescriptionLbl.text = self.proDetailModal.product_description;

    [self.productImgView setImageWithURL:[NSURL URLWithString:self.proDetailModal.product_thumbnail] placeholderImage:[UIImage productPlaceHolderImage]];
    
    if (self.modal.promotion_level.length > 1) {
        self.promotionalLbl.text = [NSString stringWithFormat:@"%@",self.modal.promotion_level];
    }
    
    if ([self.modal.Status isEqualToString:@"Sold Out"]) {
        self.imgViewSoldout.hidden = NO;
        self.addBtn.hidden = YES;
    }else{
        self.imgViewSoldout.hidden = YES;
        self.addBtn.hidden = NO;
    }
}

- (void)updateProductQuantity {

    self.productQuantityLbl.text = [NSString stringWithFormat:@"%li",(long)self.productQuantity];
    
}

- (void)updateProctuctInCart {
    
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.proDetailModal.product_id];
    NSArray *totalProducts = [cartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count ) {
        int totalItems = 0;
        for (GMProductModal *productModal in cartModal.cartItems) {
            
            if([productModal.productid isEqualToString:self.proDetailModal.product_id]) {
                totalItems += productModal.productQuantity.intValue;
            }
            
        }
        self.productItemView.hidden = FALSE;
        self.ProductNumberLbl.text = [NSString stringWithFormat:@"%d",totalItems];
    } else {
        self.productItemView.hidden = TRUE;
        self.ProductNumberLbl.text = @"";
    }
}

@end
