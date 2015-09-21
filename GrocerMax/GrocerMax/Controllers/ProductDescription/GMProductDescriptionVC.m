//
//  GMProductDescriptionVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductDescriptionVC.h"


#define kMAX_Quantity 500

@interface GMProductDescriptionVC ()

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *producDescriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *productCostLbl;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLbl;

@property (assign, nonatomic)  NSInteger productQuantity;

@end

@implementation GMProductDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - configureView

-(void)configureView {
    
    self.productQuantity = 1;
}

#pragma mark - stepper (+/-) Button Action

- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    if (self.productQuantity > 1) {
        self.productQuantity -= 1;
        [self updateUI];
    }
}
- (IBAction)pluseBtnPressed:(UIButton *)sender {
    
    if (self.productQuantity < kMAX_Quantity) {
        self.productQuantity += 1;
        [self updateUI];
    }
}

#pragma mark - Update Cost and quantity lbl

- (void)updateUI {
    
    self.productQuantityLbl.text = [NSString stringWithFormat:@"%li",(long)self.productQuantity];
    
    self.productCostLbl.text = [NSString stringWithFormat:@"15 X %li = %li",(long)self.productQuantity,(15*self.productQuantity)];
}

@end
