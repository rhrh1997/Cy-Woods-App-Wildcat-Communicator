//
//  CWHomeController.m
//  CyWoods
//  Hassaan Raza/Drew Dennistoun
//
//

#import "CWHomeController.h"
#import "SWRevealViewController.h"
#import "CLTickerView.h"


//I can code sometimes.  I declare this app
//finished
@implementation CWHomeController
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    CLTickerView *ticker;
    BOOL hidden;
    NSString *tickermsg;
    NSArray *messages;
    NSMutableArray *images;
    NSMutableArray *spotlight;
    NSArray *links;
    SWRevealViewController *revealController;
    NSURL *currentURL;
    
}

- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle{
    self = [super initWithNibName:@"CWHomeController" bundle: [NSBundle mainBundle]];
    images = [[NSMutableArray array]init];
    [self parseUpdate];
    
    if( self ){
        
        self.navigationItem.title = @"Cypress Woods";
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:217/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f]];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                               fontWithName:@"Avenir" size:18], NSFontAttributeName,
                                    [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];

        [[UINavigationBar appearance] setTitleTextAttributes:attributes];

       
    }
    //This sets the colors of the navigation

    return self;
}

-(void)parseUpdate
{
    //This is pulling new ticker messages and spotlight items from our server
    PFQuery *query2 = [PFQuery queryWithClassName:@"Spotlight"];
    [query2 orderByDescending:@"updatedAt"];
    [query2 setLimit: 10];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded. The first 100 objects are available in objects, we don't need that many
             //NSLog(@"Successfully retrieved %lu spotlight objects.", (unsigned long)objects.count);
            spotlight = objects;
            NSMutableArray *discardeditems = [NSMutableArray array];
             // array with objects to be removed
            // NSInteger index = ... // index of object to move to the front
           //  id obj = array[index];
             
             if (![self isShowOnAir]) {
                for (PFObject *object in objects)
                 {
                     NSString *title = object[@"Title"];
                     if([title  isEqual: @"Wildcat Music Link"])
                     {
                         NSLog(@"Found music link");
                         [discardeditems addObject:object];
                         //whatever
                         //[spotlight removeObjectAtIndex:0];

                     }
                 }
                 [spotlight removeObjectsInArray:discardeditems];
               //  [spotlight removeObjectAtIndex:0];
             }
            //[spotlight insertObject:obj atIndex:0];
         }
         else
         {
             // Log details of the failure
           //  NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         [self spotlightUpdate];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self viewDidLoad];
         });
         
     }];
    PFQuery *query = [PFQuery queryWithClassName:@"Ticker"];
    [query orderByDescending:@"createdAt"];
    [query setLimit: 5];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         
         if (!error)
         {
             // The find succeeded. The first 100 objects are available in objects, we don't need that many
           //  NSLog(@"Successfully retrieved %lu ticker messages.", (unsigned long)objects.count);
             messages = objects;
         } else
         {
             // Log details of the failure
           //  NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         [self tickerUpdate];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self viewDidLoad];
         });
         
     }];
    
}

