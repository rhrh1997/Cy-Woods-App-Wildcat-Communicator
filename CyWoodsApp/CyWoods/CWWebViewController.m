//
//  CWWebViewController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/6/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWWebViewController.h"

@implementation CWWebViewController


- (id)init{
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"CWWebViewController" bundle:[NSBundle mainBundle]];
    
    if( self ){
        self.navigationItem.title = @"";
        if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    web.delegate = self;
    if( toLoad )
    [self loadRequest:toLoad];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [web stopLoading];
    [self hideActivityIndicators];
}

- (id)initWithRequest:(NSString *)req{
    self = [self init];
    
    if( self ){
        toLoad = req;
    }
    
    return self;
}

- (void)loadRequest:(NSString *)req{
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:req]]];
    [self refreshButtons];
}

-(void)refreshButtons {
    backbtn.enabled = web.canGoBack;
    forwardbtn.enabled = web.canGoForward;
}

-(void)showActivityIndicators {
    activity.hidden = NO;
    [activity startAnimating];
    refreshbtn.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideActivityIndicators {
    activity.hidden = YES;
    [activity stopAnimating];
    refreshbtn.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self refreshButtons];
    [self showActivityIndicators];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *pageTitle = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([pageTitle isEqualToString:@"Spartify"])
    {
        NSLog(@"spartify");
        pageTitle = @"Turn Down for What";
        NSString *jsCommand = [NSString stringWithFormat:
                               @"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"
                               @"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"@"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"@"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"@"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"@"var element = document.getElementById('%@'); element.parentElement.removeChild(element);"
                               @"search",@"intro",@"derp",@"facebook-login",@"party-code",@"search",@"actions"];
        [webView stringByEvaluatingJavaScriptFromString:jsCommand];
        
    }
    self.navigationItem.title = pageTitle;
    [self refreshButtons];
    [self hideActivityIndicators];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityIndicators];
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load page"
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Dismiss", nil];
	[alert show];
}

-(IBAction)goBrowser:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    if (![self.navigationItem.title isEqualToString:@"Turn Down for What"]) {
    actionSheet.title = web.request.URL.absoluteString;
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Open in Safari"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
  
    [[UIApplication sharedApplication] openURL:web.request.URL];

}

@end
