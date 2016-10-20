//
//  CWGradeNotifierController.h
//  CyWoods
//
//  Created by RAZA on 10/15/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWGradeNotifierController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *gradeName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *aboveBelow;
@property (strong, nonatomic) IBOutlet UILabel *gradeNumber;
@property (strong, nonatomic) IBOutlet UIStepper *gradeStepper;
@property (strong, nonatomic) IBOutlet UIButton *notifyButton;

@end
