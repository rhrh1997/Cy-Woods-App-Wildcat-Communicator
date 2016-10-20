//
//  CWGradeDetailController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/15/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWGradeDetailController.h"

@implementation CWGradeDetailController

-(id)initWithId:(NSString *)_id{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        self.navigationItem.title = @"Assignment";
        identifier = _id;
        [self refresh];
    }
    
    return self;
}

-(void)refresh{
    dict = [[CWDataStore sharedInstance] gradeDetails:identifier];
    grade = [dict objectForKey:@"Grade"];
    name = [dict objectForKey:@"Name"];
    klass = [dict objectForKey:@"Class"];
    extra = [dict objectForKey:@"Details"];
    self.navigationItem.title = name;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if( indexPath.section == 0){
        if( indexPath.row == 0){
            cell.textLabel.text = name;
            cell.detailTextLabel.text = @"";
        }else if( indexPath.row == 1){
            cell.textLabel.text = @"Grade";
            cell.detailTextLabel.text = grade;
        }else if( indexPath.row == 2){
            cell.textLabel.text = @"Class";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = klass;
        }
    }else{
        NSString *k = [[extra allKeys] objectAtIndex:indexPath.row];
        cell.textLabel.text = k;
        cell.detailTextLabel.text = [extra objectForKey:k];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 && indexPath.row == 2){
        [self.navigationController pushViewController:[[CWGradeClassController alloc] initWithClass:klass] animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0 ) return 3;
    return extra.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 && indexPath.row == 2) return YES;
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0) return @"Information";
    return @"More Details";
}


@end
