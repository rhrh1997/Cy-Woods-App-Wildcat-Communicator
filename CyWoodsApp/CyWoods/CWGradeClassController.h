//
//  CWGradeClassController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/17/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWDataStore.h"
#import "CWGradeDetailController.h"
#import "CWTeacherDetailController.h"

@class CWGradeDetailController;

@interface CWGradeClassController : UITableViewController{
    NSDictionary *dict;
    NSDictionary *info;
    
    NSArray *grades;
    NSArray *infoKeys;
    
    NSString *klass;
}

-(id)initWithClass:(NSString *)klass;
-(void)refresh;
@property(nonatomic) BOOL *isSomethingEnabled;


@end
