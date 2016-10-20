//
//  CWGradeDetailController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/15/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWDataStore.h"
#import "CWGradeCell.h"
#import "CWGradeClassController.h"

@class CWGradeClassController;
@interface CWGradeDetailController : UITableViewController{
    NSDictionary *dict;
    NSDictionary *extra;
    NSString *identifier;
    NSString *name;
    NSString *klass;
    NSString *grade;
}

-(id)initWithId:(NSString *)_id;
-(void)refresh;

@end
