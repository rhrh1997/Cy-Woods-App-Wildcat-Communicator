//
//  CWNeededSemViewController.m
//  CyWoods
//
//  Created by Natasha Solanki on 2/6/15.
//
//

#import "CWNeededSemViewController.h"

@interface CWNeededSemViewController ()

@end

@implementation CWNeededSemViewController

@synthesize stepperOut,stepperVal;

- (void)viewDidLoad {
    [super viewDidLoad];
    _needs1.hidden = YES;
    _uneed.hidden = YES;
    _onur.hidden = YES;
    self.navigationItem.title = @"Semester";
    [_one setDelegate:self];
    [_two setDelegate:self];
    [_three setDelegate:self];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void) textFieldDidBeginEditing:(UITextField *) textField
{
    [self animateTextField: textField up : YES];
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];

}
-(void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100;
    const float movementDuration = 0.3f;
    
    int movement = (up ? - movementDistance : movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stepperValChange: (UIStepper *)sender
{
    NSUInteger value = sender.value;
    if(value == 1)
    {
        stepperVal.text = @"D";
    }
    if(value == 2)
    {
        stepperVal.text = @"C";
    }
    if(value == 3)
    {
        stepperVal.text = @"B";
        
    }
    if(value == 4)
    {
        stepperVal.text = @"A";
    }
}
- (IBAction)stepperAct:(id)sender
{
    
    
}

- (IBAction)calcSem:(id)sender
{
    gradeWanted1 = stepperVal.text;
    
    NSString *fs = _one.text;
    double fsDouble = [fs doubleValue];
    
    NSString *ss = _two.text;
    double ssDouble = [ss doubleValue];
    
    NSString *ts = _three.text;
    double tsDouble = [ts doubleValue];
    
    
    double add = 2 * (fsDouble + ssDouble + tsDouble);
    double avg;
    
    
    if( [gradeWanted1 isEqualToString:@"A"])
    {
        add = 626.5 - add;
        avg= add;
        
        
    }
    if([gradeWanted1 isEqualToString:@"B"])
    {
        add = 556.5 - add;
        
        avg = add;
        
    }
    if([gradeWanted1 isEqualToString:@"C"])
    {
        add = 524.3 - add;
        
        avg = add;
    }
    if([gradeWanted1 isEqualToString:@"D"])
    {
        add = 486.5 - add;
        
        avg = add;
    }

    NSString *anw = [NSString stringWithFormat:@"%.2f",avg];
    nee1 = anw;
    
    _needs1.text = nee1;
    
    _needs1.hidden = NO;
    _uneed.hidden = NO;
    _onur.hidden = NO;
    
    
    stepperVal.hidden = YES;
    stepperOut.hidden = YES;
    _ent1.hidden = YES;
    _ent2.hidden = YES;
    _ent3.hidden = YES;
    _calc.hidden = YES;
    _one.hidden = YES;
    _two.hidden =YES;
    _three.hidden = YES;
    _expl.hidden = YES; 
    
    

    
    
    
    
    
}


@end
