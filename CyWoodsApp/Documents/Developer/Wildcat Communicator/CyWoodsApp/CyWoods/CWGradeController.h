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

@interface CWGradeController : UITableViewController{
    BOOL loggedIn;
    NSArray *newGrades;
    NSArray *classes;
}

-(void)setup;
-(void)refresh;

-(void)reloadModel;

-(void)presentLogin;

@end
