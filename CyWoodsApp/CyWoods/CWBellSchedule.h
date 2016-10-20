//
//  CWBellSchedule.h
//  CyWoods
//
//  Created by Rishabh Dhar on 8/8/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWDataStore.h"

@interface CWBellSchedule : UITableViewController{
    NSArray *schedule;
    NSDictionary *cur;
    NSTimer *timer;
}

-(void)refresh;

@end
