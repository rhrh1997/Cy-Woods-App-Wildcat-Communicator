//
//  CWSettingsController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/29/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWDataStore.h"

@interface CWSettingsController : UITableViewController{
    BOOL loggedIn;
}

-(void)reload;

@end
