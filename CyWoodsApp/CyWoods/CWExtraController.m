//
//  CWExtraController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWExtraController.h"
#import "CWBellSchedule.h"

@implementation CWExtraController


- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle{
    self = [super initWithNibName:@"CWExtraController" bundle:[NSBundle mainBundle]];
    
    if( self ){
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
        self.tabBarItem.title = @"Extra";
        
        
        if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
        
        UINavigationItem *item = self.navigationItem;
        item.title = @"Extra";
    }
    
    return self;
}

- (void)setup{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (IBAction)bellScheduleButton:(id)sender {
    CWBellSchedule *BS = [[CWBellSchedule alloc] init];
    [self.navigationController pushViewController:BS animated:YES];
}

- (IBAction)launchCalendar:(id)sender{
    [self.navigationController pushViewController:[[CWCalendarController alloc] init] animated:YES];
}

- (IBAction)launchAthletics:(id)sender{
    [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:[[CWDataStore sharedInstance] athletics]] animated:YES];
}

- (IBAction)launchSettings:(id)sender{
    [self.navigationController pushViewController:[[CWSettingsController alloc] init] animated:YES];
}

@end
