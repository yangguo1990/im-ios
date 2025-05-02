#import "ML_BaseVC2.h"
#import "ML_CollectionViewFlowLayout.h"

@interface ML_BaseVC2 ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *kongView;
@end
@implementation ML_BaseVC2


//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    if (@available(iOS 13.0, *)) {
//        return UIStatusBarStyleLightContent;
//    } else {
//        return UIStatusBarStyleLightContent;
//    }
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//     return NO;
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//     [super viewDidAppear:animated];
//    if (self.navigationController.childViewControllers.count > 1) {
//        self.ML_backBtn.hidden = NO;
//         [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
//    }
//    else
//    {
//        self.ML_backBtn.hidden = YES;
//         [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
//    }
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
        
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//     self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight)];
    [self.view addSubview:bgImageView];
    bgImageView.hidden = YES;
    [self.view sendSubviewToBack:bgImageView];
    self.ML_bgImageView = bgImageView;
    
    
    [self ML_setUpCustomNavklb_la];
    
    
    if (self.navigationController.childViewControllers.count > 1) {
        bgImageView.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight);
        self.tabBarController.tabBar.hidden = YES;
        self.ML_backBtn.hidden = NO;
    }
}

- (void)ML_addEndTap
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTap)]];
}

- (void)handlePanGesture
{
    [self.view endEditing:YES];
}
- (void)endTap{
    [self.view endEditing:YES];
}
- (void)removeKongView
{
    [self.kongView removeFromSuperview];
}
- (void)addKongBGUI {
    
    UIView *kongView = [[UIView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight)];

    CGFloat imgVH= 80;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(70, (ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight) / 2 - imgVH, ML_ScreenWidth - 70 * 2, imgVH)];
    imgV.backgroundColor = [UIColor blackColor];
    [kongView addSubview:imgV];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(imgV.x, CGRectGetMaxY(imgV.frame) + 20, imgV.width, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [kongView addSubview:btn];
    self.kongView = kongView;
    [self.view addSubview:kongView];
}

- (void)HY_addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - SSL_TabbarHeight) style:UITableViewStylePlain];
    if (self.navigationController.childViewControllers.count > 1) {
        tableView.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight);
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.ML_TableView = tableView;
}

- (void)ML_addCollectionView
{
    ML_CollectionViewFlowLayout * layout = [[ML_CollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.sectionInset = UIEdgeInsetsMake(16, 26, 0, 16);
////    layout.minimumLineSpacing = 0;
//
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 20;
    
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor clearColor];
    collect.delegate=self;
    collect.dataSource=self;
    [self.view addSubview:collect];
    
    self.collectionView = collect;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)ML_setUpCustomNavklb_la
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_NavViewHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: navView];
    [self.view bringSubviewToFront: navView];
    self.ML_navView = navView;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight - 44, 50, 44)];
    [backBtn addTarget:self action:@selector(ML_backClickklb_la) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateNormal];
    [navView addSubview: backBtn];
    backBtn.hidden = YES;
    self.ML_backBtn = backBtn;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, backBtn.y, ML_ScreenWidth - 100, backBtn.height)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.tabBarItem.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview: titleLabel];
    [navView sendSubviewToBack: titleLabel];
    self.ML_titleLabel = titleLabel;
    UIButton *rightCustomButton = [[UIButton alloc] init];
    rightCustomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightCustomButton addTarget:self action:@selector(ML_rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    rightCustomButton.titleLabel.font = kGetFont(14);
    [rightCustomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightCustomButton.contentMode = UIViewContentModeRight;
    rightCustomButton.frame = CGRectMake(ML_ScreenWidth - 100, ML_NavViewHeight - 44, 80, 44);
    self.ML_rightBtn = rightCustomButton;
    [self.ML_navView addSubview:rightCustomButton];
}
- (void)ML_addNavRightBtnWithTitle:(NSString *)title image:(UIImage *)image
{
    [self.ML_rightBtn setImage:image forState:UIControlStateNormal];
    [self.ML_rightBtn setTitle:title forState:UIControlStateNormal];
}
- (void)ML_rightItemClicked
{
}
- (void)ML_backClickklb_la
{
    NSArray *xftc_ViewControllers = self.navigationController.viewControllers;
    if (xftc_ViewControllers.count > 1) {
        if ([xftc_ViewControllers objectAtIndex:xftc_ViewControllers.count-1] == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
