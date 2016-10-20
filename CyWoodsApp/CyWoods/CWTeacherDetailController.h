//
//  CWTeacherDetailController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/6/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CWDataStore.h"
#import "CWWebViewController.h"

@interface CWTeacherDetailController : UITableViewController <MFMailComposeViewControllerDelegate> {
    NSString *teacher;
    NSDictionary *dict;
    
    NSArray *links;
    NSArray *folders;
    NSArray *info;
    
    NSString *name;
    NSString *photo;
    NSString *desc;
    NSString *web;
    NSString *email;
}

-(id)initWithTeacher:(NSString *)t;
-(void)request:(NSString *)req;
-(void)email:(NSString *)email;
-(void)reload;

@end
