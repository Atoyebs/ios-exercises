//
//  ViewController.m
//  Calcohol
//
//  Created by Inioluwa Work Account on 15/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLCViewController.h"

@interface BLCViewController () <UITextFieldDelegate>


@property (nonatomic, weak) UIButton *calculateButton;
@property (nonatomic, weak) UITapGestureRecognizer *hideKeyboardTapGesture;

@end

@implementation BLCViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.beerPercentTextField.delegate = self;
    
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");
    
    self.beerPercentTextField.backgroundColor = [UIColor whiteColor];
    [self.beerPercentTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    self.currentBeerCountLabel.text = @"No. Of Beers: 0";
    self.currentBeerCountLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //set minimum and maximum values
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    [self.calculateButton addTarget:self action:@selector(calculateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate Command") forState:UIControlStateNormal];
    
    [self.hideKeyboardTapGesture addTarget:self action:@selector(tapGestureDidFire:)];
    
    self.resultLabel.numberOfLines = 3;
    
}



-(void)loadView
{

    self.view = [[UIView alloc] init];
    
    //initialize all our objects
    UITextField *textfield = [[UITextField alloc]init];
    UISlider *slider = [[UISlider alloc] init];
    UILabel *label_result = [[UILabel alloc] init];
    UILabel *label_currentBCount = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    
    //assign the intialized objects to the private (gloabal) variables
    self.beerPercentTextField = textfield;
    self.beerCountSlider = slider;
    self.resultLabel = label_result;
    self.currentBeerCountLabel = label_currentBCount;
    self.calculateButton = button;
    self.hideKeyboardTapGesture = tapGestureRecognizer;
    
    
    //add the views, outlets and gesture recognizers as a subview of the main view;
    
    [self.view addSubview:_beerPercentTextField];
    [self.view addSubview:_beerCountSlider];
    [self.view addSubview:_resultLabel];
    [self.view addSubview:_currentBeerCountLabel];
    [self.view addSubview:_calculateButton];
    [self.view addGestureRecognizer:_hideKeyboardTapGesture];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidChange:(UITextField*)sender
{
    NSString* enteredText = sender.text;
    
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        sender.text = nil;
    }
    
    
}

- (void)sliderValueDidChange:(UISlider*)sender
{
    NSLog(@"Slider value changed to %f", sender.value);
    
//    [self.beerPercentTextField resignFirstResponder];
    
    self.currentBeerCountLabel.text = [NSString stringWithFormat:@"No. Of Beers: %f", sender.value];
}


- (void)calculateButtonPressed:(UIButton*)sender
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


- (void)tapGestureDidFire:(UITapGestureRecognizer*)sender
{
    
    [self.beerPercentTextField resignFirstResponder];
    
}


-(void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
    UIScreen *currentScreen = [UIScreen mainScreen];
    
    CGRect screenSize = currentScreen.bounds;
    
    int maximumItemHeight = screenSize.size.height/12.9;
    
    CGFloat viewWidth = screenSize.size.width;
    CGFloat padding = viewWidth/16;
    CGFloat itemWidth = viewWidth - padding - padding;
    CGFloat itemHeight = maximumItemHeight;
    
    self.beerPercentTextField.frame = CGRectMake(padding, (padding + (padding/2)), itemWidth, itemHeight);
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    
    self.currentBeerCountLabel.frame = CGRectMake(padding, bottomOfTextField + itemHeight, itemWidth, itemHeight);
    
    CGFloat bottomOfBeerCountLabel = CGRectGetMaxY(self.currentBeerCountLabel.frame);
    
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfBeerCountLabel + itemHeight, itemWidth, itemHeight);
    
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    self.resultLabel.frame = CGRectMake(padding, bottomOfSlider + padding, itemWidth, itemHeight * 4);
    
    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame);
    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
    
    
    
    
    
}


@end
