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
#import <Parse/Parse.h>
#import "iCarousel.h"
#import "UIImageView+AFNetworking.h"


@interface CWHomeController : UIViewController<UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate, UIAlertViewDelegate> {
    __weak IBOutlet UITableView *table;
    NSArray *news;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic) BOOL wrap;



-(void)refresh;
-(void)setup;
-(void)tickerToggle;
-(void)tickerUpdate;


@end
