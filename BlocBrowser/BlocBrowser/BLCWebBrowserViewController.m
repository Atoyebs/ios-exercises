//
//  ViewController.m
//  BlocBrowser
//
//  Created by Inioluwa Work Account on 19/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLCWebBrowserViewController.h"

@interface BLCWebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *urlTextField;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *reloadButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) NSUInteger *frameCount;

@end

@implementation BLCWebBrowserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.urlTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.urlTextField.font = [UIFont fontWithName:@"Helvetica" size:12];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
}


-(void)loadView {
    
    [super loadView];
    
    UIView *mainView = [UIView new];
    
    self.webView = [UIWebView new];
    
    self.webView.delegate = self;
    
    self.urlTextField = [[UITextField alloc] init];
    self.urlTextField.keyboardType = UIKeyboardTypeURL;
    self.urlTextField.returnKeyType = UIReturnKeyDone;
    self.urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.urlTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    self.urlTextField.placeholder = NSLocalizedString(@"Search google", @"Placeholder text for web browser URL field");
    self.urlTextField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    
    self.urlTextField.delegate = self;
    
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back comnmand") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward comnmand") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop comnmand") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Refresh", @"Reload comnmand") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:self.webView];
    [mainView addSubview:self.urlTextField];
    

    for (UIView *viewToAdd in @[self.webView, self.urlTextField, self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;
    
}


-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
//    self.webView.frame = self.view.frame;
    
    static const CGFloat itemHeight = 50;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight;
    
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 4;
    
    self.urlTextField.frame = CGRectMake(0, 0, width, (itemHeight - 10));
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.urlTextField.frame), width, browserHeight);
    
    CGFloat currentButtonX = 0;
    
    for (UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth;
    }
    
}


-(NSURLRequest*)loadURLRequestWithStringURL:(NSString*)stringURL {
    
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
}


#pragma mark - UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    NSString *urlString = [self constructGoogleSearchURLStringFromTextField];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    if (!URL.scheme) {
        // The user didn't type http: or https:
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
    }
    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    return NO;
    
}


#pragma mark - UIWebView Delegate Methods

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];

    
    [alertView addAction:ok];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
    [self updateButtonsAndTitle];
    
    self.frameCount--;
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.frameCount++;
    
    [self updateButtonsAndTitle];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.frameCount--;
    
    [self updateButtonsAndTitle];
}




#pragma mark - Miscellaneous Methods

-(void)updateButtonsAndTitle {
    
    NSString *webpageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webpageTitle) {
        self.title = webpageTitle;
    } else {
        self.title = self.webView.request.URL.absoluteString;
    }
    
    if (self.frameCount > 0) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.frameCount > 0;
    self.reloadButton.enabled = self.frameCount == 0;
    
    
}

-(NSString*)constructGoogleSearchURLStringFromTextField {
    
    NSMutableString *enteredSearchString = [self.urlTextField.text mutableCopy];
    
    BOOL containsSpace = [enteredSearchString containsString:@" "];
    
    static const NSString *baseGoogleSearchString = @"google.com/search?q=";
    
    NSString *finalURLString = enteredSearchString;
    
    if (containsSpace)
    {
        enteredSearchString = [[enteredSearchString stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy];
        
        finalURLString = [NSString stringWithFormat:@"%@%@", baseGoogleSearchString, enteredSearchString];
    }
    
    
    return finalURLString;
}



@end
