//
//  CWHomeController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWDataStore.h"
#import "CWWebViewController.h"

@interface CWHomeController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *table;
    NSArray *news;
}

-(void)refresh;
-(void)setup;

@end
