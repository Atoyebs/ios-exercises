//
//  ViewController.m
//  BlocBrowser
//
//  Created by Inioluwa Work Account on 19/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLCWebBrowserViewController.h"
#import "BLCAwesomeFloatingToolbar.h"

#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface BLCWebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate, BLCAwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *urlTextField;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) BLCAwesomeFloatingToolbar *awesomeToolbar;

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
    
    self.awesomeToolbar = [[BLCAwesomeFloatingToolbar alloc] initWithFourTitles:@[kBLCWebBrowserBackString, kBLCWebBrowserForwardString, kBLCWebBrowserStopString, kBLCWebBrowserRefreshString]];
    
    self.awesomeToolbar.delegate = self;
    
//    [mainView addSubview:self.webView];
//    [mainView addSubview:self.urlTextField];


    for (UIView *viewToAdd in @[self.webView, self.urlTextField, self.awesomeToolbar]) {
        [mainView addSubview:viewToAdd];
    }
    
    
    
    self.view = mainView;
    
}


-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
//    self.webView.frame = self.view.frame;
    
    static const CGFloat itemHeight = 50;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    self.urlTextField.frame = CGRectMake(0, 0, width, (itemHeight - 10));
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.urlTextField.frame), width, browserHeight);
    
    self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
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

-(void)resetView {
  
    [self.webView removeFromSuperview];
    
    UIWebView *newWebView = [[UIWebView alloc] init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webView = newWebView;
    
    self.urlTextField.text = nil;
    [self updateButtonsAndTitle];
    
}



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
    
    
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:kBLCWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kBLCWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:self.frameCount > 0 forButtonWithTitle:kBLCWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webView.request.URL && self.frameCount == 0 forButtonWithTitle:kBLCWebBrowserRefreshString];
    
    
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


- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]) {
        [self.webView goBack];
    }
    else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webView goForward];
    }
    else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    }
    else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
    
}

@end
