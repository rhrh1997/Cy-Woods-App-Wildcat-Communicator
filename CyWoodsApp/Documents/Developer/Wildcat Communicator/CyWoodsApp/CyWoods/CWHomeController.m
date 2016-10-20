//
//  CWHomeController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWHomeController.h"

@implementation CWHomeController

- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle{
    self = [super initWithNibName:@"CWHomeController" bundle: [NSBundle mainBundle]];
    
    if( self ){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"bar_home.png"] tag:0];
        self.navigationItem.title = @"Home";
        if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            self.edgesForExtendedLayout = UIRectEdgeTop;
        [[CWDataStore sharedInstance] addRefresh:self];
        [self refresh];
    }
    
    return self;
}

-(void)refresh{
    news = [[CWDataStore sharedInstance] news ];
    [table reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidLoad{
    UIEdgeInsets inset = UIEdgeInsetsMake([[UIScreen mainScreen] bounds].size.height*0.5, 0, 0, 0);
    table.contentInset = inset;
    table.separatorColor = [UIColor grayColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *obj = [news objectAtIndex:indexPath.row];
    if( [obj objectForKey:@"Link"] ){
        [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:[obj objectForKey:@"Link"]] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary *obj = [news objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"Info"];
    if( [obj objectForKey:@"Link"])
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return news.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize textSize = [[[news objectAtIndex:indexPath.row] objectForKey:@"Info"] sizeWithFont:[UIFont systemFontOfSize: 15] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return textSize.height+20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)setup{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
