//
//  CWGradeController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWGradeController.h"

@implementation CWGradeController
{
    BOOL notifier;
}

- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        UINavigationItem *item = self.navigationItem;
        item.title = @"Grades";
        SWRevealViewController *revealController = [self revealViewController];
        self.navigationItem.hidesBackButton = YES;
//      UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
//        self.navigationItem.leftBarButtonItem = revealButtonItem;  //this is making it where theres the menubutton on the navigation bar
        UIImage *buttonImage = [UIImage imageNamed:@"menubutton"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 45, 29);
        [button addTarget:revealController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 29)];
        [view addSubview:button];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = customBarItem;
        self.tableView.backgroundColor = [UIColor colorWithRed: 250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f];
        self.tableView.separatorColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0];
        colorcode = true;
       [[CWDataStore sharedInstance] addRefresh:self];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [self refresh];
    NSDictionary *status = [[CWDataStore sharedInstance] gradesCheckStatus];
    loggedIn = NO;
    if( [status objectForKey:@"error"]){
       // NSLog(@"Log in not available 2");
        if(![self.navigationController.topViewController isKindOfClass:[CWLoginController class]]) {
        //NSLog(@"attempting to push to login view");
        [self presentLogin];
        }
    }
    //[super viewDidAppear:true];
    
}

- (void)refresh{
  //  NSLog(@"refresh was called");
    NSDictionary *status = [[CWDataStore sharedInstance] gradesCheckStatus];
    loggedIn = NO;
    if( [status objectForKey:@"error"]){
    //    NSLog(@"refresh was called and resulted in error for login");
        //self.navigationItem.leftBarButtonItem = nil;
    }else{
        newGrades = [status objectForKey:@"New Grades"];
        classes = [status objectForKey:@"Classes"];
       // NSLog(@"%@", classes);
       // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];

    }

    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self refresh];
    [refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CWDataStore sharedInstance] refresh];
    [self refresh];
}

//-(void)reloadModel{
//    //self.navigationItem.rightBarButtonItem.enabled = NO;
//    [[CWDataStore sharedInstance] refresh];
//}

- (void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:@"CWDetailValueCell" bundle:nil];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CWDetailValueCell"];


    
}