-(void)spotlightUpdate
{
    //This is inserting our spotlight items into spotlight
    for (PFObject *object in spotlight)
    {
       
        BOOL *video = [object[@"Video"] boolValue];

    if (video == YES) {
            //NSLog(@"is a video");
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
            NSString * youtubeID = object[@"Link"];
            NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeID]];
            [imageView setImageWithURL:youtubeURL placeholderImage:[UIImage imageNamed:@"2@2x.png"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [images addObject:imageView];
           // UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
           // dot.image=[UIImage imageNamed:@"2@2x.png"];
           // [images addObject:dot];

        }
        else
        {
            //NSLog(@"Not a video");
            PFImageView *imageView = [[PFImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
            imageView.image = [UIImage imageNamed:@"4@2x.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.file = (PFFile *)object[@"Picture"];
            [imageView loadInBackground];
            [images addObject:imageView];
            //NSLog(@"images count is %lu", (unsigned long)[images count]);

        }
    }
    [_carousel reloadData];
    [self viewDidLoad];

}

-(void)tickerUpdate
{
    //This is setting our scrolling ticker messages with updated items
    NSString *mess = @"";
    for (PFObject *object in messages)
    {
        NSString *msg = object[@"Message"];
        mess = [NSString stringWithFormat:@"%@ | %@", mess, msg];
      //  NSLog(@"tickermsg %@", msg);
    }
    if([mess  isEqual: @""])
    {
        NSLog(@"Blank message");
        tickermsg = @"Unable to connect to the Wildcat Network";
    }
    else
    {
       mess = [NSString stringWithFormat:@"%@ |", mess];
       tickermsg = mess;
    }
    
}

-(void)refresh{
    //This is calling on our second server to update our Newsfeed
    news = [[CWDataStore sharedInstance] news ];
    [table reloadData];
}



-(void)tickerToggle
{
    //A deprecated function, we do not use this anymore since we do not need to remove the ticker
    if(hidden == false)
    {
        //NSLog(@"toggled true");
        //hidden = true;
        //ticker.marqueeStr = @"hello";
        //self.navigationItem.titleView = nil;
        //[self refresh];
    }
    else
    {
        //NSLog(@"toggled false");
        hidden = false;
        self.navigationItem.titleView = ticker;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidLoad{
    
    table.separatorColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0];    //[UIColor clearColor];
    //Sets the table colors
    if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeTop;
    revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [[CWDataStore sharedInstance] addRefresh:self];
    [self refresh];
    //Setting up our side navigation menu
    UIImage *buttonImage = [UIImage imageNamed:@"menubutton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(-5, 0, 45, 29);
    [button addTarget:revealController action:@selector(revealToggle:)
     forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 29)];
    [view addSubview:button];
    //Our menu button has been added
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    //self.navigationItem.rightBarButtonItem = customBarItem;
    //UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton.png"]style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    //UIScrollView *scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -334, 408, 960)];
    //    scr.tag = 12;
    //    scr.autoresizingMask=UIViewAutoresizingNone;
    //    [self.view addSubview:scr];
    //    [self setupScrollView:scr];
    //    //scr.scrollEnabled = NO;
    //    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 480, 36)];
    //    [pgCtr setTag:12];
    //    pgCtr.numberOfPages=3;
    //    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    //    [self.view addSubview:pgCtr];
    
    
    //Our Spotlight Slideshow variables
    
    //images=[[NSMutableArray alloc]init];
    _carousel.type = iCarouselTypeCoverFlow;
    _carousel.bounceDistance = .8;
    //_carousel.autoscroll = .1;
    _carousel.pagingEnabled = YES;
    //_carousel.decelerationRate = 0.0f;
   //[_carousel scrollByNumberOfItems:10 duration:20];


    _carousel.clipsToBounds = true;
    _wrap = YES;
    [_carousel reloadData];

    
    // Stuff for the ticker view thing
    hidden = false;
    ticker = [[CLTickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 30 )];
    ticker._home = self;
    ticker.marqueeStr = tickermsg;
    //ticker.userInteractionEnabled = NO;
    ticker.marqueeFont = [UIFont fontWithName:@"Avenir" size:16];
    ticker.backgroundColor = [UIColor clearColor];
    
    if(![tickermsg  isEqual: @""])
    {
        self.navigationItem.titleView = ticker;
    }
   // NSLog(@"second trt %@", tickermsg);
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *obj = [news objectAtIndex:indexPath.row];
    if( [obj objectForKey:@"Link"] ){
        [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:[obj objectForKey:@"Link"]] animated:YES];
    }
    else if (indexPath.row != 0)
    {
        [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:@"http://cywoods.cfisd.net/en/news/school-news/"] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //This is what seperates news feed into containers
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0];
    //rgb(189, 195, 199)rgb(236, 240, 241)[UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0];
        NSDictionary *obj = [news objectAtIndex:indexPath.row];
        NSString *celldata =[obj objectForKey:@"Info"];
        celldata = [celldata substringToIndex: MIN(500, [celldata length])];
        CGSize textSize = [celldata sizeWithFont:[UIFont fontWithName:@"Avenir-Light" size:13] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
       // NSLog(@"%@",NSStringFromCGSize(textSize));
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,10,300, textSize.height+5)];
        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
        //[UIColor colorWithRed:217/255.0f green:1/255.0f blue:0/255.0f alpha:.8f];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 0.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.0;
        //.5
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
   // }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    celldata = [celldata substringToIndex: MIN(500, [celldata length])];
    if (indexPath.row != 0)
    {
    NSString *sample2 = @"...";
    celldata = [NSString stringWithFormat:@"%@%@", celldata,
                          sample2];
    }
    cell.textLabel.text = celldata;

    //if( [obj objectForKey:@"Link"])
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return news.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *celldata = [[news objectAtIndex:indexPath.row] objectForKey:@"Info"];
    celldata = [celldata substringToIndex: MIN(500, [celldata length])];
    CGSize textSize = [celldata sizeWithFont:[UIFont fontWithName:@"Avenir-Light" size:13] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    //CGSize textSize = [[[news objectAtIndex:indexPath.row] objectForKey:@"Info"] sizeWithFont:[UIFont systemFontOfSize: 15] constrainedToSize:CGSizeMake([tableView frame].size.width - 40.0, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return textSize.height+20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)setup{
    self.navigationController.navigationBar.tintColor =  [UIColor colorWithRed:255/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
}



//Slideshow



- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    NSLog(@"%lu",(unsigned long)[images count]);
    return [images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
       // [self spotlightUpdate];
        PFObject *object = [spotlight objectAtIndex:index];
        NSString *title = object[@"Title"];
        BOOL *video = [object[@"Video"] boolValue];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
       // ((UIImageView *)view).image = [UIImage imageNamed:@"1@2x.png"];
        [view addSubview:[images objectAtIndex:index]];

        view.contentMode = UIViewContentModeScaleAspectFill;
        if (video == YES)
        {
            UIImageView *play =[[UIImageView alloc] initWithFrame:CGRectMake(135, 75, 50, 50)];
            play.image=[UIImage imageNamed:@"play43.png"];
            play.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:play];
        }
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 320, 200)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentJustified;
        label.font = [UIFont fontWithName:@"Avenir" size:14];
        label.textColor = [UIColor whiteColor];
        NSString *uppercaseString = [title uppercaseString];
        label.text = uppercaseString;
        label.tag = 1;
        [view addSubview:label];
        }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = @"Uh oh! Unable to connect to the Wildcat Network";
    //[_items[index] stringValue];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.0;
    }
    if(option == iCarouselOptionWrap)
    {
        return _wrap;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    //NSLog(@"Image is selected.");
    PFObject *object = [spotlight objectAtIndex:index];
    NSString * youtubeID = object[@"Link"];
    NSString *title = object[@"Title"];
    BOOL *video = [object[@"Video"] boolValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",youtubeID]];
    if (video == YES) //If the spotlight has a video item
    {
    currentURL = url;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Proceed to YouTube?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alert show];
    }
    else if ([title  isEqual: @"Wildcat Music Link"])
    {
        
        currentURL = youtubeID; //not really youtubeID, actually the URL in the case that it is a picture link
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn Up"
                                                        message:@"Connect to Wildcat Music Link?"
                                                       delegate:self
                                              cancelButtonTitle:@"No!"
                                              otherButtonTitles:@"Connect Me!", nil];
        [alert show];
    }
    else if (![title isEqual:@""])
    {
        currentURL = youtubeID; //not really youtubeID, actually the URL in the case that it is a picture link
        if (![currentURL  isEqual: @""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Proceed to Webpage?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Proceed", nil];
        [alert show];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        [[UIApplication sharedApplication] openURL:currentURL];
    }
    if([title isEqualToString:@"Proceed"])
    {
         [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:currentURL] animated:YES];
    }
    if ([title isEqualToString:@"Connect Me!"]) {
        [self.navigationController pushViewController:[[CWWebViewController alloc] initWithRequest:currentURL] animated:YES];
    }
}

- (BOOL)isShowOnAir {
    BOOL onAir = YES;
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSTimeZoneCalendarUnit) fromDate:now];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSInteger hour = [components hour];
        if (hour > 9 && hour < 13) { // covers 8:00 - 9:59 PM
            onAir = YES;
        }
    return onAir;
}



@end
