//
//  CWNeeded6ViewController.m
//  CyWoods
//
//  Created by Natasha Solanki on 1/29/15.
//
//

#import "CWNeeded6ViewController.h"

@interface CWNeeded6ViewController ()

@end


@implementation CWNeeded6ViewController

@synthesize stepperOutlet, stepperValLabel;




- (void)viewDidLoad {
    [super viewDidLoad];
    _needs.hidden =YES;
    _whatuneed.hidden = YES;
    _thisSix.hidden = YES;
    self.navigationItem.title = @"Six Weeks";
    [_ssix setDelegate:self];
    [_fsix setDelegate:self];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    
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


- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    NSUInteger value = sender.value;
    if(value == 1)
    {
        stepperValLabel.text = @"D";
    }
    if(value == 2)
    {
        stepperValLabel.text = @"C";
    }
    if(value == 3)
    {
        stepperValLabel.text = @"B";
        
    }
    if(value == 4)
    {
        stepperValLabel.text = @"A";
    }

    
}


- (IBAction)stepperAction:(id)sender
{
    

    

}
- (IBAction)calcGrade:(id)sender
{
    gradeWanted = stepperValLabel.text;
    
    NSString *fs = _fsix.text;
    double firstDouble = [fs doubleValue];
  
    
    NSString *ss = _ssix.text;
    double secDouble = [ss doubleValue];
    
    
    double add = firstDouble + secDouble;
    double avg;

    
    if( [gradeWanted isEqualToString:@"A"])
    {
        add = 268.5 - add;
        avg= add;
        
        
    }
    if([gradeWanted isEqualToString:@"B"])
    {
        add = 238.5 - add;
        
        avg = add;
        
    }
    if([gradeWanted isEqualToString:@"C"])
    {
        add = 223.5 - add;
        
        avg = add;
    }
    if([gradeWanted isEqualToString:@"D"])
    {
        add = 208.5 - add;
        
        avg = add;
    }
    
     NSString *a = [NSString stringWithFormat: @"%.2f",avg];
     nee = a;
    _needs.text = nee;
    
    _needs.hidden = NO;
    _whatuneed.hidden = NO;
    _thisSix.hidden = NO;
    _explain.hidden = YES;
    stepperValLabel.hidden = YES;
    stepperOutlet.hidden = YES;
    _calculate.hidden = YES;
    _fsix.hidden = YES;
    _ssix.hidden = YES;
    _ent1grade.hidden = YES;
    _ent2grade.hidden = YES;
    _bob.hidden = YES;
    
    
    
    
    
    
    
}
@end
