//
//  MLCityViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLCityViewController.h"
#import "ML_CityTableViewCell.h"
#import <Masonry/Masonry.h>
#import "ML_getTypeHostsApi.h"
#import "ML_sayHelloApi.h"
#import "ML_HostdetailsViewController.h"
#import "UIViewController+MLHud.h"
#import "MJRefresh.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <SAMKeychain/SAMKeychain.h>
#import "IPToolManager.h"
#import "TZLocationManager.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface MLCityViewController ()<UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,assign)int ML_Page;
@property(nonatomic,strong)UIButton *dingBtn;
@property (nonatomic ,strong) CLLocationManager *LocationManager;
@end

@implementation MLCityViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self ML_StartLocation];
}

-(void)giveML_getTypeHostsApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"4" page:@(self.ML_Page) limit:@"20" location:[NSString stringWithFormat:@"%@,%@", lo, la] extra:[self jsonStringForDictionary]];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"hosts"];
        NSLog(@"%@",self.data);
        
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.data removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.data addObject:dic];
            
        }
        if (arr.count) {
            [weakself.tablview reloadData];
            [weakself.tablview.mj_footer endRefreshing];
            [weakself.tablview.mj_header endRefreshing];
        } else {
            [weakself.tablview.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.tablview.mj_footer endRefreshing];
        [weakself.tablview.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.tablview.mj_footer endRefreshing];
        [weakself.tablview.mj_header endRefreshing];
        
    }];
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
        
        kSelf;
    
        self.tablview.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
        
            weakself.ML_Page ++;

            [weakself giveML_getTypeHostsApi];
        }];
    
        self.tablview.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
            
            weakself.ML_Page = 1;
            [weakself giveML_getTypeHostsApi];
            
        }];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lo = [defaults objectForKey:@"longstr"];
    if (lo) {
        [self.tablview.mj_header beginRefreshing];
        
    }
    
        
        [TZLocationManager.manager startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
            self.tablview.mj_header.hidden = NO;
            self.dingBtn.hidden = YES;
            CLLocation *CurrentLocation = [locations lastObject];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.longitude] forKey:@"longstr"];
            [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.latitude] forKey:@"latstr"];
        //    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
        //    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
            [defaults synchronize];
            
            [self.tablview.mj_header beginRefreshing];
            
            
        } failureBlock:^(NSError *error) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *lo = [defaults objectForKey:@"longstr"];
            if (!lo) {
                [self.dingBtn removeFromSuperview];
                self.tablview.mj_header.hidden = YES;
                UIButton *dingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
                dingBtn.backgroundColor = kZhuColor;
                dingBtn.layer.cornerRadius = 10;
                [dingBtn addTarget:self action:@selector(dingClick) forControlEvents:UIControlEventTouchUpInside];
                [dingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                dingBtn.center = CGPointMake(ML_ScreenWidth / 2, self.tablview.height / 2 - 30);
                [dingBtn setTitle:@"重新定位" forState:UIControlStateNormal];
                [self.view addSubview:dingBtn];
                self.dingBtn = dingBtn;
            }
        }];
        
        
//    }
    
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
        
        [self opentNotificationAlertWithTitle:@"定位"];
        
    } else if ([error code] == kCLErrorLocationUnknown) {

       kplaceToast(@"无法获取位置信息")
    } else {
        NSLog(@"定位error-----%@", error);
    }
    // Privacy - Location Always and When In Use Usage Description和Privacy - Location When In Use Usage Description

}


-(void)setupUI{
    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.backgroundColor = UIColor.clearColor;
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __block ML_CityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
      if(cell == nil) {
          cell =[[ML_CityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
    cell.tag = indexPath.row;
    cell.dict = self.data[indexPath.row];

    kSelf;
    [cell setClickCellVideoBlock:^(NSInteger index) {
        [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]] isCalled:NO];
    }];
    
    [cell setClickcellCityButtonBlock:^(UIButton *btn) {
        
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:weakself.data[cell.tag]];
        [muDic setObject:@(1) forKey:@"call"];
        [weakself.data replaceObjectAtIndex:cell.tag withObject:muDic];
        cell.dict = muDic;
        
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}


-(void)giveapitoUserId:(NSString *)toUserId btn:(UIButton *)btn index:(NSInteger)index{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:toUserId extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        //[self showMessage:@"打招呼成功,可以给好友私信啦"];
       // [self giveML_getTypeHostsApi];
        if ([response.status integerValue] == 0) {
            [btn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
            [btn setTitle:@"" forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(28);
            }];
//           [self.statusArray insertObject:@"1" atIndex:index];
//            [self.tablview reloadData];
        }
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
    vc.dict = self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
