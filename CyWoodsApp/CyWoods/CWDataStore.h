//
//  CWDataStore.h
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CWUtil.h"
#import "CWAppDelegate.h"

#define DOCS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define CACHEFILE [DOCS stringByAppendingPathComponent:@"cache.plist"]
#define PREFSFILE [DOCS stringByAppendingPathComponent:@"prefs.plist"]
#define SERVER @"https://mycywoods.appspot.com"
//#define SERVER @"http://localhost:8888"
//#define SERVER @"http://192.168.1.71:8888"

#define APIPATH @"api"

@interface CWDataStore : NSObject{
    
    NSMutableDictionary *data;
    NSMutableDictionary *prefs;
    NSMutableArray *refreshable;
    AFHTTPClient *client;
    
    BOOL remindersOn, notificationsOn;
    
    NSDictionary *teachers;
    NSString *athletics;
    NSArray *news;
    
    NSDictionary *notification;
    NSDictionary *gradesAll;
    NSMutableDictionary *grades;
    NSMutableDictionary *gradesClass;
    
    NSArray *events;
    NSDictionary *bell;
    
    NSString *user;
    NSString *pass;
    NSString *devid;
    
    
}

@property (nonatomic, strong) NSMutableDictionary *notes;

+(CWDataStore *)sharedInstance;

-(id)getPref:(NSString *)k;
-(void)setPref:(NSString *)k val:(id)obj;
-(void)initPrefs;

-(void)setDevid:(NSString *)devid;

-(void)loadCache;
-(void)refresh;
-(void)addRefresh:(id)listener;
-(void)refresh:(NSMutableDictionary *)params completion:(void (^)(id ret)) block;
-(void)setData:(NSDictionary *)data;

-(NSDictionary *)teacherDepartments;
-(NSDictionary *)teacherInfo:(NSString *)name;
-(NSDictionary *)teachersForDepartment:(NSString *)dep;

-(BOOL)gradesLoggedIn;
-(NSDictionary *)gradesCheckStatus;
-(void)gradesLogin:(NSString *)user password:(NSString *)pass completion:(void(^)(NSDictionary *))completion;
-(NSDictionary *)gradeDetails:(NSString *)identifier;
-(NSDictionary *)gradesClass:(NSString *)klass;
-(void)gradesClear;
-(void)gradesLogout;
-(void)gradesLogout:(void(^)(id ret))completion;

-(NSArray *)news;
-(NSArray *)events;
-(NSString *)athletics;

-(BOOL)settingsRemindersOn;
-(void)settingsSetReminders:(UISwitch *)sender;
-(BOOL)settingsNotificationsOn;
-(void)settingsSetNotifications:(UISwitch *)sender;

-(NSArray *)bellSchedule;
-(NSArray *)bellSchedule:(NSString *)lunch extended:(BOOL)ext;
-(NSString *)bellLunch;
-(BOOL)bellExtended;
-(void)bellSwitch;
-(void)addToNotifer:(NSString *)name :(NSString *)grade :(Boolean *)threshold;
-(void)getNotifiers;

@end
