//
//  CWCalendarController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/29/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWCalendarController.h"

@implementation CWCalendarController

-(id)init{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if( self ){
        self.navigationItem.title = @"Events";
        [self refresh];
    }
    
    return self;
}

-(void)refresh{
    ar = [[CWDataStore sharedInstance] events];
    days = [NSMutableArray array];
    events = [NSMutableDictionary dictionary];
    for(NSDictionary *dict in ar){
        NSString *date = [dict objectForKey:@"Date"];
        if( ![events objectForKey:date]){
            [days addObject:date];
            [events setObject:[NSMutableArray array] forKey:date];
        }
        [[events objectForKey:date] addObject:dict];
    }
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[events objectForKey:[days objectAtIndex:section]] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return days.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [days objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellSubtitle";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    NSDictionary *dict = [[events objectForKey:[days objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"Name"];
    cell.detailTextLabel.text = [dict objectForKey:@"Description"];
    if( [dict objectForKey:@"Link"])
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1.2*[super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[events objectForKey:[days objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if( [dict objectForKey:@"Link"]) return YES;
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[events objectForKey:[days objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if( [dict objectForKey:@"Link"])
        [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:[dict objectForKey:@"Link"]] animated:YES];
}

@end
