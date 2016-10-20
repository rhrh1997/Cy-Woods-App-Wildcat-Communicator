//
//  CWTeacherController.h
//  CyWoods
//
//  Created by Andrew Liu on 8/5/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWDataStore.h"
#import "CWTeacherDetailController.h"

@interface CWTeacherController : UITableViewController{
    NSDictionary *dict;
    NSString *dep;
    NSMutableArray *sections;
}

-(id)objectInDictAtIndex:(NSUInteger)index;
-(id)initWithDepartment:(NSString* )dep;
-(void)setup;

@end
