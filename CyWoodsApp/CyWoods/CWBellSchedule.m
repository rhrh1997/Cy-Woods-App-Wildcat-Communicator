//
//  CWBellSchedule.m
//  CyWoods
//
//  Created by Rishabh Dhar on 8/8/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWBellSchedule.h"

@implementation CWBellSchedule

static int toNum(NSString *str){
    NSArray *ar1 = [str componentsSeparatedByString:@" "];
    bool pm = [[ar1 objectAtIndex:1] isEqualToString:@"PM"];
    NSArray *ar2 = [[ar1 objectAtIndex:0] componentsSeparatedByString:@":"];
    return [[ar2 objectAtIndex:0] intValue]%12 * 60 + (pm?12*60:0) + [[ar2 objectAtIndex:1] intValue];
}

static bool isLess(NSString *t1, NSString *t2){
    return toNum(t1) < toNum(t2);
}

static NSInteger secs(){
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:NSSecondCalendarUnit fromDate:now];
    return dateComponents.second;
}


static NSString* curTime(){
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit) fromDate:now];
    NSInteger hour = [dateComponents hour];
    BOOL pm=hour>=12;
    if (hour>12) hour=hour%12;
    NSInteger minute = [dateComponents minute];
    return [NSString stringWithFormat:@"%ld:%02ld %@", (long)hour, (long)minute, pm?@"PM":@"AM"];
}

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self ){
        self.navigationItem.title = @"Bell Schedule";
        [self refresh];
    }
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
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    return self;
}

- (void)refresh{
    schedule = [[CWDataStore sharedInstance] bellSchedule];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Lunch %@", [[CWDataStore sharedInstance] bellLunch]] style:UIBarButtonItemStyleBordered target:self action:@selector(bellSwitch)];
    NSString *time = curTime();
    if( isLess(time, [[schedule objectAtIndex:0] objectForKey:@"Start"]) || !isLess(time, [[schedule objectAtIndex:schedule.count-1] objectForKey:@"End"]))
        cur = nil;
    else{
        for(int i = 0; i<schedule.count; i++)
            if(isLess(time, [[schedule objectAtIndex:i] objectForKey:@"End"])){
                cur = [schedule objectAtIndex:i];
                break;
            }
    }
    [self.tableView reloadData];
    timer = [NSTimer scheduledTimerWithTimeInterval:(60-secs()) target:self selector:@selector(refresh) userInfo:nil repeats:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [self refresh];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%@ %d", cur, section);
    if( section == 0 ) return cur ? 2 : 1;
    return schedule.count;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    NSDictionary *obj = nil;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:16];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:9];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if( indexPath.section == 1 )
        obj = [schedule objectAtIndex:indexPath.row];
    else obj = cur;
    if( obj == nil || (indexPath.section == 0 && indexPath.row == 1)){
        if( indexPath.row == 0 )
            cell.textLabel.text = @"No classes currently";
        else
            cell.textLabel.text = [NSString stringWithFormat:@"%d minutes until next class", toNum([obj objectForKey:@"End"])-toNum(curTime())];
        cell.detailTextLabel.text = nil;
    }else{
        cell.textLabel.text = [obj objectForKey:@"Name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [obj objectForKey:@"Start"], [obj objectForKey:@"End"]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return -50.2*[super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 0 ) return @"Current Class";
    return @"Schedule";
}

-(void)bellSwitch{
    [[CWDataStore sharedInstance] bellSwitch];
    [self refresh];
}

@end
