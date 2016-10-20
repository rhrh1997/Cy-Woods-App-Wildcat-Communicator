//
//  CWNeeded6ViewController.h
//  CyWoods
//
//  Created by Natasha Solanki on 1/29/15.
//
//

#import <UIKit/UIKit.h>

@interface CWNeeded6ViewController : UIViewController <UITextFieldDelegate>

{
    NSString *gradeWanted;
    double *firstsix;
    double *secondsix;
    NSString *nee; 
    

    
}

@property (weak, nonatomic) IBOutlet
UIStepper *stepperOutlet;
- (IBAction)stepperAction:(id)sender;

@property(weak, nonatomic) IBOutlet
UILabel *needs;

@property(weak, nonatomic) IBOutlet
UILabel *explain;

@property (weak,nonatomic) IBOutlet
UILabel *whatuneed;

@property (weak, nonatomic)IBOutlet
UILabel *thisSix;


@property (weak, nonatomic) IBOutlet
UILabel *stepperValLabel;

@property(weak, nonatomic) IBOutlet
UIButton *calculate;
-(IBAction)calc:(id)sender;

@property(weak, nonatomic) IBOutlet
UILabel *ent1grade;

@property(weak, nonatomic) IBOutlet
UILabel *ent2grade;

@property(weak, nonatomic) IBOutlet
UIStepper *bob;

@property(weak, nonatomic) IBOutlet
UITextField *fsix;

@property(weak, nonatomic) IBOutlet
UITextField *ssix;


@end
 