//
//  CWAthlethicsController.m
//  CyWoods
//
//  Created by Hassaan Raza/Drew Dennistoun on 9/24/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.

#import "CWAthlethicsController.h"
NSMutableArray *employees;


@interface CWAthlethicsController ()

@end

@implementation CWAthlethicsController

- (id) init{
    
    if( self ){
        UINavigationItem *item = self.navigationItem;
        item.title = @"Athlethics";
        SWRevealViewController *revealController = [self revealViewController];
        self.navigationItem.hidesBackButton = YES;
        UIImage *buttonImage = [UIImage imageNamed:@"menubutton"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 45, 29);
        [button addTarget:revealController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 29)];
        [view addSubview:button];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = customBarItem; //this is making it where theres the menubutton on the navigation bar
        employees = [[NSMutableArray alloc] init];
        [self fetchRankings];
    
    }
    
    return self;
}
-(void) fetchRankings{
    PFQuery *query = [PFQuery queryWithClassName:@"Rankings"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [employees addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.rankings reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
