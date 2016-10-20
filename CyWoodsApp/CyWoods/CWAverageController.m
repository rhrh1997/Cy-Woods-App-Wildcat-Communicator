//
//  CWAverageController.m
//  CyWoods
//
//  Created by Natasha Solanki  on 1/16/15.
//
//

#import "CWAverageController.h"

@interface CWAverageController ()

@end

@implementation CWAverageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Average Calculator";

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
 Calculates the necessary six weeks grade or final grade needed to make a certain semester grade 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)needed6weeks:(id)sender {
    [self.navigationController pushViewController:[[CWNeeded6ViewController alloc]init] animated:YES];
}

-(IBAction)neededsemester:(id)sender{
    [self.navigationController pushViewController:[[CWNeededSemViewController
alloc]init] animated: YES];
}

@end
