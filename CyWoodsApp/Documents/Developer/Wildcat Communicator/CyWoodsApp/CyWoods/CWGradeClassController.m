//
//  CWGradeClassController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/17/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWGradeClassController.h"

@implementation CWGradeClassController

-(id)initWithClass:(NSString *)_klass{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        klass = _klass;
        [self refresh];
    }
    
    return self;
}

-(void)refresh{
    dict = [[CWDataStore sharedInstance] gradesClass:klass];
    //NSLog(@"%@", dict);
    self.navigationItem.title = klass;
    info = [dict objectForKey:@"Details"];
    grades = [dict objectForKey:@"Grades"];
    NSMutableArray *tmp = [[info allKeys] mutableCopy];
    if( [tmp containsObject:@"Average"]){
        [tmp removeObject:@"Average"];
        [tmp addObject:@"Average"];
    }
    if( [tmp containsObject:@"Teacher"]){
        [tmp removeObject:@"Teacher"];
        [tmp addObject:@"Teacher"];
    }
    infoKeys = tmp;
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"DetailCell";
    static NSString *CellIdentifier2 = @"DetailCellS";
    
    UITableViewCell *cell = nil;
    if( indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if( indexPath.section == 0){
        NSString *k = [infoKeys objectAtIndex:indexPath.row];
        cell.textLabel.text = k;
        cell.detailTextLabel.text = [info objectForKey:k];
        if( [k isEqualToString:@"Teacher"] )
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *k = [grades objectAtIndex:indexPath.row];
        cell.textLabel.text = [k objectForKey:@"Name"];
        cell.detailTextLabel.text = [k objectForKey:@"Grade"];
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [super tableView:tableView heightForRowAtIndexPath:indexPath] * (indexPath.section == 0 ? 1:1.2);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0 ) return infoKeys.count;
    return grades.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 1){
        [self.navigationController pushViewController:[[CWGradeDetailController alloc] initWithId:[[grades objectAtIndex:indexPath.row] objectForKey:@"id"]] animated:YES];
    }else{
        if( [[infoKeys objectAtIndex:indexPath.row] isEqualToString:@"Teacher"])
            [self.navigationController pushViewController:[[CWTeacherDetailController alloc ] initWithTeacher:[info objectForKey:@"Teacher"]] animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 1){
        return YES;
    }
    if( [[infoKeys objectAtIndex:indexPath.row] isEqualToString:@"Teacher"])
        return YES;
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0) return @"Class Details";
    return @"Grades";
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

@end
