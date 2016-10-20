//
//  CWGradeController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWDataStore.h"
#import "CWLoginController.h"
#import "CWDetailValueCell.h"
#import "CWGradeDetailController.h"
#import "CWGradeClassController.h"
#import "CWAppDelegate.h"
#import "CWAverageController.h"

@interface CWGradeController : UITableViewController{
    BOOL loggedIn;
    NSArray *newGrades;
    NSArray *classes;
    BOOL notifySelector;
    BOOL colorcode;
}

@property (strong) UINavigationBar* navigationBar;

-(void)setup;
-(void)refresh;



-(void)presentLogin;

@end
