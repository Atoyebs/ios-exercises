//
//  ViewController.m
//  Calcohol
//
//  Created by Inioluwa Work Account on 15/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLCViewController.h"

@interface BLCViewController ()

@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBeerCountLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDidChange:(UITextField*)sender
{
    NSString* enteredText = sender.text;
    
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    
    
}

- (IBAction)sliderValueDidChange:(UISlider*)sender
{
    NSLog(@"Slider value changed to %f", sender.value);
    
//    [self.beerPercentTextField resignFirstResponder];
    
    self.currentBeerCountLabel.text = [NSString stringWithFormat:@"No. Of Beers: %f", sender.value];
}


- (IBAction)calculateButtonPressed:(id)sender
{
    [self.beerPercentTextField resignFirstResponder];
    
    
    //calculate how much alcohol is in the beers
    
    int numberOfBeers = self.beerCountSlider.value;
    
    int ouncesInOneBeerGlass = 12;
    
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue]/100;
    
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    float ouncesInOneWineGlass = 5;  // wine glasses are usually 5oz
    float alcoholPercentageOfWine = 0.13;  // 13% is average
    
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWineGlass;
    
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }

    
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as %.1f %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
    
}


- (IBAction)tapGestureDidFire:(id)sender
{
    
    [self.beerPercentTextField resignFirstResponder];
    
}



@end
