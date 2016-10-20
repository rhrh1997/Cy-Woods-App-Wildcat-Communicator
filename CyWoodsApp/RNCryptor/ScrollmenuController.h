//
//  ScrollmenuController.h
//  CyWoods
//


#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

@interface ScrollmenuController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    
    UICollectionView *_collectionView;
    
    NSInteger choosed;
}
-(void)setup;


@end
