//
//  CWAppDelegate.h
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWHomeController.h"
#import "CWGradeController.h"
#import "CWTeacherController.h"
#import "CWExtraController.h"
#import "CWLoadingView.h"
#import "ScrollmenuController.h"
#import "SWRevealViewController.h"
#import  "CWBellSchedule.h"
#import "CWAthlethicsController.h"
#import "CWInformationController.h"


@class CWGradeController, CWDataStore, SWRevealViewController;

@interface CWAppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *tcon;
    UINavigationController *gcon;
    UINavigationController *hcon;
    NSMutableArray *loadingViews;
    CWGradeController *grade;
    ScrollmenuController *menu;
    SWRevealViewController *revealController;
}

@property (strong, nonatomic) UIWindow *window;
-(void)addLoading:(NSString *)loading;
-(void)stopLoading;
-(void)selectedItem:(int)row;

@property (strong, nonatomic) SWRevealViewController *viewController;

@end
