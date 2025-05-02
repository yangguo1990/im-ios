//
//  MLRecommendViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "ML_NearbyRecommendVC.h"
#import "ML_CommunityCell.h"
#import "ML_CommunityModel.h"
#import "YBIBVideoData.h"
#import "YBIBImageData.h"
#import "YBImageBrowser.h"
#import "ML_ToolViewHandler.h"
#import "ML_CommunityApi.h"
#import "TZLocationManager.h"
#import "UIViewController+CurrentShowVC.h"
#import "ML_XuanAlbumView.h"
#import "MJRefresh.h"
#import "YBIBVideoCell+Internal.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "ML_HostVideoViewController.h"
#import "SiLiaoBack-Swift.h"

@interface ML_NearbyRecommendVC ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property(nonatomic,strong)UIButton *dingBtn;

@property (nonatomic, strong) ML_CommunityModel *ML_Model;
@property (strong, nonatomic) NSString *ML_Type;
@property (assign, nonatomic) int ML_Page;
@property (strong, nonatomic) UITableView *ML_TableView;
@property (strong, nonatomic) NSMutableArray<ML_CommunityModel *> *ML_ListArr;
@property (nonatomic ,strong) CLLocationManager *LocationManager;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *Latitude;
@property (strong, nonatomic) YBImageBrowser *Browser;

@end

@implementation ML_NearbyRecommendVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.Browser) {
        
        for (UIView *view in self.Browser.collectionView.subviews) {
            
            if ([view isKindOfClass:[YBIBVideoCell class]]) {
                
                YBIBVideoCell *cell = (YBIBVideoCell *)view;
                [cell.videoView startPlay];
                
                break;
            }
        }
        
        [UIViewController topShowViewController].tabBarController.tabBar.hidden = YES;
    } else {
        
        [UIViewController topShowViewController].tabBarController.tabBar.hidden = NO;
    }
}

- (void)ML_howTabar{
    
    self.Browser = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (instancetype)initDataType:(ML_NearbyRecommendType)type
{
    self = [super init];
    if (self) {
        
        self.ML_Type = [NSString stringWithFormat:@"%ld", type];
        self.ML_ListArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - 112 - SSL_TabbarHeight) style:UITableViewStylePlain];
    //    tableView.frame = self.view.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.ML_TableView = tableView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ML_howTabar) name:@"ML_ShowTabar" object:nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lo = [defaults objectForKey:@"longstr"];
    
    kSelf;
//    if (lo || [self.ML_Type isEqualToString:@"0"]) {
        
        //#import "Rob_euCHNRefreshGifHeader.h"
        //#import "Rob_euCHNRefreshFooter.h"
        self.ML_TableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
        
            weakself.ML_Page ++;

            [weakself requestData];
        }];
        
        self.ML_TableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
            
            weakself.ML_Page = 1;
            
            [weakself requestData];
        }];
    if (lo || [self.ML_Type isEqualToString:@"0"]) {
        [self.ML_TableView.mj_header beginRefreshing];
        
    }
    
    if ([self.ML_Type isEqualToString:@"1"]) {
        
//        [self ML_StartLocation];
        
        [TZLocationManager.manager startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
            CLLocation *CurrentLocation = [locations lastObject];
    //        weakself.Longitude = [NSString stringWithFormat:@"%f", CurrentLocation.coordinate.longitude];
    //        weakself.Latitude = [NSString stringWithFormat:@"%f", CurrentLocation.coordinate.latitude];
            self.ML_TableView.mj_header.hidden = NO;
            self.dingBtn.hidden = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.longitude] forKey:@"longstr"];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.latitude] forKey:@"latstr"];
        //    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
        //    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
            [defaults synchronize];
            [self.ML_TableView.mj_header beginRefreshing];
            

        } failureBlock:^(NSError *error) {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *lo = [defaults objectForKey:@"longstr"];
            if (!lo) {
                [self.dingBtn removeFromSuperview];
                self.ML_TableView.mj_header.hidden = YES;
                UIButton *dingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
                dingBtn.backgroundColor = kZhuColor;
                dingBtn.layer.cornerRadius = 10;
                [dingBtn addTarget:self action:@selector(dingClick) forControlEvents:UIControlEventTouchUpInside];
                [dingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                dingBtn.center = CGPointMake(ML_ScreenWidth / 2, self.ML_TableView.height / 2 - 30);
                [dingBtn setTitle:@"重新定位" forState:UIControlStateNormal];
                [self.view addSubview:dingBtn];
                self.dingBtn = dingBtn;
            }
            
        }];
        

    }
}

