//
//  MLFabuAddrListViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFabuAddrListViewController.h"
#import "ML_SearchBar.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_searchApi.h"
#import "MLFabuAddrListCellTableViewCell.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchResult.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <MJExtension/MJExtension.h>

@interface MLFabuAddrListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKGeneralDelegate,BMKSuggestionSearchDelegate,BMKPoiSearchDelegate>
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_searchArray;
@property (nonatomic,strong)NSMutableArray *ML_dataArray;

@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *keyword;

@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)UIView *ML_headVeiw;

//@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch * geocodeSearch;
//@property (nonatomic,strong)BMKLocationService *locationService;

@property (nonatomic,copy)NSString *address;
@property (nonatomic,strong)BMKPOINearbySearchOption *nearbyOption;
@property (nonatomic,copy)NSString *addressStr;
@property (nonatomic,strong)ML_SearchBar *search;



@end

@implementation MLFabuAddrListViewController

static NSString *ident = @"cell";

-(NSMutableArray *)ML_searchArray{
    if (_ML_searchArray == nil) {
        _ML_searchArray = [NSMutableArray array];
    }
    return _ML_searchArray;
}

-(NSMutableArray *)ML_dataArray{
    if (_ML_dataArray == nil) {
        _ML_dataArray = [NSMutableArray array];
    }
    return _ML_dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self ML_setupUI];
    self.address = @"";
    self.page = @"1";
    self.keyword = @"";
    self.addressStr = @"";
    //[self giveML_searchApi];
    //[self.locationService startUserLocationService];//启动定位服务
    
    [self setuploaction];
}

//位置------
-(void)setuploaction{
    
    [self.ML_dataArray removeAllObjects];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *latstr = [userDefault objectForKey:@"latstr"];
    NSString *longstr = [userDefault objectForKey:@"longstr"];
    
    //初始化BMKPoiSearch实例
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    //设置POI检索的代理
    poiSearch.delegate = self;
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc]init];
    /**
    检索关键字，必选。
    在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
    最多支持10个关键字。
    */

    if ([self.addressStr isEqualToString:@""]) {
        nearbyOption.keywords = @[@"地铁站",@"写字楼",@"商场",@"步行街",@"酒店",@"银行",@"政府",@"美食",@"公交站",@"娱乐"];
    }else{
        nearbyOption.keywords = @[self.addressStr];
    }
    //检索中心点的经纬度，必选
    //nearbyOption.location = CLLocationCoordinate2DMake(40.056974, 116.307689);
    nearbyOption.location = CLLocationCoordinate2DMake([latstr doubleValue],[longstr doubleValue]);

    /**
    检索半径，单位是米。
    当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
    */
    nearbyOption.radius = 1000;
    self.nearbyOption = nearbyOption;
    /**
    根据中心点、半径和检索词发起周边检索：异步方法，返回结果在BMKPoiSearchDelegate
    的onGetPoiResult里

    nearbyOption 周边搜索的搜索参数类
    成功返回YES，否则返回NO
    */
    BOOL flagt = [poiSearch poiSearchNearBy:nearbyOption];
    if(flagt) {
    NSLog(@"POI周边检索成功");
    } else {
    NSLog(@"POI周边检索失败");
    }
}






#pragma mark - BMKPoiSearchDelegate
/**
 POI检索返回结果回调

 @param searcher 检索对象
 @param poiResult POI检索结果列表
 @param error 错误码
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)error {
//BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
if (error == BMK_SEARCH_NO_ERROR) {
        //实现对检索结果的处理
    NSLog(@"poiInfoList--------%@",poiResult.poiInfoList);
    [poiResult.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo * model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"POI检索返回结果回调-----%@--%@--%@",model.name,model.area,model.address);
        [self.ML_dataArray addObject:model.mj_keyValues];
    }];
    }
    [self.ML_dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict setValue:@"0" forKey:@"isopen"];
    }];
    NSLog(@"%@",self.ML_dataArray);
    [self.tablview reloadData];
}

#pragma mark - 点击返回事件---------

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveClick{
    if ([self.address isEqualToString:@""]) {
        return;
    }else{
        self.returntextBlock(self.address);
    }
    [self.navigationController popViewControllerAnimated:YES];
}





-(void)ML_setupUI{
    self.ML_navView.hidden = YES;
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"我的位置", nil);
    titlelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(55);
    }];
    
    UIButton *navcancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navcancelbtn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
    [navcancelbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    navcancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [navcancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navcancelbtn];
    [navcancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
    }];
    
    UIButton *savecancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savecancelbtn setTitle:Localized(@"完成", nil) forState:UIControlStateNormal];
    [savecancelbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    savecancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [savecancelbtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savecancelbtn];
    [savecancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(titlelabel.mas_centerY);
    }];
    
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(22);
    }];
        
    ML_SearchBar *search = [[ML_SearchBar alloc]init];
    search.placeholder = @"搜索地点";
    //search.clearButtonMode = UITextFieldViewModeAlways;
    search.delegate = self;
    [self.view addSubview:search];
    self.search = search;
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(cancelbtn.mas_centerY);
        make.right.mas_equalTo(cancelbtn.mas_left).mas_offset(-16);
    }];

    UIImageView *searchImg = [[UIImageView alloc]init];
    searchImg.userInteractionEnabled = YES;
    searchImg.image = [UIImage imageNamed:@"icon_shanchu_18_ccc_nir"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [searchImg addGestureRecognizer:tap];
    [search addSubview:searchImg];
    [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(search.mas_right).mas_offset(-13);
        make.centerY.mas_equalTo(search.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];

    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.tableFooterView = [UIView new];
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(0);
    //make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(24);
       make.top.mas_equalTo(search.mas_bottom).mas_offset(16);
       make.bottom.mas_equalTo(self.view).mas_offset(0);
     }];
}

-(void)tapClick{
    self.addressStr = @"";
    self.search.text = @"";
    [self setuploaction];
    [self.tablview reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.addressStr = textField.text;
    [self setuploaction];
    [self.tablview reloadData];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{

}


#pragma mark -----tableView-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ML_dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MLFabuAddrListCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"bottomcell"];
              if(cell == nil) {
                  cell =[[MLFabuAddrListCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bottomcell"];
                  cell.backgroundColor = [UIColor whiteColor];
              }
            cell.dict = self.ML_dataArray[indexPath.row];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            if ([self.ML_dataArray[indexPath.row][@"isopen"] isEqualToString:@"1"]) {
                cell.isChecked = YES;
            }else{
                cell.isChecked = NO;
            }
            return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 63;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self.ML_dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            //[self.arraynumber replaceObjectAtIndex:idx withObject:@"1"];
            [dict setValue:@"1" forKey:@"isopen"];
            self.address = dict[@"name"];
          }else{
              //[self.arraynumber replaceObjectAtIndex:idx withObject:@"0"];
              [dict setValue:@"0" forKey:@"isopen"];
          }
      }];
       [tableView reloadData];
}




@end
