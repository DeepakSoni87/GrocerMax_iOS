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


@property (assign, nonatomic) NSInteger productQuantity;
@property (strong, nonatomic) GMProductDetailModal *proDetailModal;

@end

@implementation GMProductDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Product Description";
    [self configureView];
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - configureView

-(void)configureView {
    
    self.productQuantity = 1;
    
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
    [self.parentVC.cartModal.cartItems addObject:self.modal];
    [self.parentVC.cartModal archiveCart];
    
    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] addToCartParameterDictionaryFromProductModal:self.modal];
    [[GMOperationalHandler handler] addTocartGust:requestParam withSuccessBlock:nil failureBlock:nil];
    
    // first save the modal with there updated quantity then reset the quantity value to 1
    [self.modal setProductQuantity:@"1"];
    self.productQuantity = 1;
    [self updateProductQuantity];
    [self.tabBarController updateBadgeValueOnCartTab];
}

#pragma mark - Update Cost and quantity lbl

- (void)updateProductDescription {
    
    NSMutableAttributedString *attStringPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ | ",self.proDetailModal.currencycode,self.proDetailModal.sale_price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    [attStringPrice appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",self.proDetailModal.currencycode,self.proDetailModal.product_price] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor redColor],NSStrikethroughStyleAttributeName : @1.0}]];
    
    self.productCostLbl.attributedText = attStringPrice;

    NSMutableAttributedString *attStringDes = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_brand] attributes:@{
NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor redColor]}];
    
    [attStringDes appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_name] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    [attStringDes appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",self.proDetailModal.p_pack] attributes:@{                                                                                                                                                       NSFontAttributeName:FONT_LIGHT(14),NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    self.producInfo.attributedText = attStringDes;
    self.producDescriptionLbl.text = self.proDetailModal.product_description;

    [self.productImgView setImageWithURL:[NSURL URLWithString:self.proDetailModal.product_thumbnail] placeholderImage:[UIImage imageNamed:@"STAPLE"]];

}
-(void)updateProductQuantity{

    self.productQuantityLbl.text = [NSString stringWithFormat:@"%li",(long)self.productQuantity];
}

@end