- (void)dingClick
{
    [self opentNotificationAlertWithTitle:@"定位"];
}

#pragma mark - 定位处理
-(void)ML_StartLocation{

    if ([CLLocationManager locationServicesEnabled]) {
        self.LocationManager = [[CLLocationManager alloc]init];
        self.LocationManager.delegate = self;
        self.LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.LocationManager.distanceFilter = 10.0f;
        [self.LocationManager requestWhenInUseAuthorization];
        [self.LocationManager startUpdatingLocation];
    }
    else
    {
        //不能定位提示
        UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:Localized(@"允许\"定位\"提示",nil) message:Localized(@"请在设置中打开定位",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Enter = [UIAlertAction actionWithTitle:Localized(@"打开定位",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *SettingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:SettingsUrl];
        }];
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [AlertVC addAction:Enter];
        [AlertVC addAction:Cancel];
        [self presentViewController:AlertVC animated:YES completion:nil];
    }
}

#pragma mark---------定位失败-----------

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error{
    if([error code] ==kCLErrorDenied){

    } else if([error code] ==kCLErrorDenied){
        //访问被拒绝
        kplaceToast(@"位置访问被拒绝")
    } else if ([error code] == kCLErrorLocationUnknown) {

       kplaceToast(@"无法获取位置信息")
    } else {
        NSLog(@"定位error-----%@", error);
    }
    // Privacy - Location Always and When In Use Usage Description和Privacy - Location When In Use Usage Description

}

- (void)LocationUploadLongitude:(NSString *)Longitude latitude:(NSString *)Latitude {
//    [WorkplaceApppplaceNormalModel Model_POST:@"/api/user/update_position" paramtter:@{@"lat":Latitude,@"lon":Longitude} result:^(id  _Nonnull Model, NSString * _Nonnull Error) {
//
//    }];
}


- (void)requestData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
    
