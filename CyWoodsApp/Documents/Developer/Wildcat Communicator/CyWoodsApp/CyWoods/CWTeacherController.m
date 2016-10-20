//
//  CWTeacherController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWTeacherController.h"

@implementation CWTeacherController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        [[CWDataStore sharedInstance] addRefresh:self];
        [self refresh];
    }
    
    return self;
}

- (void)setup{
    self.navigationController.tabBarItem = [[UITabBarItem alloc ] initWithTitle:@"Staff" image:[UIImage imageNamed:@"bar_teacher.png"] tag:0];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)refresh{
    UINavigationItem *item = self.navigationItem;
    if( dep){
        dict = [[CWDataStore sharedInstance] teachersForDepartment:dep];
        item.title = dep;
    }else{
        dict = [[CWDataStore sharedInstance] teacherDepartments];
        item.title = @"Teachers";
    }
    sections = [[dict allKeys] mutableCopy];
    [sections sortUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.tableView reloadData];
}

- (id)initWithDepartment:(NSString *)_dep{
    dep = _dep;
    return [self init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( dep ){
        NSString *d =[[self objectInDictAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        CWTeacherDetailController *con = [[CWTeacherDetailController alloc] initWithTeacher:d];
        [[self navigationController] pushViewController:con animated:YES];
    }else{
        NSString *d =[[self objectInDictAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        CWTeacherController *con = [[CWTeacherController alloc] initWithDepartment:d];
        [[self navigationController] pushViewController:con animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PlainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self objectInDictAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [dict count];
}

-(id)objectInDictAtIndex:(NSUInteger)index{
    return [dict objectForKey:[sections objectAtIndex:index]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger) [[self objectInDictAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sections objectAtIndex:section];
}


@end
