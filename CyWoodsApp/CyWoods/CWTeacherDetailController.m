//
//  CWTeacherDetailController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/6/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWTeacherDetailController.h"

@implementation CWTeacherDetailController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        self.tabBarItem.title = @"Teachers";
        UINavigationItem *item = self.navigationItem;
        
        if(teacher){
            item.title = teacher;
            dict = [[CWDataStore sharedInstance] teacherInfo:teacher];
            [self reload];
        }
    }
    
    return self;
}

- (void)reload{
    links = [dict objectForKey:@"links"];
    folders = [dict objectForKey:@"folders"];
    web = [dict objectForKey:@"website"];
    photo = [dict objectForKey:@"photo"];
    desc = [dict objectForKey:@"description"];
    name = [dict objectForKey:@"name"];
    email = [dict objectForKey:@"email"];
    
    //NSLog(@"%@", dict);
    
    NSMutableArray *ar = [NSMutableArray array];
    info = ar;
    [ar addObject:@"n"];
    if( desc ) [ar addObject:@"d"];
    if( email ) [ar addObject:@"e"];
    if( web ) [ar addObject:@"w"];
    
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];
}

- (id)initWithTeacher:(NSString *)t{
    teacher = t;
    return [self init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0){
        NSString *str = [info objectAtIndex:indexPath.row];
        if( [str isEqualToString:@"w"]){
            [self request:web];
        }else if( [str isEqualToString:@"e"]){
            [self email:email];
        }
    }else if( indexPath.section == 1){
        if( links )
            [self request:[[links objectAtIndex:indexPath.row] objectAtIndex:0]];
        else if( folders )
            [self request:[[folders objectAtIndex:indexPath.row] objectAtIndex:0]];
    }else{
        if( folders )
            [self request:[[folders objectAtIndex:indexPath.row] objectAtIndex:0]];
    }
}

- (void)request:(NSString *)req{
    CWWebViewController *wcon = [[CWWebViewController alloc] initWithRequest:req];
    [[self navigationController] pushViewController:wcon animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SubtitleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.detailTextLabel.text = @"";
    cell.textLabel.numberOfLines = 1;
    
    if( indexPath.section == 0){
        if( indexPath.row == 0){
            cell.textLabel.text = name;
            if( photo ){
                cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo]]];
                cell.imageView.clipsToBounds = YES;
            }
        }else{
            NSString *str = [info objectAtIndex:indexPath.row];
            if( [str isEqualToString:@"d"]){
                cell.textLabel.text = desc;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
            }else if( [str isEqualToString:@"e"]){
                cell.textLabel.text = @"Email Teacher";
                cell.detailTextLabel.text = email;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if( [str isEqualToString:@"w"] ){
                cell.textLabel.text = @"Visit Website";
                cell.detailTextLabel.text = web;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }else if( indexPath.section == 1){
        if(links ){
            NSArray * ar = [links objectAtIndex:indexPath.row];
            cell.textLabel.text = [ar objectAtIndex:1];
            cell.detailTextLabel.text = [ar objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if( folders ){
            NSArray * ar = [folders objectAtIndex:indexPath.row];
            cell.textLabel.text = [ar objectAtIndex:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 2){
        if( folders ){
            NSArray * ar = [folders objectAtIndex:indexPath.row];
            cell.textLabel.text = [ar objectAtIndex:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    //cell.textLabel.text = [[self objectInDictAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0){
        if( indexPath.row == 0 && photo){
            return 80;
        }
        if( indexPath.row == 1 && desc){
            CGSize textSize = [desc sizeWithFont:[UIFont systemFontOfSize: 16] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            return textSize.height+20;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0){
        if( indexPath.row == 0 ) return NO;
        if( indexPath.row == 1 && desc) return NO;
    }
    return YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    int ct = 1;
    if( links) ct++;
    if( folders) ct++;
    return ct;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if( section == 0){
        return info.count;
    }else if( section == 1){
        if( links )
            return links.count;
        if( folders )
            return folders.count;
    }else if( section == 2){
        if( folders )
            return folders.count;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0){
        return @"Teacher Information";
    }else if( section == 1){
        if( links )
            return @"Quick Links";
        if( folders )
            return @"Shared Folders";
    }else if( section == 2){
        if( folders )
            return @"Shared Folders";
    }
    return nil;
}

-(void)email:(NSString *)_email{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObjects:_email, nil]];
    [self.navigationController presentViewController:mail animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
