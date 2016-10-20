//
//  CWDataStore.m
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import "CWDataStore.h"

@implementation CWDataStore
 
-(id)init{
    self = [super init];
    if( self ){
        client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:SERVER]];
        refreshable = [NSMutableArray array];
        [self loadCache];
        //[self refresh];
    }
    return self;
}

+(CWDataStore *)sharedInstance{
    static CWDataStore *store = nil;
    if( !store )
        store = [[CWDataStore alloc] init];
    return store;
}

-(void)addRefresh:(id)listener{
    [refreshable addObject:listener];
}

-(void)refresh{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"refresh" forKey:@"action"];
    [(CWAppDelegate *)[UIApplication sharedApplication].delegate addLoading:@"Refreshing Data..."];
    [self refresh:dict completion:nil];
}

-(void)refresh:(NSMutableDictionary *)dict completion:(void (^)(id ret)) block{
    for( NSString * key in [data allKeys] ){
        NSDictionary *val = [data objectForKey:key];
        [dict setObject:[val objectForKey:@"version"] forKey:[@"ver$" stringByAppendingString:[val objectForKey:@"name"]]];
    }
    if( user && pass ){
        [dict setObject:user forKey:@"user"];
        [dict setObject:[CWUtil encodePassword:pass forUser:user] forKey:@"pass"];
    }
    [dict setObject:notificationsOn?@"true":@"false" forKey:@"notifications"];
    [dict setObject:remindersOn?@"true":@"false" forKey:@"reminders"];
    [dict setObject:[UIDevice currentDevice].name forKey:@"devicename"];
    //NSLog(@"%@", dict);
    if( devid )
        [dict setObject:devid forKey:@"device"];
    [client postPath:APIPATH parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        NSArray *ret = [CWUtil jsonFromString:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
        NSLog(@"%@", ret);
        if( ret ){
            for( NSDictionary * dict in ret){
                NSString *name = [dict objectForKey:@"name"];
                NSDictionary *tmp = [data objectForKey:name];
                if( !tmp || [[tmp objectForKey:@"version"] intValue] != [[dict objectForKey:@"version"] intValue])
                    [data setObject:dict forKey:name];
            }
            [self setData:data];
        }
        if( block )
            block(ret);
        [(CWAppDelegate *)[UIApplication sharedApplication].delegate stopLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@ %@", operation, error);
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error Refreshing Data: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        if( block )
            block(nil);
        [(CWAppDelegate *)[UIApplication sharedApplication].delegate stopLoading];
    }];
}

-(void)setData:(NSDictionary *)_data{
    if( _data ){
        data = [_data mutableCopy];
        teachers = [CWUtil jsonFromString:[[data objectForKey:@"teachers"] objectForKey:@"data"]];
        gradesAll = [CWUtil jsonFromString:[[data objectForKey:@"grades"] objectForKey:@"data"]];
        //NSLog(@"%@", gradesAll);
        if( gradesAll ){
            grades = [NSMutableDictionary dictionary];
            for(NSDictionary *dict in [gradesAll objectForKey:@"Classes"])
                for(NSDictionary *d2 in [dict objectForKey:@"Assignments"]){
                    NSMutableDictionary *tmp = [d2 mutableCopy];
                    [tmp setObject:[dict objectForKey:@"Name"] forKey:@"Class"];
                    [grades setObject:tmp forKey:[tmp objectForKey:@"id"]];
                }
            gradesClass = [NSMutableDictionary dictionary];
            for(NSDictionary *dict in [gradesAll objectForKey:@"Classes"])
                [gradesClass setObject:dict forKey:[dict objectForKey:@"Name"]];
            if( [gradesAll objectForKey:@"New Grades"])
                [UIApplication sharedApplication].applicationIconBadgeNumber = [[gradesAll objectForKey:@"New Grades"] count];
            else [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            //NSLog(@"%@", data);
        }
        NSString *login = [[data objectForKey:@"login"] objectForKey:@"data"];
        if(login){
            if( [login isEqualToString:@"true"]){
                [self setPref:@"user" val:user];
                [self setPref:@"pass" val:[CWUtil encodePassword:pass forUser:user]];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:login delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            }
        }
        [data removeObjectForKey:@"login"];
        
        //NSLog(@"%@ %@ %@ %@", gradesAll, login, user, pass);
        
        events = [CWUtil jsonFromString:[[data objectForKey:@"events"] objectForKey:@"data"]];
        news = [CWUtil jsonFromString:[[data objectForKey:@"news"] objectForKey:@"data"]];
        bell = [CWUtil jsonFromString:[[data objectForKey:@"bell"] objectForKey:@"data"]];
        athletics = [[data objectForKey:@"athletics"] objectForKey:@"data"];
        //NSLog(@"%@ %@ %@", events, news, bell);
        
        [CWUtil savePlist:data toFile:CACHEFILE];
        
        for(id ref in refreshable)
            [ref refresh];
    }
}

-(void)loadCache{
    user = [self getPref:@"user"];
    devid = [self getPref:@"device"];
    
    remindersOn = [[self getPref:@"reminders"] isEqualToString:@"true"];
    notificationsOn = [[self getPref:@"notifications"] isEqualToString:@"true"];
    
    //NSLog(@"%@", user);
    if( user )
        pass = [CWUtil decodePassword:[self getPref:@"pass"] forUser:user];
    
    [self setData:[NSMutableDictionary dictionaryWithContentsOfFile:CACHEFILE]];
    if( !data )
        data = [[NSMutableDictionary alloc] init];
    
    //NSLog(@"%@ %@", user, pass);
}

-(id)getPref:(NSString *)k{
    [self initPrefs];
    id ret = [prefs objectForKey:k];
    if( !ret){
        if( [k isEqualToString:@"lunch"])
            ret = @"A";
        if( [k isEqualToString:@"reminders"])
            ret = @"true";
        if( [k isEqualToString:@"notifications"])
            ret = @"true";
    }
    return ret;
}

-(void)initPrefs{
    if( !prefs )
        prefs = [NSMutableDictionary dictionaryWithContentsOfFile:PREFSFILE];
    if( !prefs ) prefs = [NSMutableDictionary dictionary];
}

-(void)setPref:(NSString *)k val:(id)obj{
    [self initPrefs];
    if( obj)
        [prefs setObject:obj forKey:k];
    else [prefs removeObjectForKey:k];
    [CWUtil savePlist:prefs toFile:PREFSFILE];
}

-(NSDictionary *)teacherDepartments{
    NSMutableOrderedSet *set = [[NSMutableOrderedSet alloc] init];
    
    for(NSDictionary * dict in teachers)
        [set addObject:[dict objectForKey:@"department"]];
    
    NSDictionary *tmp = [NSDictionary dictionaryWithObject:[[set array] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey:@"Departments"];
    
    return tmp;
}

-(NSDictionary *)teachersForDepartment:(NSString *)dep{
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary * dict in teachers)
        if( [[dict objectForKey:@"department"] isEqualToString:dep]){
            NSString* subj = [dict objectForKey:@"subject"];
            if( ![tmp objectForKey:subj] )
                [tmp setObject:[NSMutableArray array] forKey:subj];
            [[tmp objectForKey:subj] addObject:[dict objectForKey:@"name"]];
            [[tmp objectForKey:subj] sortUsingSelector:@selector(caseInsensitiveCompare:)];
        }
    
    return tmp;
}

-(NSDictionary *)teacherInfo:(NSString *)name{
    
    for(NSDictionary * dict in teachers)
        if( [[dict objectForKey:@"name"] isEqualToString:name])
            return dict;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Information for this teacher is not availble yet", @"description", name, @"name", nil];
}


-(BOOL)gradesLoggedIn{
    return [gradesAll objectForKey:@"Classes"] != nil;
}

-(NSDictionary *)gradesCheckStatus{
    return gradesAll;
}

-(NSDictionary *)gradeDetails:(NSString *)identifier{
    return [grades objectForKey:identifier];
}

-(NSDictionary *)gradesClass:(NSString *)klass{
    NSDictionary *info = [gradesClass objectForKey:klass];
    return [NSDictionary
            dictionaryWithObjectsAndKeys:
            [info objectForKey:@"Assignments"], @"Grades",
             [NSDictionary dictionaryWithObjectsAndKeys:[info objectForKey:@"Grade"], @"Average",
             [info objectForKey:@"Teacher"], @"Teacher", nil], @"Details", nil];
}

-(void)gradesLogin:(NSString *)_user password:(NSString *)_pass completion:(void (^)(NSDictionary *))completion{
    if( _user != nil && _pass != nil){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"login" forKey:@"action"];
        [dict setObject:_user forKey:@"user"];
        [dict setObject:[CWUtil encodePassword:_pass forUser:_user] forKey:@"pass"];
        user = _user;
        pass = _pass;
        [self refresh:dict completion:completion];
        
        [(CWAppDelegate *)[UIApplication sharedApplication].delegate addLoading:@"Logging in..."];
    }else
        completion([self gradesCheckStatus]);
}

-(void)gradesClear{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"clear" forKey:@"action"];
    [(CWAppDelegate *)[UIApplication sharedApplication].delegate addLoading:@"Refreshing Data..."];
    [self refresh:dict completion:nil];
}

