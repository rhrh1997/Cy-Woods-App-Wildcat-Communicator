//
//  CWWebViewController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/6/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWWebViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>{
    __weak IBOutlet UIWebView *web;
    
    __weak IBOutlet UIBarButtonItem *backbtn;
    __weak IBOutlet UIBarButtonItem *forwardbtn;
    __weak IBOutlet UIBarButtonItem *refreshbtn;
    
    __weak IBOutlet UIActivityIndicatorView *activity;
    
    NSString *toLoad;
}

-(id)initWithRequest:(NSString *)req;
-(void)loadRequest:(NSString *)req;
-(void)refreshButtons;

-(IBAction)goBrowser:(id)sender;

@end
