//
//  CWGradeController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWGradeController.h"

@implementation CWGradeController

- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        UINavigationItem *item = self.navigationItem;
        item.title = @"Grades";
        
        [[CWDataStore sharedInstance] addRefresh:self];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [self refresh];
}

- (void)refresh{
    NSDictionary *status = [[CWDataStore sharedInstance] gradesCheckStatus];
    loggedIn = NO;
    if( [status objectForKey:@"error"]){
        [self presentLogin];
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        newGrades = [status objectForKey:@"New Grades"];
        classes = [status objectForKey:@"Classes"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:[CWDataStore sharedInstance] action:@selector(gradesLogout)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadModel)];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)reloadModel{
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    [[CWDataStore sharedInstance] refresh];
}

- (void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:@"CWDetailValueCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CWDetailValueCell"];
}

- (void)setup{
    self.navigationController.tabBarItem = [[UITabBarItem alloc ] initWithTitle:@"Grades" image:[UIImage imageNamed:@"bar_graph.png"] tag:0];
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
    }else{
        if( indexPath.section == 0){
            [self.navigationController pushViewController:[[CWGradeDetailController alloc] initWithId:[[newGrades objectAtIndex:indexPath.row-1] objectForKey:@"id"]] animated:YES];
        }else{
            [self.navigationController pushViewController:[[CWGradeClassController alloc] initWithClass:[[classes objectAtIndex:indexPath.row] objectForKey:@"Name"]] animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CWDetailValueCell";
    
    CWDetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( indexPath.section == 0){
        if( indexPath.row == 0){
            static NSString *CellIdentifier = @"PlainCell";
            
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell2.textLabel.textAlignment = NSTextAlignmentCenter;
            if( newGrades.count == 0 ){
                cell2.textLabel.text = @"No new grades";
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                cell2.textLabel.text = @"Mark new grades as seen";
            }
            return cell2;
        }else{
            NSDictionary *g = [newGrades objectAtIndex:indexPath.row-1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.label.text = [g objectForKey:@"Name"];
            cell.detail.text = [g objectForKey:@"Grade"];
            cell.subtitle.text = [g objectForKey:@"Class"];
        }
    }else if( indexPath.section == 1){
        NSDictionary *c = [classes objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.label.text = [c objectForKey:@"Name"];
        cell.subtitle.text = [c objectForKey:@"Teacher"];
        cell.detail.text = [c objectForKey:@"Grade"];
    }
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 && indexPath.row == 0)
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return [super tableView:tableView heightForRowAtIndexPath:indexPath]*1.3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0)return newGrades.count+1;
    return classes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0 )return @"New Grades";
    return @"My Classes";
}

-(void)presentLogin{
    [self.navigationController popToRootViewControllerAnimated:NO];
    CWLoginController *login = [[CWLoginController alloc] init];
    [self.navigationController pushViewController:login animated:NO];
}

@end
