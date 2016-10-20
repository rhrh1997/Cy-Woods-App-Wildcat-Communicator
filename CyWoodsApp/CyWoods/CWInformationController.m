//
//  CWInformationController.m
//  CyWoods
//
//  Created by RAZA on 1/13/15.
//
//

#import "CWInformationController.h"

@interface CWInformationController ()

@end

@implementation CWInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id) init{
    
    if( self ){
        UINavigationItem *item = self.navigationItem;
        item.title = @"Information";
        SWRevealViewController *revealController = [self revealViewController];
        self.navigationItem.hidesBackButton = YES;
        UIImage *buttonImage = [UIImage imageNamed:@"menubutton"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 45, 29);
        [button addTarget:revealController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 29)];
        [view addSubview:button];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = customBarItem; //this is making it where theres the menubutton on the navigation bar
        
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)websiteLink:(id)sender {
    [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:@"http://cywoods.cfisd.net"] animated:YES];
}
- (IBAction)athlethicsLink:(id)sender {
    [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:@"https://www.rankonesport.com/Schedules/View_Schedule_All.aspx?D=5e3c64f6-eabb-401d-8901-2da09a8500c8&S=1017"] animated:YES];
}
- (IBAction)eventsLink:(id)sender {
    [self.navigationController pushViewController:[[CWCalendarController alloc] init] animated:YES];
}
- (IBAction)phoneLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:2812131800"]];
    
}
- (IBAction)addressLink:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.apple.com/?q=http://maps.apple.com/?q=13550%20Woods%20Spillane%20Blvd%20Cypress,%20Texas%2077429"]];
    
}
- (IBAction)scheduleLink:(id)sender {
    if([self.SchoolSong.titleLabel.text  isEqual: @"Alma Mater"])
    {
            [self.SchoolSong setTitle:@"Fight Song" forState:UIControlStateNormal];
        self.SongTest.text = @"Wildcats Wildcats\nWe're coming out tonight \n Showing them all \n Our Might \n So get on the field \n We're not gonna yield \n C-Dub HS Yell \n Fight Fight Fight \n If you're wanting more, \n We'll bring up the score \n Wildcats will do it right \n No doubt about it \n We're gonna shout it \n Wildcats will win tonight, \n Power of the red and gold \n Wildcats, Wildcats \n Chew'Em, Eat'Em \n Stomp'Em, Beat'Em \n Go Cats, Go!";
    }
    else
    {
        [self.SchoolSong setTitle:@"Alma Mater" forState:UIControlStateNormal];
        self.SongTest.text = @"To Cypress Woods we pledge our hearts and minds\n Within her walls vast knowledge we will find\nAlong with friends and pride for all to see\nThat Wildcats forever we will be\nWe wear the crimson and we wear the gold\nOur future lives beginning to unfold\nFond memories to hold within our hearts\nOf Cypress Woods we'll always be a part";
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
