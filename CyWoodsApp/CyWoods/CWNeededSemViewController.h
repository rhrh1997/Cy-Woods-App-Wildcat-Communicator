//
//  CWNeededSemViewController.h
//  CyWoods
//
//  Created by Natasha Solanki on 2/6/15.
//
//

#import <UIKit/UIKit.h>

@interface CWNeededSemViewController : UIViewController
{
    NSString *gradeWanted1;
    double *firstsix1;
    double *secondsix2;
    double *thirdsix;
    NSString *nee1;
    
}

@property (weak, nonatomic) IBOutlet
UIStepper *stepperOut;
-(IBAction)stepperAct:(id)sender;

@property (weak, nonatomic) IBOutlet
UILabel *stepperVal;

@property (weak, nonatomic) IBOutlet
UIButton *calc; 

@property (weak, nonatomic) IBOutlet
UITextField *one;

@property (weak,nonatomic) IBOutlet
UITextField *two;

@property (weak,nonatomic) IBOutlet
UITextField *three;

@property(weak, nonatomic) IBOutlet
UILabel *needs1;

@property(weak, nonatomic) IBOutlet
UILabel *ent1;

@property(weak,nonatomic)  IBOutlet
UILabel *ent2;

@property(weak, nonatomic) IBOutlet
UILabel *ent3;

@property(weak, nonatomic) IBOutlet
UILabel *expl;

@property(weak, nonatomic) IBOutlet
UILabel *uneed;

@property(weak,nonatomic) IBOutlet
UILabel *onur; 










@end
