//
//  ScrollmenuController.m
//  CyWoods

#import "ScrollmenuController.h"
#import "MPSkewedCell.h"
#import "MPSkewedParallaxLayout.h"
#import "CWAppDelegate.h"


static NSString *kCell=@"cell";


#define PARALLAX_ENABLED 1

@interface ScrollmenuController ()

@end

@implementation ScrollmenuController

- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle{

    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    choosed=-1;
    self.navigationController.navigationBarHidden=YES;
    
#ifndef PARALLAX_ENABLED
    // you can use that if you don't need parallax
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(self.view.width, 230);
    layout.minimumLineSpacing=-layout.itemSize.height/3; // must be always the itemSize/3
    //use the layout you want as soon as you recalculate the proper spacing if you made different sizes
#else
    
    MPSkewedParallaxLayout *layout=[[MPSkewedParallaxLayout alloc] init];
    
    
#endif
    
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor colorWithRed:205/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];

    //[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    //217    //whiteish
    //[UIColor colorWithRed:217/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
    [_collectionView registerClass:[MPSkewedCell class] forCellWithReuseIdentifier:kCell];
    [self.view addSubview:_collectionView];
    
}

- (void)setup{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return choosed>=0 ? 1 : 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MPSkewedCell* cell = (MPSkewedCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    cell.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li",(long) (choosed>=0 ? choosed : indexPath.item%5+1)]];
    
    NSString *text;
    
    NSInteger index=choosed>=0 ? choosed : indexPath.row%5;
    
    //athlethics,calendar,schedule
    
    switch (index) {
        case 0:
            text=@"HOME ";
            break;
        case 1:
            text=@"GRADES ";
            break;
        case 2:
            text=@"INFORMATION";
            break;
        case 3:
            text=@"SCHEDULE ";
            break;
        case 4:
            text=@"STAFF";
            break;
        default:
            break;
            
    }
    
    cell.text=text;
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CWAppDelegate* aDelegate = (CWAppDelegate *)[[UIApplication sharedApplication] delegate];
    SWRevealViewController *revealController = [self revealViewController];

    NSLog(@"item %li",(long)indexPath.item);
 
        NSLog(@"Redirecting");
        [revealController revealToggleAnimated:YES];
        [aDelegate selectedItem:indexPath.row];
    
//    NSInteger bk=choosed;
//    
//    if(choosed==-1)
//        choosed=indexPath.item;
//    else choosed=-1;
//    
//    NSMutableArray *arr=[[NSMutableArray alloc] init];
//    
//    for (NSInteger i=0; i<5; i++) {
//        if (i!=choosed && i!=bk) {
//            [arr addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//        }
//    }
//    
//    [collectionView performBatchUpdates:^{
//        if (choosed==-1) {
//            [collectionView insertItemsAtIndexPaths:arr];
//        }else [collectionView deleteItemsAtIndexPaths:arr];
//    }
//    completion:^(BOOL finished) {
//        
//    }];
    
    
}

@end
