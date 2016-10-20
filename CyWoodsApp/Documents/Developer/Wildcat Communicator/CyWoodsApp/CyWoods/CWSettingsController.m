//
//  CWSettingsController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/29/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWSettingsController.h"

@implementation CWSettingsController

-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ) {
        self.navigationItem.title = @"Settings";
        [self reload];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];
}

-(void)reload{
    loggedIn = [[CWDataStore sharedInstance] gradesLoggedIn];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0 ) return 2;
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0 ) return @"Notifications";
    return @"Account";
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 1 && [[CWDataStore sharedInstance] gradesLoggedIn]){
        [[CWDataStore sharedInstance] gradesLogout:^(id ret) {
            [self.tableView reloadData];
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 ){
        static NSString *cellId = @"SwitchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if( cell == nil ){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
        sw.on = indexPath.row == 0 ? [[CWDataStore sharedInstance] settingsRemindersOn] : [[CWDataStore sharedInstance] settingsNotificationsOn];
        [sw addTarget:[CWDataStore sharedInstance] action:indexPath.row == 0 ? @selector(settingsSetReminders:) :@selector(settingsSetNotifications:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        cell.textLabel.text = (indexPath.row == 0 ? @"Reminders" :@"Grade Alerts");
        return cell;
    }else{
        static NSString *cellId = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if( cell == nil )
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.text = [[CWDataStore sharedInstance] gradesLoggedIn] ? @"Log out" : @"Not logged in";
        cell.selectionStyle = [[CWDataStore sharedInstance] gradesLoggedIn] ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

@end