- (void)setup{
    //self.navigationController.tabBarItem = [[UITabBarItem alloc ] initWithTitle:@"Grades" image:[UIImage imageNamed:@"bar_graph.png"] tag:0];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 && indexPath.row == 0 ){
        if( newGrades.count != 0 ){
            [[CWDataStore sharedInstance] gradesClear];
            NSMutableArray *rm = [NSMutableArray array];
            for(int i = 0; i<newGrades.count; i++)
                [rm addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
            newGrades = [NSArray array];
            [self.tableView deleteRowsAtIndexPaths:rm withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else
        {
        if( indexPath.section == 0){
            
            [self.navigationController pushViewController:[[CWGradeDetailController alloc] initWithId:[[newGrades objectAtIndex:indexPath.row-1] objectForKey:@"id"]] animated:YES];
            
        }
        if(indexPath.section == 1)
        {
            if(notifier == true)
            {
                NSLog(@"You have selected %@" ,[[classes objectAtIndex:indexPath.row] objectForKey:@"Name"]);
                NSString *class = [[classes objectAtIndex:indexPath.row] objectForKey:@"Name"];
                [[CWDataStore sharedInstance]addToNotifer:class :@"90" :true];
            }
            else
            {
                CWGradeClassController *grade = [[CWGradeClassController alloc] initWithClass:[[classes objectAtIndex:indexPath.row] objectForKey:@"Name"]];
                grade.isSomethingEnabled = colorcode;
                [self.navigationController pushViewController:grade animated:YES];

            }
        }
        else
        {
            if(indexPath.row == 0)
            {
//                NSLog(@"Notification setter enabled");
//                if(notifier == true)
//                {
//                    notifier = false;
//                    NSLog(@"Notifier is turned off");
//                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                }
//                else
//                {
//                notifier = true;
//                [[[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Notification setter has been enabled, please select a grade to setup a notification" delegate:nil cancelButtonTitle:@"Leave me alone!" otherButtonTitles:nil] show];
//                }
                NSLog(@"Pushing to GPA Calculator");
                CWAverageController *average = [[CWAverageController alloc]init];
                [self.navigationController pushViewController:average animated:YES];

            }
//            if(indexPath.row == 1)
//            {
//                NSLog(@"Pushing to GPA Calculator");
//                CWAverageController *average = [[CWAverageController alloc]init];
//                [self.navigationController pushViewController:average animated:YES];
//
//               //[[CWDataStore sharedInstance]getNotifiers];
//         
//            }
            if(indexPath.row == 1)
            {
                if(colorcode == true)
                {
                    colorcode = false;
                    [self.tableView reloadData];
                }
                else
                {
                    colorcode = true;
                    [self.tableView reloadData];
                }
            }
            if(indexPath.row == 2)
            {
                NSLog(@"Logging out...");
                [self logout];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CWDetailValueCell";
    
    CWDetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.label.font = [UIFont fontWithName:@"Avenir-Heavy" size:15];
    cell.detail.font = [UIFont fontWithName:@"Avenir" size:16];
    cell.subtitle.font = [UIFont fontWithName:@"Avenir" size:13];


    if( indexPath.section == 0)
    {
        if( indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"PlainCell";
            
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         

            if (cell2 == nil)
            {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell2.textLabel.font = [UIFont fontWithName:@"Avenir" size:13];

            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell2.textLabel.textAlignment = NSTextAlignmentCenter;
            
            
            if( newGrades.count == 0 )
            {
                cell2.textLabel.text = @"No new grades, pull to refresh";
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            }else
            {
                cell2.textLabel.text = @"Mark new grades as seen";
            }
            return cell2;
        }
    else{
            NSDictionary *g = [newGrades objectAtIndex:indexPath.row-1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.label.text = [g objectForKey:@"Name"];
            cell.detail.text = [g objectForKey:@"Grade"];
            cell.subtitle.text = [g objectForKey:@"Class"];
            float check = [[g objectForKey:@"Grade"] floatValue];
            if(colorcode == true)
            {
            //self.tableView.separatorColor = [UIColor clearColor];
            if(check >= 89.5){
                cell.backgroundColor  = [UIColor colorWithRed: 46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                //[UIColor colorWithRed: 46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
            }
            else if(check >= 79.5)
            {
                //cell.backgroundColor  = [UIColor colorWithRed: 52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                cell.backgroundColor  = [UIColor colorWithRed: 241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
                //cell.contentView.backgroundColor  = [UIColor colorWithRed: 52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
            }
            else if(check >= 74.5)
            {
                //cell.contentView.backgroundColor  = [UIColor colorWithRed: 241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                
                
                cell.backgroundColor  = [UIColor colorWithRed: 230/255.0f green:126/255.0f blue:34/255.0f alpha:1.0f];
            }
            else if(check >= 69.5)
            {
                //cell.contentView.backgroundColor  = [UIColor colorWithRed: 243/255.0f green:156/255.0f blue:18/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                cell.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
            }
            else if(check > 0.0)
            {
                //cell.contentView.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
                cell.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                
            }
            else
            {
                //cell.contentView.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
                cell.backgroundColor  = [UIColor colorWithRed: 155/255.0f green:89/255.0f blue:182/255.0f alpha:1.0f];
                cell.contentView.backgroundColor  = [UIColor whiteColor];
                
            }
            }

        }
    }
    if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"PlainCell";

        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell3 == nil) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell3.textLabel.font = [UIFont fontWithName:@"Avenir" size:13];
        
        cell3.accessoryType = UITableViewCellAccessoryNone;
        cell3.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell3.textLabel.textAlignment = NSTextAlignmentCenter;
        if(indexPath.row == 0)
        {
        cell3.textLabel.text = @"Average Calculator";
        }
//        if(indexPath.row == 1)
//        {
//        cell3.textLabel.text = @"GPA Calculator";
//        }
        if(indexPath.row == 1)
        {
            if(colorcode == true)
            {
                cell3.textLabel.text = @"Color Codes Off";

            }
            else
            {
                cell3.textLabel.text = @"Color Codes On";

            }
            
        }
        if(indexPath.row == 2)
        {
        cell3.textLabel.text = @"Logout";
        }
        
        return cell3;
        
    }
    if( indexPath.section == 1){
        NSDictionary *c = [classes objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.label.text = [c objectForKey:@"Name"];
        cell.subtitle.text = [c objectForKey:@"Teacher"];
        cell.detail.text = [c objectForKey:@"Grade"];
        float check = [[c objectForKey:@"Grade"] floatValue];
        if(colorcode == true)
        {
        //self.tableView.separatorColor = [UIColor clearColor];
        if(check >= 89.45){
            cell.backgroundColor  = [UIColor colorWithRed: 46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];
            //[UIColor colorWithRed: 46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
        }
        else if(check >= 79.45)
        {
            //cell.backgroundColor  = [UIColor colorWithRed: 52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];
            cell.backgroundColor  = [UIColor colorWithRed: 241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
            //cell.contentView.backgroundColor  = [UIColor colorWithRed: 52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0f];
        }
        else if(check >= 74.45)
        {
            //cell.contentView.backgroundColor  = [UIColor colorWithRed: 241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];

           
             cell.backgroundColor  = [UIColor colorWithRed: 230/255.0f green:126/255.0f blue:34/255.0f alpha:1.0f];
        }
        else if(check >= 69.45)
        {
            //cell.contentView.backgroundColor  = [UIColor colorWithRed: 243/255.0f green:156/255.0f blue:18/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];
            cell.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
        }
        else if(check > 0.0)
        {
            //cell.contentView.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
            cell.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];

        }
        else
        {
            //cell.contentView.backgroundColor  = [UIColor colorWithRed: 231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
            cell.backgroundColor  = [UIColor colorWithRed: 155/255.0f green:89/255.0f blue:182/255.0f alpha:1.0f];
            cell.contentView.backgroundColor  = [UIColor whiteColor];
            
        }
        }
        else
        {
                cell.backgroundColor  = [UIColor whiteColor];

        }
      
    }
   
 return cell;
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 && indexPath.row == 0)
    {
       // NSLog(@"%f",[super tableView:tableView heightForRowAtIndexPath:indexPath]);
        //return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        
        return[super tableView:tableView heightForRowAtIndexPath:indexPath] * (indexPath.section == 0 ? 1:1.2);
    }
    float os_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (os_version >= 8.000000)
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath]*-50.3;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath]+6;
    }
    //return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0)return newGrades.count+1;
   // NSLog(@"%lu",(unsigned long)classes.count);
    if(section == 2)
    {
        return 3;
    }
    return classes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle;
    if( section == 0 ) return @"New Grades";
    else if (section ==1)
    {
        return @"My Classes";
    }
    else
    {
         return @"Account";
    }
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle;
//    if( section == 0 )
//    {
//        sectionTitle = @"New Grades";
//        NSLog(@"Hello");
//    }
//    else if (section ==1)
//    {
//        sectionTitle = @"My Classes";
//    }
//    else
//    {
//        sectionTitle = @"Account";
//    }
//    // Create label with section title
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(10, -5, 284, 23);
//    label.textColor = [UIColor grayColor];
//    label.font = [UIFont fontWithName:@"Avenir" size:14];
//    label.text = sectionTitle;
//    label.backgroundColor = [UIColor clearColor];
//    
//    // Create header view and add label as a subview
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    [view addSubview:label];
//    
//    return view;
//}

-(void)logout
{
    [[CWDataStore sharedInstance] gradesLogout];
    CWLoginController *login = [[CWLoginController alloc] init];
    [[self navigationController] pushViewController:login animated:NO];
    [self refresh];


}

-(void)presentLogin{
    //[self.navigationController popToRootViewControllerAnimated:NO];
   CWLoginController *login = [[CWLoginController alloc] init];
  [[self navigationController] pushViewController:login animated:YES];

}

@end
