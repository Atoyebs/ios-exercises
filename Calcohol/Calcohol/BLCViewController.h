//
//  ViewController.h
//  Calcohol
//
//  Created by Inioluwa Work Account on 15/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCViewController : UIViewController

@property (weak, nonatomic) UITextField *beerPercentTextField;
@property (weak, nonatomic) UISlider *beerCountSlider;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UILabel *currentBeerCountLabel;


#pragma mark - Methods

- (void)calculateButtonPressed:(UIButton*)sender;

@end

