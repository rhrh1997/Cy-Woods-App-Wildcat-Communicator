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
    cell.textLabel.font = [UIFont
                           fontWithName:@"Avenir" size:16];
    cell.detailTextLabel.font = [UIFont
                           fontWithName:@"Avenir" size:14];
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
        float check = [[k objectForKey:@"Grade"] floatValue];
        if(self.isSomethingEnabled == true) //check if ColorCodes are enabled
        {
            
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
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // return [super tableView:tableView heightForRowAtIndexPath:indexPath] * (indexPath.section == 0 ? 1:1.2);
    return [super tableView:tableView heightForRowAtIndexPath:indexPath]*-50.3;

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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle;
//    if( section == 0 )
//    {
//        sectionTitle = @"a";
//    }
//    else if (section == 1)
//    {
//        sectionTitle = @"Grades";
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

@end
