//
//  CWLoginController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/8/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWDataStore.h"
#import "CWLoadingView.h"
#import "CWFieldCell.h"
#import "CWAppDelegate.h"

@interface CWLoginController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    BOOL logInAllowed;
    BOOL loggingIn;
    NSString *loginMessage;
    
    CWLoadingView *loading;
    
    CWFieldCell *usernameField;
    CWFieldCell *passwordField;
}

-(void)refresh;
-(void)login;
-(void)loginReturn:(NSDictionary *) dict;

@end