//    NSString *lo = self.longitude;
//    NSString *la = self.Latitude;
    
    kSelf;
    ML_CommunityApi *registerapi = [[ML_CommunityApi alloc] initWithType:self.ML_Type ID:@"" page:[NSString stringWithFormat:@"%d", self.ML_Page] limit:@"20" location:[NSString stringWithFormat:@"%@,%@", lo, la]];
    
    [registerapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
        NSArray *arr = response.data[@"dynamics"];
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.ML_ListArr removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            ML_CommunityModel *model = [ML_CommunityModel mj_objectWithKeyValues:dic];
            [weakself.ML_ListArr addObject:model];
            
            if (weakself.ML_ListArr.count > [response.data[@"total"] intValue]) {
                
                [weakself.ML_ListArr removeLastObject];
                
                break;
            }
        }
        if (arr.count) {
            [weakself.ML_TableView reloadData];
        } else {
            [weakself.ML_TableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.ML_TableView.mj_footer endRefreshing];
        [weakself.ML_TableView.mj_header endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    return self.ML_ListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ML_CommunityCell *cell = [ML_CommunityCell ML_cellWithTableView:tableView];
    ML_CommunityModel *model0 = self.ML_ListArr[indexPath.row];
    model0.index = indexPath.row;
    
    cell.ML_Model = model0;

    NSLog(@"indexPath----%@---%@", cell.ML_Model.username, model0.type);
    
    kSelf;
    cell.RefreshContenBlock = ^(ML_CommunityModel * _Nonnull model) {
        kSelf2;
        [UIView performWithoutAnimation:^{
            [weakself2.ML_ListArr replaceObjectAtIndex:model.index withObject:model];
            
            NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            
            NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
            
            [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };
    
    cell.ToastPictureVCBlock = ^(ML_CommunityModel *_Nonnull blockModel, UIView *collView, int type) {
        weakself.ML_Model = blockModel;
        
        [weakself clickCollView:collView pictureArr:blockModel.url type:[blockModel.type intValue]];
    
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ML_CommunityCell * cell = (ML_CommunityCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    
}

- (void)bigViewTapClick:(UIGestureRecognizer *)gr
{
    [gr.view removeFromSuperview];
}

- (void)clickCollView:(UIView *)collView pictureArr:(NSArray *)pictureArr type:(int)type
{
    
    if (self.tabBarController.tabBar.hidden) {return;}
    
    NSMutableArray *arr = [NSMutableArray array];
    
  
    for (NSString *urlStr0 in pictureArr) {
        
        NSString *urlStr = urlStr0;
        if (![urlStr containsString:@"http"]) {
            urlStr = [NSString stringWithFormat:@"%@/%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain, urlStr];
        }
        
        if (type == 1) {
            
            // 网络视频
            YBIBVideoData *Data = [YBIBVideoData new];
            Data.autoPlayCount = NSUIntegerMax;
            Data.allowSaveToPhotoAlbum = NO;
            NSURL *VideoUrl = [NSURL URLWithString:urlStr];
            Data.videoURL = VideoUrl;
            Data.repeatPlayCount = NSUIntegerMax;
            Data.autoPlayCount = NSUIntegerMax;
            Data.projectiveView = collView;
            
            [arr addObject:Data];
            
        } else {
            
            // 网络图片
            YBIBImageData *Data = [YBIBImageData new];
            Data.imageURL = [NSURL URLWithString:urlStr];
            Data.projectiveView = collView;
            Data.extraData = [NSURL URLWithString:urlStr];
            
            [arr addObject:Data];
        }
    }
        
    __block YBImageBrowser *Browser = [[YBImageBrowser alloc]initWithFrame:CGRectZero];
        Browser.dataSourceArray = arr;
        Browser.currentPage = collView.tag;
    
    self.Browser = Browser;

    __block ML_ToolViewHandler *tool = [ML_ToolViewHandler new];
    tool.Browser = Browser;
    tool.model = self.ML_Model;
    Browser.toolViewHandlers = @[tool];
    
//        if (type == 1) {
//            [Browser showToView:[UIViewController topShowViewController].view];
//        } else {
    kSelf;
            Browser.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                [Browser showToView:[UIViewController topShowViewController].view containerSize:CGSizeMake(ML_ScreenWidth, 460*mHeightScale)];
                
            } completion:^(BOOL finished) {
                weakself.tabBarController.tabBar.hidden = YES;
            }];
//        }
        
      
    
    
    
    
    tool.ML_ToolViewHandlerBtnBlock = ^(NSInteger tag) {
        
        switch (tag) {
            case 0:
            {
                
                [Browser hide];
                
                break;
            }
            case 1:
            {

                kSelf2;

                [weakself2 gotoInfoVC:weakself2.ML_Model.userId];
                
                break;
            }
            case 2:
            {
                
                for (UIView *view in self.Browser.collectionView.subviews) {
                    
                    if ([view isKindOfClass:[YBIBVideoCell class]]) {
                        
                        YBIBVideoCell *cell = (YBIBVideoCell *)view;
                        [cell.videoView playerPause];
                        
                        break;
                    }
                }
                
                
                [weakself gotoChatVC:weakself.ML_Model.userId];

                break;
            }
            case 3:
            {
                [self presentGiftByUserId:[weakself.ML_Model.userId intValue]];
//                [weakself.giftView showGiftView];
                break;
            }
            case 4:
            {
                
                [weakself gotoCallVCWithUserId:weakself.ML_Model.userId isCalled:NO];
            
                break;
            }
            case 5:
            {
                [weakself ML_GuanzhuWithUserId: weakself.ML_Model.userId btnView:tool.ML_GuanzhuBtn];

                
                break;
            }
            default:
                break;
        }
    };

}


//返回Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ML_CommunityCell * cell = (ML_CommunityCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.cellHeight;
}

#pragma mark - JXCategoryListContentViewDelegate
/**
 实现 <JXCategoryListContentViewDelegate> 协议方法，返回该视图控制器所拥有的「视图」
 */
- (UIView *)listView {
    return self.view;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ML_ShowTabar" object:nil];
}

@end
