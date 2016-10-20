@interface CWLoadingView : UIView {
    UIView *trans;
    UIActivityIndicatorView *activity;
}
@property(nonatomic, strong) UILabel *label;
-(void)hide;
@end