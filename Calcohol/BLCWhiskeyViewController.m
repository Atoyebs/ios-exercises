//
//  BLCWhiskeyViewController.m
//  Calcohol
//
//  Created by Inioluwa Work Account on 18/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLCWhiskeyViewController.h"

@interface BLCWhiskeyViewController ()

@end

@implementation BLCWhiskeyViewController


- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.title = NSLocalizedString(@"Whiskey", nil);
    }
    
    [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -18)];
    
    return self;
}



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Whiskey Glass", @"Beer percent placeholder text");
    
    self.currentBeerCountLabel.text = @"No. Of Whiskey Glasses: 0";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.588 alpha:1]; /*#fdfd96*/
    
}


-(void)calculateButtonPressed:(UIButton *)sender {
    
    [self.beerPercentTextField resignFirstResponder];
    
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12;  //assume they are 12oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    float ouncesInOneWhiskeyGlass = 1;  // a 1oz shot
    float alcoholPercentageOfWhiskey = 0.4;  // 40% is average
    
    float ouncesOfAlcoholPerWhiskeyGlass = ouncesInOneWhiskeyGlass * alcoholPercentageOfWhiskey;
    float numberOfWhiskeyGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWhiskeyGlass;
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *whiskeyText;
    
    if (numberOfWhiskeyGlassesForEquivalentAlcoholAmount == 1) {
        whiskeyText = NSLocalizedString(@"shot", @"singular shot");
    } else {
        whiskeyText = NSLocalizedString(@"shots", @"plural of shot");
    }
    
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as %.1f %@ of whiskey.", nil), numberOfBeers, beerText, numberOfWhiskeyGlassesForEquivalentAlcoholAmount, whiskeyText];
    self.resultLabel.text = resultText;
    
}

@end
