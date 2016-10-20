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
        SWRevealViewController *revealController = [self revealViewController];
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
    int h = [[UIScreen mainScreen] bounds].size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed: @"LoginView.jpg"];
    if([[UIScreen mainScreen] bounds].size.height == 480) {
        NSLog(@"Attempting smaller screen size");
        image = [UIImage imageNamed: @"LoginView4.jpg"];
    }
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [[self view] addSubview:imageView];
    [[self view] sendSubviewToBack:imageView];
    //[[self view] setClipsToBounds:true];
    self.view.window.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"CWFieldCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CWFieldCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    
    usernameField = [self.tableView dequeueReusableCellWithIdentifier:@"CWFieldCell"];
    usernameField.field.returnKeyType = UIReturnKeyNext;
    usernameField.label.text = @"";
    usernameField.label.textAlignment = NSTextAlignmentCenter;
    usernameField.field.placeholder = @"Username";
    usernameField.field.delegate = self;
    usernameField.backgroundColor = [UIColor clearColor];
    
    passwordField = [self.tableView dequeueReusableCellWithIdentifier:@"CWFieldCell"];
    passwordField.field.returnKeyType = UIReturnKeyGo;
    passwordField.label.textAlignment = NSTextAlignmentCenter;
    passwordField.field.placeholder = @"Password";
    passwordField.field.secureTextEntry = YES;
    passwordField.label.text = @"";
    passwordField.field.delegate = self;
    passwordField.backgroundColor = [UIColor clearColor];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resign)];
    tap.delegate = self;
    
    [self.tableView addGestureRecognizer:tap];
    self.tableView.scrollEnabled = NO;
    
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

    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = loginMessage;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];break;
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
    return @" ";
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
