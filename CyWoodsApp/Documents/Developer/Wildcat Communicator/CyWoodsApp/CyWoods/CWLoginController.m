//
//  CWLoginController.m
//  CyWoods
//
//  Created by Andrew Liu on 8/8/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWLoginController.h"

@implementation CWLoginController

- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if( self ){
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.title = @"Grades";
        
    }
    return self;
}

- (void)refresh{
   [self refresh:[[CWDataStore sharedInstance] gradesCheckStatus]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)refresh:(NSDictionary *)dict{
    logInAllowed = loggingIn = NO;
    if( [dict objectForKey:@"error"]){
        logInAllowed = [[dict objectForKey:@"login"] isEqualToString:@"Available"];
        loginMessage = [dict objectForKey:@"error"];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    if( logInAllowed )
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
    else self.navigationItem.rightBarButtonItem = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CWFieldCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CWFieldCell"];
    
    usernameField = [self.tableView dequeueReusableCellWithIdentifier:@"CWFieldCell"];
    usernameField.field.returnKeyType = UIReturnKeyNext;
    usernameField.label.text = @"User";
    usernameField.field.placeholder = @"Username";
    usernameField.field.delegate = self;
    
    passwordField = [self.tableView dequeueReusableCellWithIdentifier:@"CWFieldCell"];
    passwordField.field.returnKeyType = UIReturnKeyGo;
    passwordField.field.placeholder = @"Password";
    passwordField.field.secureTextEntry = YES;
    passwordField.label.text = @"Password";
    passwordField.field.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resign)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
    
    [self refresh];
}

-(void)resign{
    [passwordField.field resignFirstResponder];
    [usernameField.field resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == passwordField.field) {
        [self login];
    }else{
        [textField resignFirstResponder];
        [passwordField.field becomeFirstResponder];
    }
    return YES;
}

- (void)setup{
    self.navigationController.tabBarItem = [[UITabBarItem alloc ] initWithTitle:@"Grades" image:[UIImage imageNamed:@"bar_graph.png"] tag:0];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PlainCell";
    
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = loginMessage;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.font = [UIFont systemFontOfSize:16];break;
        case 1: cell = usernameField; break;
        case 2: cell = passwordField; break;
        default:
            break;
    }
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0){
        if( indexPath.row == 0 ){
            CGSize textSize = [loginMessage sizeWithFont:[UIFont systemFontOfSize: 16] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            return textSize.height+20;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( logInAllowed)
        return 3;
    else return 1;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Login";
}

-(void)login{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    loggingIn = YES;
    [passwordField.field resignFirstResponder];
    [[CWDataStore sharedInstance] gradesLogin:usernameField.field.text password:passwordField.field.text completion:^(NSDictionary *dict){
        [self loginReturn:[[CWDataStore sharedInstance] gradesCheckStatus]];
    }];
}

-(void)loginReturn:(NSDictionary *)dict{
    //[self removeLoadingView];
    [self refresh:dict];
}

@end