-(void)gradesLogout:(void(^)(id ret))completion{
    [self setPref:@"user" val:nil];
    [self setPref:@"pass" val:nil];
    user = nil;
    pass = nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"logout" forKey:@"action"];
    [(CWAppDelegate *)[UIApplication sharedApplication].delegate addLoading:@"Logging out..."];
    [self refresh:dict completion:completion];
}

-(void)gradesLogout{
    [self gradesLogout:nil];
}

-(NSArray *)news{
    return news;
}

-(NSArray *)events{
    return events;
}

-(NSString *)athletics{
    return athletics;
}


-(BOOL)settingsNotificationsOn{
    return notificationsOn;
}

-(BOOL)settingsRemindersOn{
    return remindersOn;
}

-(void)settingsSetNotifications:(UISwitch *)sender{
    notificationsOn = sender.on;
    [self setPref:@"notifications" val:notificationsOn?@"true":@"false"];
    [self refresh];
}

-(void)settingsSetReminders:(UISwitch *)sender{
    remindersOn = sender.on;
    [self setPref:@"reminders" val:remindersOn?@"true":@"false"];
    [self refresh];
}

-(NSString *)bellLunch{
    return [self getPref:@"lunch"];
}

-(NSArray *)bellSchedule{
    return [self bellSchedule:[self bellLunch] extended:[self bellExtended]];
}

-(NSArray *) bellSchedule:(NSString *)_lunch extended:(BOOL)ext{
    return [bell objectForKey:_lunch];
}

-(BOOL)bellExtended{
    return NO;
}

-(void)bellSwitch{
    if( [[self getPref:@"lunch"] isEqualToString:@"A"])
        [self setPref:@"lunch" val:@"B"];
    else if( [[self getPref:@"lunch"] isEqualToString:@"B"])
        [self setPref:@"lunch" val:@"C"];
    else if( [[self getPref:@"lunch"] isEqualToString:@"C"])
        [self setPref:@"lunch" val:@"A"];
}

-(void)setDevid:(NSString *)_devid{
    BOOL exists = devid != nil && [devid isEqualToString:_devid];
    devid = _devid;
    [self setPref:@"device" val:devid];
    if( !exists )
        [self refresh];
}


@end
