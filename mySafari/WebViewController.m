//
//  WebViewController.m
//  mySafari
//
//  Created by Chee Vue on 5/13/15.
//  Copyright (c) 2015 Chee Vue. All rights reserved.
//

#import "WebViewController.h"

//WebViewController will conform to the listed protocol and will listen for delegate method.
@interface WebViewController () <UIWebViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UITextField *urltextField;
@property NSString *urlTitle;


@property CGFloat lastContentOffest;
@property CGFloat previousOffset;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set Clear button in URL text field and then specify a URL to enter
    self.urltextField.clearButtonMode = UITextFieldViewModeAlways;
    self.urltextField.placeholder = @"Please Enter a URL";

    //Call refactor method created "loadRequestWithText"
    [self loadRequestWithText:@"http://www.mobilemakers.co"];
    // Declare that the WebViewController is now the delegate of the specific "webView" instance
    self.webView.delegate = self;

    // Declare that the WebViewController is now the delegate of the specific "scrollView" instance
    self.webView.scrollView.delegate = self;

    // ScrollView NOT implemented!
    //self.lastContentOffest = self.webView.scrollView.contentOffset.y;

}

#pragma mark - UIWebViewDelegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{

// Action: Setting the networkActivityIndicatorValue
// Description: When an app is launched, the UIApplicationMain function is called;
// among its other tasks, this function creates a singleton UIApplication object.
// Thereafter you access this object by invoking the sharedApplication class method.
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{

[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    //Check if can go back
    if (self.webView.canGoBack){
        self.backButton.enabled = true;
    } else {
        self.backButton.enabled = false;
    }

     //Check if can go forward
    if (self.webView.canGoForward){
        self.forwardButton.enabled = true;
    } else {
        self.forwardButton.enabled = false;
    }

    self.urltextField.text = webView.request.URL.absoluteString;
    [self.urltextField resignFirstResponder];

    // Set navigationItem's title to the URL's title
    self.urlTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = self.urlTitle;

}

#pragma mark - UITextFieldDelegate Methods

// Action: Asks the delegate if the text field should process the pressing of the return button. The URL text field calls this method whenever the user taps the RETURN button.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    // Check if URL text field does NOT contain pre-fix of "http://" then append it, plus the input URL text
    if (![textField.text containsString:@"http://"]) {
        textField.text = [NSString stringWithFormat:@"http://%@", textField.text];
    }

    [self loadRequestWithText:textField.text];
    // *** The following code was refactored to "loadRequestWithText" as previously line code ****
    //    NSURL *url = [NSURL URLWithString:textField.text];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [self.webView loadRequest:request];

    //set URL text field as first responder
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - UIAlertViewDelegate Methods
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    UIAlertView *alertView = [[UIAlertView alloc] init];
//    alertView.title = @"Failed to load webpage";
//    alertView.message = @"Try a different URL";
//    [alertView addButtonWithTitle:@"Dismiss"];
//    [alertView addButtonWithTitle:@"Reload"];
//    alertView.delegate = self;
//    [alertView show];
//    //self.activityIndicator.hidden = true;
//}


#pragma mark - UIWebView Methods

- (IBAction)onBackButtonPressed:(UIButton *)sender
{
    [self.webView goBack];
    self.urltextField.text =self.webView.request.URL.absoluteString;
}
- (IBAction)onForwardButtonPressed:(UIButton *)sender
{
    [self.webView goForward];
}
- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}
- (IBAction)plusButton:(UIButton *)sender {
//    UIAlertView *alertPlusView = [[UIAlertView alloc] initWithTitle:@"Coming Soon!" message:@"New Features Soon!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];

    UIAlertView *alertPlusView = [[UIAlertView alloc] init];
    alertPlusView.title = @"Coming Soon!";
    alertPlusView.message = @"New Features TBD, contact support@cheevue.com for info.";
    [alertPlusView addButtonWithTitle:@"Dismiss"];
    alertPlusView.delegate = nil;
    [alertPlusView show];
}

#pragma mark - UIScrollView Methods

//// *** ScrollView NOT implemented - Not Working
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.lastContentOffest < scrollView.contentOffset.y)
//    {
//        self.textField.alpha = 0;
//    }
//    else
//    {
//        self.textField.alpha = 1;
//    }
//}
//
//// *** ScrollView NOT implemented - Not Working
//-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    self.textField.hidden = false;
//}

#pragma mark - Helper Methods


-(void)loadRequestWithText:(NSString *)text
{

    NSURL *url = [NSURL URLWithString:text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest: request];
}


@end
