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

@class CWGradeController, CWDataStore;

@interface CWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UINavigationController *tcon;
    UINavigationController *gcon;
    CWGradeController *grade;
    NSMutableArray *loadingViews;
    UITabBarController *tabs;
}

@property (strong, nonatomic) UIWindow *window;
-(void)addLoading:(NSString *)loading;
-(void)stopLoading;

@end
