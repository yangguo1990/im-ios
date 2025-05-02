//
//  MLHomeViewController.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "MLHomeViewController.h"
#import "MLRecommendViewController.h"
#import "MLCityViewController.h"
#import "MLOnlineViewController.h"
#import "MLNewpersonViewController.h"
#import "MLHYViewController.h"
#import "ML_HomeCollectionViewCell.h"
#import "MLFocusViewController.h"
#import "MLSearchViewController.h"
#import "ML_dynamicViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "UIImage+ML.h"
#import "UIAlertView+NTESBlock.h"
#import "ML_UserModel.h"
#import "TZLocationManager.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import <SharetraceSDK/SharetraceSDK.h>
#import "NSString+ML_MineVersion.h"
#import "MLNewestVersionShowView.h"
#import "UIViewController+MLHud.h"
#import "MLHomeOneZhaohuView.h"
#import "MLHomeOnlineBottomView.h"
#import "ML_GetUserInfoApi.h"
#import "MLHomeOnlineViewController.h"
#import "WKWebViewController.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "ML_NTableViewCell.h"
#import "MLRecommendViewController.h"
#import <Masonry/Masonry.h>
#import "ML_HotCollectionViewCell.h"
#import "ML_headCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Colours/Colours.h>
#import "ML_ForyouViewController.h"

#import "ML_GetUserInfoApi.h"
#import "ML_bannerApi.h"
#import "ML_ForyouApi.h"
#import "ML_getTypeHostsApi.h"
#import "ML_getRandomHostsOneApi.h"
#import "MJRefresh.h"
#import "ML_HostdetailsViewController.h"
#import "ML_HostVideoViewController.h"
#import "MLNewestVersionShowView.h"
#import "ML_NewestVersionApi.h"
#import "NSString+ML_MineVersion.h"
#import "UIViewController+MLHud.h"
#import "MLHomeOnlineViewController.h"
#import "MLHomeOnlineBottomView.h"
#import "MLHomeOneZhaohuView.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "MLZhaohuListApi.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "ML_dashanView.h"
#import "SiLiaoBack-Swift.h"
#import "MLDynameSHowTableViewCell.h"
#import "ML_getUserOperationsApi.h"
#import "MLZhidingZhaohuApi.h"
#import "ML_BangdanVC.h"
@interface MLHomeViewController ()<JXCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>/*,BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate*/
@property (nonatomic,strong)NSArray *titlearray;
@property (nonatomic,strong)UIButton *laNameV;
@property (nonatomic,strong)UILabel *recommendExpireLabel;
@property (nonatomic, strong) NSTimer *countDownTimer; // 计时器
@property (nonatomic, assign) int seconds; // 倒计时总时长
@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)MLNewestVersionShowView *versionShowView;
@property (nonatomic,strong)UIView *NmaskView;
//@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic,strong)MLHomeOneZhaohuView *oneZhaohuView;
//@property(nonatomic,strong)UITableView *homeTableView;
@property(nonatomic,strong)UIView *tableHeadView;
@property(nonatomic,strong)NSMutableArray *tableViewData;
@property(nonatomic,strong)UIView *sectionView;
@property(nonatomic,strong)NSMutableArray *yanchiArray;
@property(nonatomic,strong)NSMutableArray *duocaiArray;
@property(nonatomic,strong)NSMutableArray *duoyiArray;
@property(nonatomic,strong)NSMutableArray *bannersArray;
@property(nonatomic,strong)NSMutableArray *homeArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSMutableArray *onlineArray;
@property(nonatomic,strong)NSMutableArray *NuserArray;
@property(nonatomic,strong)NSMutableArray *guanzhuArray;
@property(nonatomic,assign)NSInteger yanzhiPage;
@property(nonatomic,assign)NSInteger duocaiPage;
@property(nonatomic,assign)NSInteger duoyiPage;
@property(nonatomic,assign)NSInteger recommendpage;
@property(nonatomic,assign)NSInteger citypage;
@property(nonatomic,assign)NSInteger onlinepage;
@property(nonatomic,assign)NSInteger nuserpage;
@property(nonatomic,assign)NSInteger guanzhupage;
@property (nonatomic ,strong) CLLocationManager *LocationManager;
@property(nonatomic,strong)UIButton *dingBt;
@property(nonatomic,strong)UIView *nodataView;
@property (nonatomic,strong)UIButton *button_recommended_40;
@property (nonatomic,strong)NSArray *callContents;
@property (nonatomic,strong)NSDictionary *foryouDic;
@property(nonatomic,strong)UIButton *LingBtn1;
@property(nonatomic,strong)SDCycleScrollView *ML_webCycleScrollView;
/**新版collectionview*/
@property(nonatomic,strong)UICollectionView *homeCollectionView;



/**动态vc属性*/
@property (nonatomic,strong)UIImageView *bgview;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,assign)NSInteger dongtaiPage;
@property(nonatomic,strong)NSMutableArray *dongtaiArray;
@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIImageView *bglistimg;
@property (nonatomic,assign)BOOL isDashan;
@property (nonatomic,strong)NSMutableArray *zhaohudata;
@property(nonatomic,assign)NSInteger haiPage;
@property (nonatomic,strong)NSMutableArray *haiarray;
@property (nonatomic,assign)BOOL ishost;

@end

@implementation MLHomeViewController

- (UIView *)nodataView{
    if(!_nodataView){
        _nodataView=[[UIView alloc]initWithFrame:CGRectMake(0, 290*mHeightScale, ML_ScreenWidth, 380*mHeightScale)];
        UIImageView *nodataIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180*mWidthScale, 180*mWidthScale)];
        nodataIV.image=kGetImage(@"nodata");
        [_nodataView addSubview:nodataIV];
        [nodataIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_nodataView.mas_centerX);
            make.centerY.mas_equalTo(_nodataView.mas_centerY);
            make.width.mas_equalTo(180*mWidthScale);
            make.height.mas_equalTo(180*mHeightScale);
        }];
    }
    return _nodataView;
}
- (NSMutableArray *)haiarray{
    if (_haiarray == nil) {
        _haiarray = [NSMutableArray array];
    }
    return _haiarray;
}

-(NSMutableArray *)zhaohudata{
    if (_zhaohudata == nil) {
        _zhaohudata = [NSMutableArray array];
    }
    return _zhaohudata;
}

- (NSMutableArray *)dongtaiArray{
    if (!_dongtaiArray) {
        _dongtaiArray=[NSMutableArray array];
    }
    return _dongtaiArray;
}

- (NSMutableArray *)yanchiArray{
    if (!_yanchiArray) {
        _yanchiArray=[NSMutableArray array];
    }
    return _yanchiArray;
}

- (NSMutableArray *)duocaiArray{
    if (!_duocaiArray) {
        _duocaiArray=[NSMutableArray array];
    }
    return _duocaiArray;
}

- (NSMutableArray *)duoyiArray{
    if (!_duoyiArray) {
        _duoyiArray=[NSMutableArray array];
    }
    return _duoyiArray;
}


-(NSMutableArray *)homeArray{
    if(!_homeArray){
        _homeArray=[NSMutableArray array];
    }
    return _homeArray;
}

-(NSMutableArray *)cityArray{
    if(!_cityArray){
        _cityArray=[NSMutableArray array];
    }
    return _cityArray;
}

-(NSMutableArray *)onlineArray{
    if(!_onlineArray){
        _onlineArray=[NSMutableArray array];
    }
    return _onlineArray;
}
- (NSMutableArray *)NuserArray{
    if(!_NuserArray){
        _NuserArray=[NSMutableArray array];
    }
    return _NuserArray;
}
-(NSMutableArray *)guanzhuArray{
    if(!_guanzhuArray){
        _guanzhuArray =[NSMutableArray array];
    }
    return _guanzhuArray;
}



-(NSMutableArray *)bannersArray{
    if(!_bannersArray){
        _bannersArray=[NSMutableArray array];
    }
    return _bannersArray;
}

- (UIView *)sectionView{
    if(!_sectionView){
        _sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 60)];
        _sectionView.layer.masksToBounds = YES;
        JXCategoryTitleView *menuView=[[JXCategoryTitleView alloc]init];
       //判断用户身份
        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
            menuView.titles = @[Localized(@"推荐", nil),Localized(@"颜值", nil),Localized(@"同城", nil), Localized(@"在线", nil),Localized(@"新人", nil),Localized(@"动态",  nil)];
        }else{
            menuView.titles = @[Localized(@"推荐", nil),Localized(@"颜值", nil),Localized(@"同城", nil), Localized(@"在线", nil),Localized(@"新人", nil)];
        }
        menuView.titleColor = [UIColor colorFromHexString:@"#333333"];
    //    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        menuView.titleFont = [UIFont systemFontOfSize:16];
        menuView.cellSpacing = 24*mWidthScale;
        menuView.titleLabelZoomEnabled = YES;
        menuView.titleLabelStrokeWidthEnabled = YES;
        menuView.titleLabelSelectedStrokeWidth = -4;
        menuView.titleSelectedColor = [UIColor colorFromHexString:@"#ffffff"];
        menuView.titleColorGradientEnabled = NO;
        menuView.titleLabelZoomScale = 1.125;
        menuView.titleLabelVerticalOffset = 0;
        
        JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
        lineView.indicatorImageView.image = kGetImage(@"home_icon_tags");

        lineView.indicatorWidth = 20*mWidthScale;
        lineView.indicatorHeight = 30*mHeightScale;
        menuView.indicators = @[lineView];
        lineView.indicatorImageView.frame = CGRectMake(-15*mWidthScale, -25*mHeightScale, 60*mWidthScale, 30*mHeightScale);
   
        menuView.delegate= self;
        [_sectionView addSubview:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(60*mHeightScale);
        }];
        
        /**动态**/
        UIImageView *bgview = [[UIImageView alloc]init];
        bgview.image = [UIImage imageNamed:@"zhaohubghead"];
        bgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downClick)];
        [bgview addGestureRecognizer:tap];
        [_sectionView addSubview:bgview];
        self.bgview = bgview;
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sectionView.mas_left).mas_offset(8);
            make.right.mas_equalTo(_sectionView.mas_right).mas_offset(-8);
            make.top.mas_equalTo(menuView.mas_bottom);
            make.height.mas_equalTo(48*mHeightScale);
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = Localized(@"招呼语:", nil);
        numberLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        numberLabel.textColor = UIColor.blackColor;
        [bgview addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgview.mas_left).mas_offset(24);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(56);
        }];
        
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"Sliceirow40down"];
        [bgview addSubview:img];
        self.img = img;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgview.mas_right).mas_offset(-13);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"哈喽，小哥哥交个朋友呀!";
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [bgview addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberLabel.mas_right).mas_offset(4);
            make.right.mas_equalTo(img.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(bgview.mas_centerY);
        }];
    }
    return _sectionView;
}


- (UICollectionView *)homeCollectionView{
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(164*mWidthScale, 240*mHeightScale);
        layout.minimumLineSpacing = 20*mWidthScale;
        layout.minimumInteritemSpacing = 10*mWidthScale;
        layout.sectionInset = UIEdgeInsetsMake(20*mHeightScale, 16*mWidthScale, 20*mHeightScale, 16*mWidthScale);
        _homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 196*mHeightScale, ML_ScreenWidth, ML_ScreenHeight - 216*mHeightScale) collectionViewLayout:layout];
        _homeCollectionView.delegate = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.backgroundColor = UIColor.whiteColor;
        _homeCollectionView.layer.cornerRadius = 24*mWidthScale;
        _homeCollectionView.layer.masksToBounds = YES;
        [_homeCollectionView registerClass:[ML_HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCell"];
    }
    return _homeCollectionView;
}



- (UIView *)tableHeadView{
    if(!_tableHeadView){
        _tableHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth,159*mHeightScale)];
        /**轮播图**/
        [_tableHeadView addSubview:self.ML_webCycleScrollView];
        [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_tableHeadView.mas_centerX);
            make.centerY.mas_equalTo(_tableHeadView.mas_centerY);
            make.width.mas_equalTo(343*mWidthScale);
            make.height.mas_equalTo(140*mHeightScale);
        }];
    }
    return _tableHeadView;
}

- (void)addSearchBt{
    UIImageView *headBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 249*mHeightScale)];
    headBG.image=kGetImage(@"headBG");
    [self.view addSubview:headBG];
    
    
/**顶部菜单条**/
    JXCategoryTitleView *menuView=[[JXCategoryTitleView alloc]init];
   //判断用户身份
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
        menuView.titles = @[Localized(@"推荐", nil),Localized(@"颜值", nil),Localized(@"同城", nil), Localized(@"在线", nil),Localized(@"新人", nil),Localized(@"动态",  nil)];
    }else{
        menuView.titles = @[Localized(@"推荐", nil),Localized(@"颜值", nil), Localized(@"同城", nil), Localized(@"在线", nil),Localized(@"新人", nil)];
    }
    menuView.titleColor = [UIColor colorFromHexString:@"#666666"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    menuView.titleFont = [UIFont systemFontOfSize:16];
    menuView.cellSpacing = 24*mWidthScale;
    menuView.titleLabelZoomEnabled = YES;
    menuView.titleLabelStrokeWidthEnabled = YES;
    menuView.titleLabelSelectedStrokeWidth = -4;
    menuView.titleSelectedColor = [UIColor colorFromHexString:@"#000000"];
    menuView.titleColorGradientEnabled = NO;
    menuView.titleLabelZoomScale = 1.125;
    menuView.titleLabelVerticalOffset = 0;
    
    JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
    lineView.indicatorImageView.image = kGetImage(@"home_icon_tags");
//    lineView.indicatorColor = kZhuColor;
//    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 26*mWidthScale;
    lineView.indicatorHeight = 8*mHeightScale;
    menuView.indicators = @[lineView];
    lineView.indicatorImageView.frame = CGRectMake(0, 0, 30*mWidthScale, 8*mHeightScale);
//    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
//    lineView.verticalMargin = 12;
    menuView.delegate= self;
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(52*mHeightScale);
        make.height.mas_equalTo(28*mHeightScale);
        make.width.mas_equalTo(280*mWidthScale);
    }];
    
    UIButton *bangBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bangBt];
    [bangBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24*mWidthScale);
        make.centerY.mas_equalTo(menuView.mas_centerY);
        make.right.mas_equalTo(-16*mWidthScale);
    }];
    [bangBt addTarget:self action:@selector(gotoBangDan) forControlEvents:UIControlEventTouchUpInside];
    [bangBt setBackgroundImage:kGetImage(@"icon_list_22_sel") forState:UIControlStateNormal];
    
    UIButton *searchBt=[[UIButton alloc]initWithFrame:CGRectZero];
    [searchBt addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchBt setBackgroundImage:kGetImage(@"homeSearch") forState:UIControlStateNormal];
    [self.view addSubview:searchBt];
    [searchBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24*mWidthScale);
        make.centerY.mas_equalTo(menuView.mas_centerY);
        make.right.mas_equalTo(bangBt.mas_left).offset(-10);
    }];

    [self.view addSubview:self.ML_webCycleScrollView];
    [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(80*mHeightScale);
        make.top.mas_equalTo(100*mHeightScale);
    }];
    
}

- (void)gotoBangDan{
    ML_BangdanVC *bangVC = [[ML_BangdanVC alloc]init];
    [self.navigationController pushViewController:bangVC animated:YES];
}
/**UICollectionViewDelegate datasource**/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch(self.index){
        case 0:
            return self.homeArray.count;
        case 1://颜值
            return self.yanchiArray.count;
//        case 2://多才
//            return self.duocaiArray.count;
//        case 3://多艺
            return self.duoyiArray.count;
        case 2://同城
            return self.cityArray.count;
        case 3://在线
            return self.onlineArray.count;
        case 4://新人
            return self.NuserArray.count;
//        case 7://关注
//            return self.guanzhuArray.count;
        case 5://动态
        {
//            if([tableView isEqual:self.ML_showTableview]){
//                return self.zhaohudata.count;
//            }else{
                if(self.ishost){
                    return self.dongtaiArray.count;
                }else{
                    return self.haiarray.count;
                }
                
//            }
        }
        default:
            return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 2) {
        return  CGSizeMake(164*mWidthScale, 240*mHeightScale);
    }else{
        return  CGSizeMake(164*mWidthScale, 200*mHeightScale);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ML_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    switch(self.index){
        case 0://推荐
        {
            cell.dic=self.homeArray[indexPath.row];
        }break;
        case 1:{//颜值
            cell.dic=self.yanchiArray[indexPath.row];
        }break;
//        case 2:{//多才
//            cell.dic=self.duocaiArray[indexPath.row];
//        }break;
//        case 3:{//多艺
//            cell.dic=self.duoyiArray[indexPath.row];
//        }break;
        case 2://同城
        {
            cell.dic=self.cityArray[indexPath.row];
        }break;
        case 3://在线
        {
            cell.dic=self.onlineArray[indexPath.row];
        }break;
        case 4://新人
        {
            cell.dic=self.NuserArray[indexPath.row];
        }break;
//        case 7://关注
//        {
//            cell.dic=self.guanzhuArray[indexPath.row];
//        
//        }break;
        case 5://动态 海
        {
            if(self.ishost){
                cell.dic=self.dongtaiArray[indexPath.row];
            }else{
                cell.dic=self.haiarray[indexPath.row];
            }
            
        }break;
    }
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *currentArray;
    switch(self.index){
        case 0://推荐
        {
            currentArray=self.homeArray;
        }break;
        case 1://颜值
        {
            currentArray=self.yanchiArray;
        }break;
//        case 2://多才
//        {
//            currentArray=self.duocaiArray;
//        }break;
//        case 3://多艺
//        {
//            currentArray=self.duoyiArray;
//        }break;
        
        case 2://同城
        {
            currentArray=self.cityArray;
        }break;
        case 3://在线
        {
            currentArray=self.onlineArray;
        }break;
        case 4://新人
        {
            currentArray=self.NuserArray;
        }break;
//        case 7://关注
//        {
//            currentArray=self.guanzhuArray;
//        }break;
        case 5://动态
        {
            if(self.ishost){
                currentArray=self.dongtaiArray;
            }else{
                currentArray=self.haiarray;
            }
           
        }break;
    }
    
    if ([currentArray[indexPath.item][@"coverType"] integerValue] == 0) {
        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
        vc.dict = currentArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
        vc.dict = currentArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    switch(self.index){
//        case 0:
//            return self.homeArray.count;
//        case 1:
//            return self.yanchiArray.count;
//        case 2://多才
//            return self.duocaiArray.count;
//        case 3://多艺
//            return self.duoyiArray.count;
//        case 4://同城
//            return self.cityArray.count;
//        case 5://在线
//            return self.onlineArray.count;
//        case 6://新任
//            return self.NuserArray.count;
//        case 7://关注
//            return self.guanzhuArray.count;
//        case 8://多才
//        {
//            if([tableView isEqual:self.ML_showTableview]){
//                return self.zhaohudata.count;
//            }else{
//                if(self.ishost){
//                    return self.dongtaiArray.count;
//                }else{
//                    return self.haiarray.count;
//                }
//                
//            }
//        }
//        default:
//            return 0;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.index == 8){
//        if ([tableView isEqual:self.ML_showTableview]) {
//            MLDynameSHowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
//              if(cell == nil) {
//                  cell =[[MLDynameSHowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"showcell"];
//                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
//              }
//            cell.nameLabel.text = self.zhaohudata[indexPath.row][@"content"];
//            return cell;
//            
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//   ML_NTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"NCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////    cell.backgroundColor=[UIColor clearColor];
//    cell.isguanzhu = NO;
//    
//    
//    return  cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([tableView isEqual:self.ML_showTableview]) {
//        return 54;
//    }else{
//        return 102*mHeightScale;
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if([tableView isEqual:self.ML_showTableview]){
//        return nil;
//    }else{
//        return self.sectionView;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(self.index == 8){
//        if([tableView isEqual:self.ML_showTableview]){
//            return 0.1;
//        }else{
//            if(self.ishost){
//                return 108*mHeightScale;
//            }else{
//                return 60*mHeightScale;
//            }
//        }
//    }else{
//        return 60*mHeightScale;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *currentArray;
//    switch(self.index){
//        case 0://推荐
//        {
//            currentArray=self.homeArray;
//        }break;
//        case 1://颜值
//        {
//            currentArray=self.yanchiArray;
//        }break;
//        case 2://多才
//        {
//            currentArray=self.duocaiArray;
//        }break;
//        case 3://多艺
//        {
//            currentArray=self.duoyiArray;
//        }break;
//        
//        case 4://同城
//        {
//            currentArray=self.cityArray;
//        }break;
//        case 5://在线
//        {
//            currentArray=self.onlineArray;
//        }break;
//        case 6://新人
//        {
//            currentArray=self.NuserArray;
//        }break;
//        case 7://关注
//        {
//            currentArray=self.guanzhuArray;
//        }break;
//        case 8://动态
//        {
//            if(self.ishost){
//                currentArray=self.dongtaiArray;
//            }else{
//                currentArray=self.haiarray;
//            }
//           
//        }break;
//    }
//    
//    if(self.index == 8){
//        if ([tableView isEqual:self.ML_showTableview]) {
//            self.img.image = [UIImage imageNamed:@"Sliceirow40down"];
//            MLDynameSHowTableViewCell * cell = (MLDynameSHowTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//            self.titleLabel.text = cell.nameLabel.text;
//            [self giveZHaohutop:[NSString stringWithFormat:@"%@",self.zhaohudata[indexPath.row][@"id"]]];
//            [self.ML_showTableview removeFromSuperview];
//            [self.bglistimg removeFromSuperview];
//            self.isDashan = NO;
//            return;
//        }
//       
//    }
//    
//    
//    
//    if ([currentArray[indexPath.item][@"coverType"] integerValue] == 0) {
//        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
//        vc.dict = currentArray[indexPath.row];
//       
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
//        vc.dict = currentArray[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

#pragma mark 轮播
- (SDCycleScrollView *)ML_webCycleScrollView{
    if (!_ML_webCycleScrollView){
        _ML_webCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"bannerZhan"]];
        _ML_webCycleScrollView.layer.cornerRadius = 12;
        _ML_webCycleScrollView.layer.masksToBounds = YES;
//        _ML_webCycleScrollView.delegate = self;
        // 分页控件的位置
        _ML_webCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _ML_webCycleScrollView;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.ML_navView.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.ishost = [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"];
    self.isDashan = NO;
    [self nodataView];
    [self homeArray];
    [self yanchiArray];
    [self duocaiArray];
    [self duoyiArray];
    [self cityArray];
    [self onlineArray];
    [self NuserArray];
    [self guanzhuArray];
    [self dongtaiArray];
    [self zhaohudata];
    [self haiarray];
//    [self ML_StartLocation];
//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
//    else{
//        self.automaticallyAdjustsScrollViewInsets = false;
//    }
    self.ML_navView.hidden = YES;
    [self addSearchBt];
    [self.view addSubview:self.homeCollectionView];
    //刷新，加载
    kSelf;
    self.homeCollectionView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        switch(self.index){
            case 0://推荐
            {
                weakself.recommendpage=1;
        //        [weakself giveML_ForyouApi];
                [weakself giveML_getTypeHostsApiWithType:@"0"];
            }break;
            case 1://颜值
            {
                weakself.yanzhiPage=1;
        //        [weakself giveML_ForyouApi];
                [weakself giveML_getTypeHostsApiWithType:@"8"];
            }break;
//            case 2://多才
//            {
//                weakself.duocaiPage=1;
//        //        [weakself giveML_ForyouApi];
//                [weakself giveML_getTypeHostsApiWithType:@"9"];
//            }break;
//            case 3://多艺
//            {
//                weakself.duoyiPage=1;
//        //        [weakself giveML_ForyouApi];
//                [weakself giveML_getTypeHostsApiWithType:@"10"];
//            }break;
//            

            case 2://同城
            {
                weakself.citypage=1;
        //        [weakself giveML_ForyouApi];
                [weakself startLocation];
//                [weakself giveML_getCityHostsApi];
            }break;
            case 3://在线
            {
                weakself.onlinepage=1;
                [weakself giveML_showOnlineApi];
            }break;
            case 4://新人
            {
                weakself.nuserpage=1;
                [weakself giveML_newpersonApi];
            }break;
//            case 7://关注
//            {
//                weakself.guanzhupage=1;
//                [weakself giveML_focusApi];
//            }break;
            case 5://动态
            {
                if(self.ishost){//动态
                    weakself.dongtaiPage=1;
                    [weakself giveML_getTypeHostsApi];
                    [weakself giveMLZhaohuListApi];
                }else{//海
                    weakself.haiPage=1;
                    [weakself giveML_getTypeHostsApiWithType:@"7"];
                }
               
            }break;
            
        }
//        [self.homeTableView reloadData];
    }];
//    [self.homeTableView.mj_header beginRefreshing];
    weakself.recommendpage=1;
//        [weakself giveML_ForyouApi];
    [weakself giveML_getTypeHostsApiWithType:@"0"];
    [weakself giveML_ForyouApi];
    
    self.homeCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
        switch(self.index){
            case 0://推荐
            {
                weakself.recommendpage++;
                
                [weakself giveML_getTypeHostsApiWithType:@"0"];
            }break;
            case 1://颜值
            {
                weakself.yanzhiPage++;
        //        [weakself giveML_ForyouApi];
                [weakself giveML_getTypeHostsApiWithType:@"8"];
            }break;
//            case 2://多才
//            {
//                weakself.duocaiPage++;
//        //        [weakself giveML_ForyouApi];
//                [weakself giveML_getTypeHostsApiWithType:@"9"];
//            }break;
//            case 3://多艺
//            {
//                weakself.duoyiPage++;
//        //        [weakself giveML_ForyouApi];
//                [weakself giveML_getTypeHostsApiWithType:@"10"];
//            }break;
            
            case 2://同城
            {
                weakself.citypage++;
        //        [weakself giveML_ForyouApi];
//                [weakself ML_StartLocation];
                [weakself giveML_getCityHostsApi];
            }break;
            case 3://在线
            {
                weakself.onlinepage++;
                [weakself giveML_showOnlineApi];
            }break;
            case 4://新人
            {
                weakself.nuserpage++;
                [weakself giveML_newpersonApi];
            }break;
//            case 7://关注
//            {
//                weakself.guanzhupage++;
//                [weakself giveML_focusApi];
//                
//            }break;
            case 5://动态
            {
                if(self.ishost){//动态
                    weakself.dongtaiPage++;
                    [weakself giveML_getTypeHostsApi];
                }else{//海
                    weakself.haiPage++;
            //        [weakself giveML_ForyouApi];
                    [weakself giveML_getTypeHostsApiWithType:@"7"];
                }
                
                
            }break;
            
        }
        
    }];
    
    [self versionApi];
    [self addZhuboView];
    [self giveML_bannerApi]; //获取顶部轮播图
}

// 点击图片代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    // 清理缓存
    [SDCycleScrollView clearImagesCache];
}

// 滚动到第几张图片的回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
   
}

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    self.index = index;
    [self.nodataView removeFromSuperview];
    switch(index){
        case 0://推荐
            
            break;
        case 1://颜值
        {
            if (!self.yanchiArray.count) {
                self.yanzhiPage=1;
                [self giveML_getTypeHostsApiWithType:@"8"];
            }
        }break;
//        case 2://多才
//        {
//            if (!self.duocaiArray.count) {
//                self.duocaiPage=1;
//                [self giveML_getTypeHostsApiWithType:@"9"];
//            }
//        }break;
//        case 3://多艺
//        {
//            if (!self.duoyiArray.count) {
//                self.duoyiPage=1;
//                [self giveML_getTypeHostsApiWithType:@"10"];
//            }
//        }break;
        case 2://同城
        {
            if(!self.cityArray.count){
                self.citypage=1;
                [self startLocation];
//                self.citypage = 1;
//                [self giveML_getCityHostsApi];
            }
        }
            break;
        case 3://在线
        {
            if(!self.onlineArray.count){
                self.onlinepage=1;
                [self giveML_showOnlineApi];
            }
        }
            break;
        case 4://新人
        {
            if(!self.NuserArray.count){
                self.nuserpage=1;
                [self giveML_newpersonApi];
            }
        }
            break;
//        case 7://关注
//        {
//            if(!self.guanzhuArray.count){
//                self.guanzhupage=1;
//                [self giveML_focusApi];
//            }
//        }
//            break;
        case 5://动态
        {
            if(self.ishost){
                if(!self.dongtaiArray.count){
                    self.dongtaiPage=1;
                    [self giveML_getTypeHostsApi];
                    [self giveMLZhaohuListApi];
                }
            }else{
                if(!self.haiarray.count){
                    self.haiPage=1;
                    [self giveML_getTypeHostsApiWithType:@"7"];
                }
            }
            
        }
            break;
    }
    
    [self.homeCollectionView reloadData];
}

-(void)switchVC:(NSInteger)index {
    [self.showingChildVc.view removeFromSuperview];
    UIViewController *newVc = self.childViewControllers[index];
    [self.view addSubview:newVc.view];
    self.showingChildVc = newVc;
    [newVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
    }];
}


-(void)searchClick{
    
    MLSearchViewController *searchvc = [[MLSearchViewController alloc]init];
    [searchvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchvc animated:YES];
}




//获取版本
-(void)versionApi{
    kSelf;
    ML_NewestVersionApi *api = [[ML_NewestVersionApi alloc]initWithtype:@"1" extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        if([response.data[@"version"] isEqual:[NSNull null]])
        {

            NSLog(@"---NSNull---KDA!");
            return;
        }
        
        if(![response.data[@"version"] isKindOfClass:[NSDictionary class]])
        {

            NSLog(@"--NO-NSDictionary---KDA!");
            return;
        }
        
        if(response.data[@"version"] == nil)
        {

            NSLog(@"---nil---KDA!");
            return;
        }
        
        if(response.data[@"version"] == NULL)
        {

            NSLog(@"--NULL---KDA!");
            return;
        }
        
        
        
       
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *webVersion = [NSString stringWithFormat:@"%@", response.data[@"version"][@"code"]];
        NSInteger ss = [NSString compareVersion:webVersion to:localVersion];
        if (ss > 0) {
            NSLog(@"去更新版本");
            [self setupnewversionview:response.data[@"version"]];
        }else{
            
            NSLog(@"没有新版本");
        }

        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    ML_GetUserInfoApi *api2 = [[ML_GetUserInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token?:@"" extra:[self jsonStringForDictionary]];
    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response2) {
        NSLog(@"我的信息---%@",response2.data);

        UserInfoData * loginCurrentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response2.data[@"user"]];
        if (response2.data[@"pay"]) {
            currentData.alipay_U = [NSString stringWithFormat:@"%@", response2.data[@"pay"][@"alipay"]];
            currentData.wxpay_U = [NSString stringWithFormat:@"%@", response2.data[@"pay"][@"wxpay"]];
        }
        currentData.domain = loginCurrentData.domain;
        currentData.thirdId = loginCurrentData.thirdId;
        currentData.imToken = loginCurrentData.imToken;
        currentData.must = loginCurrentData.must;
        currentData.token = loginCurrentData.token;
        currentData.userId = loginCurrentData.userId;
        currentData.wxPay = loginCurrentData.wxPay;

        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
        
        if (![ML_AppUserInfoManager sharedManager].currentLoginUserData.isHello && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender boolValue]) {
            //一键打招呼设置
            [weakself onekeyzhaohu];
        }

        if ([ML_AppUtil isCensor]) {
            if (![[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqual:@"1"]){
                [weakself onlineView];
            }
        }
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"behavior"]) {
            UIView *view3 = [[UIView alloc] initWithFrame:weakself.view.window.bounds];
            view3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
            [weakself.view.window addSubview:view3];
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 311*mWidthScale, 365*mHeightScale)];
            imgV.userInteractionEnabled = YES;
            [view3 addSubview:imgV];
            imgV.image = kGetImage(@"user_behavior_background");
            imgV.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
            
            UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgV.width - 30, 60)];
            btn3.tag = 11;
            [btn3 addTarget:weakself action:@selector(chaView3:) forControlEvents:UIControlEventTouchUpInside];
            btn3.center = CGPointMake(imgV.width / 2, imgV.height - 44);
            [imgV addSubview:btn3];
        }
        
        

    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {

    }];
    
}

-(void)setupnewversionview:(NSDictionary *)dict{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    kSelf;
    self.versionShowView = [MLNewestVersionShowView alterVietextview:dict[@"content"] must:[dict[@"must"] boolValue] namestr:[NSString stringWithFormat:@"V%@%@",dict[@"version"], Localized(@"版本更新通知", nil)] StrblocksureBtClcik:^{
        NSURL *url = [NSURL URLWithString:[dict[@"url"] length]?dict[@"url"]:@"itms-services:///?action=download-manifest&url=https://dahuixiong.oss-cn-shenzhen.aliyuncs.com/data/apk/ios/Info.plist"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

    } cancelClick:^{
        
            [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"isGeng"];
        NSLog(@"asdfasdf====%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
        
            [weakself.versionShowView removeFromSuperview];

    }];

    [window addSubview:self.versionShowView];
}

-(void)onekeyzhaohu{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    kSelf;
    self.oneZhaohuView = [MLHomeOneZhaohuView alterVietextview:@"" namestr:@"" StrblocksureBtClcik:^{
  
        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        userData.isHello = YES;
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
        [weakself.oneZhaohuView removeFromSuperview];
    } cancelClick:^{
        [weakself.oneZhaohuView removeFromSuperview];
    }];
     [window addSubview:self.oneZhaohuView];
}

-(void)onlineView{
    MLHomeOnlineBottomView *onlinebottomview = [[MLHomeOnlineBottomView alloc]init];
    [onlinebottomview setSure_block:^{
        MLHomeOnlineViewController *vc = [[MLHomeOnlineViewController alloc]init];
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [self.view addSubview:onlinebottomview];
    [onlinebottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-160*mHeightScale);
        make.width.mas_equalTo(64*mWidthScale);
        make.height.mas_equalTo(66*mHeightScale);
    }];
}
- (void)LingBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) { // 上推荐
        
        if (btn.selected) {
            return;
        }
        ML_CommonApi *api2 = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"user/topRecommend"];
        kSelf;
        [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            
            NSDictionary *dic = response.data;
            if ([dic[@"recommendCode"] intValue] == 0) {
                btn.selected = YES;
                
                kplaceToast(@"上推荐成功");
                
                [weakself.homeCollectionView reloadData];
                [weakself.homeCollectionView reloadData];
                
                weakself.seconds = [dic[@"recommendExpire"] intValue];
                if (weakself.seconds > 0){
                    weakself.countDownTimer = nil;
                    weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                    [weakself.countDownTimer setFireDate:[NSDate distantPast]];
                }
                
            } else if ([dic[@"recommendCode"] intValue] == 1) {
                btn.selected = YES;
                
               NSString *str =  [NSString stringWithFormat:@"%@%@%@", Localized(@"请求频繁，请等待：", nil), dic[@"recommendExpire"], Localized(@"秒", nil)];
                
                kplaceToast(str);
            }
                
            
        } error:^(MLNetworkResponse *response) {
    
            
        } failure:^(NSError *error) {
            
            
        }];
        
    } else { // 一键搭讪
        ML_dashanView *dashanView=[[ML_dashanView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];
        [[UIApplication sharedApplication].delegate.window addSubview:dashanView];
        
    }
}
     
     
     
     

     
- (void)timePress{
    
    _seconds--;
    if (_seconds > 0) {
        self.button_recommended_40.selected = YES;
        //修改按钮显示时间
        NSLog(@"asdfasdf===%d", _seconds);
        
            NSString *str  = [NSString stringWithFormat:@"0%d:0%d", _seconds / 60, _seconds % 60];
        if (_seconds % 60 >= 10) {
            str  = [NSString stringWithFormat:@"0%d:%d", _seconds / 60, _seconds % 60];
            
        }
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        self.recommendExpireLabel.attributedText = string2;
        
        
        
    } else {
        self.button_recommended_40.selected = NO;
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
        self.recommendExpireLabel.attributedText = string2;
        
        //关闭定时器
         [_countDownTimer setFireDate:[NSDate distantFuture]];
    }
}


-(void)addZhuboView{
    kSelf;
    if ((!_button_recommended_40) && [ML_AppUserInfoManager.sharedManager.currentLoginUserData.host boolValue]) {
        UIButton *button_recommended_40 = [[UIButton alloc] init];
        button_recommended_40.tag = 1;
        [button_recommended_40 setBackgroundImage:kGetImage(@"button_recommended_40") forState:UIControlStateNormal];
        [button_recommended_40 setBackgroundImage:kGetImage(@"button_recommende_40") forState:UIControlStateSelected];
        [button_recommended_40 addTarget:weakself action:@selector(LingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [weakself.view addSubview:button_recommended_40];
        [button_recommended_40 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakself.view.mas_right);
            make.bottom.mas_equalTo(weakself.view.mas_bottom).mas_offset(-100);
            make.width.mas_equalTo(64*mWidthScale);
            make.height.mas_equalTo(57*mHeightScale);
        }];
        weakself.button_recommended_40 = button_recommended_40;
        weakself.button_recommended_40.selected = [weakself.foryouDic[@"recommend"] boolValue];

        UILabel *label = [[UILabel alloc] init];
        label.hidden = YES;
        label.frame = CGRectMake(40,3,78,22);
        label.numberOfLines = 0;
        [button_recommended_40 addSubview:label];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:Localized(@"上推荐", nil) attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.alpha = 1.0;

        UILabel *label2 = [[UILabel alloc] init];
        weakself.recommendExpireLabel = label2;
        label2.frame = CGRectMake(0,label.height + 3,124,14);
        [button_recommended_40 addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10*mWidthScale);
            make.right.mas_equalTo(-5*mWidthScale);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20*mHeightScale);
        }];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.alpha = 1.0;

        if (!weakself.button_recommended_40.selected) {

            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
            weakself.recommendExpireLabel.attributedText = string2;
        }
        else {
            weakself.seconds = [weakself.foryouDic[@"recommendExpire"] intValue];
            if (weakself.seconds > 0){
                weakself.countDownTimer = nil;
                weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                [weakself.countDownTimer setFireDate:[NSDate distantPast]];
            }
        }
    }

    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] && !_LingBtn1){
        UIButton *LingBtn1 = [[UIButton alloc] init];
        LingBtn1.tag = 0;
        [LingBtn1 setBackgroundImage:kGetImage(@"button_chat_32") forState:UIControlStateNormal];
        [LingBtn1 addTarget:self action:@selector(LingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:LingBtn1];
        self.LingBtn1 = LingBtn1;
        [LingBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(311*mWidthScale);
            make.top.mas_equalTo(569*mHeightScale);
            make.width.mas_equalTo(56*mWidthScale);
            make.height.mas_equalTo(58*mHeightScale);
        }];
    }
}
     
     
     
     
     
- (void)chaView3:(UIButton *)btn{
         if (btn.tag == 11) {
             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"behavior"];
         }
         [btn.superview.superview removeFromSuperview];
         
         if (btn.tag == 1) {
             
             NSDictionary *dic = self.callContents[self.laNameV.tag];
             
             
             ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"contentId" : dic[@"id"]} urlStr:@"host/sayHelloAccost"];
             
              [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                  if ([response.data[@"sayCode"] intValue] == 1) {
                      
                      [self um_oneTouchChatWithUserId:[NSString stringWithFormat:@"%@", dic[@"id"]]];
                  } else {
                      kplaceToast(response.data[@"msg"]?:@"搭讪失败");
                  }
                  
             } error:^(MLNetworkResponse *response) {
                 
                 
                 
             } failure:^(NSError *error) {
                 
             }];
             
         }
}
- (void)um_oneTouchChatWithUserId:(NSString *)userId {
           NSDictionary *eventParams = @{@"Um_Key_PageName":@"一键搭讪",
                                         @"Um_Key_UserID":userId,
                                         @"Um_Key_Type":@"1"
                                       };

//         [MobClick beginEvent:@"5122" primarykey:@"oneTouchChat" attributes:eventParams];
}


/***************************************************************接口数据**********************************************************************************************/
-(void)giveML_ForyouApi{
    kSelf;
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_ForyouApi *api = [[ML_ForyouApi alloc]initWithtoken:token page:@"1" limit:@"50" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
//        self.foryouArray = response.data[@"hosts"];
        self.foryouDic = response.data;
//        NSLog(@"为你优选-----%lu",(unsigned long)self.foryouArray.count);
        self.button_recommended_40.selected = [self.foryouDic[@"recommend"] boolValue];
        
        if (!weakself.button_recommended_40.selected) {
            
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
            weakself.recommendExpireLabel.attributedText = string2;
        } else {
            weakself.seconds = [weakself.foryouDic[@"recommendExpire"] intValue];
            if (weakself.seconds > 0){
                weakself.countDownTimer = nil;
                weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                [weakself.countDownTimer setFireDate:[NSDate distantPast]];
            }
        }
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
        
}






//获取顶部图片
-(void)giveML_bannerApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_bannerApi *api = [[ML_bannerApi alloc] initWithtoken:token extra:[self jsonStringForDictionary]];
    [SVProgressHUD show];
    [self.bannersArray removeAllObjects];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"轮播图-------%@",response.data);
        [response.data[@"banners"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
            NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"img"]];
            [self.bannersArray addObject:ss];
        }];
        self.ML_webCycleScrollView.imageURLStringsGroup = self.bannersArray;
        NSMutableArray *muArr = [NSMutableArray array];
        [self.homeCollectionView.mj_header endRefreshing];
        [self.homeCollectionView.mj_footer endRefreshing];

     } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//获取推荐主播数据
-(void)giveML_getTypeHostsApiWithType:(NSString *)type{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
  
    NSInteger currentPage;
    NSMutableArray *currentArray;
    switch (type.integerValue) {
        case 0://推荐
        {
            currentPage=self.recommendpage;
            currentArray=self.homeArray;
        }
            break;
        case 7://海
        {
            currentPage=self.haiPage;
            currentArray=self.haiarray;
        }
            break;
        case 8://颜值
        {
            currentPage=self.yanzhiPage;
            currentArray=self.yanchiArray;
        }
            break;
        case 9://多才
        {
            currentPage=self.duocaiPage;
            currentArray=self.duocaiArray;
        }
            break;
        case 10://多艺
        {
            currentPage=self.duoyiPage;
            currentArray=self.duoyiArray;
        }
            break;
        default:
            break;
    }
    
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc] initWithtoken:token type:type page:[NSString stringWithFormat:@"%ld", currentPage] limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        NSArray *arr = response.data[@"hosts"];
        
        arr = [NSArray changeType:arr];
        
        if (currentPage == 1) {
            [currentArray removeAllObjects];

           
        }
        
        for (NSDictionary *dic in arr) {
            [currentArray addObject:dic];
            
        }
        
        [weakself.homeCollectionView reloadData];
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
    } error:^(MLNetworkResponse *response) {
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
    }];
}
//获取同城主播数据
-(void)giveML_getCityHostsApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lo = [defaults objectForKey:@"longstr"]?:@"";
    NSString *la = [defaults objectForKey:@"latstr"]?:@"";
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"4" page:@(self.citypage) limit:@"20" location:[NSString stringWithFormat:@"%@,%@", lo, la] extra:[self jsonStringForDictionary]];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"hosts"];
        arr = [NSArray changeType:arr];
        if (weakself.citypage == 1) {
            [weakself.cityArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.cityArray addObject:dic];
        }

        [weakself.homeCollectionView reloadData];
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    }];
}

//获取在线主播数据
-(void)giveML_showOnlineApi{
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:currentData.token type:@"1" page:@(self.onlinepage) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
       
        NSArray *arr = response.data[@"hosts"];
        
        arr = [NSArray changeType:arr];
        
        if (weakself.onlinepage == 1) {
            [weakself.onlineArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.onlineArray addObject:dic];
        }
        

        [weakself.homeCollectionView reloadData];
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    
    } error:^(MLNetworkResponse *response) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    }];
}

//获取新人主播数据
-(void)giveML_newpersonApi{
        NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"2" page:@(self.nuserpage) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"hosts"];

        arr = [NSArray changeType:arr];
        if (weakself.nuserpage == 1) {
            [weakself.NuserArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.NuserArray addObject:dic];
            

        }

        [weakself.homeCollectionView reloadData];
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];

        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    }];

}
//获取关注主播数据
-(void)giveML_focusApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"3" page:@(self.guanzhupage) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
       
        NSArray *arr = response.data[@"hosts"];
        if (arr.count == 0 && self.guanzhupage == 1) {

            [self.view addSubview:self.nodataView];
        }else{
            [self.nodataView removeFromSuperview];
    
        }

        arr = [NSArray changeType:arr];
        if (weakself.guanzhupage == 1) {
            [weakself.guanzhuArray removeAllObjects];
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.guanzhuArray addObject:dic];
 
        }

        [weakself.homeCollectionView reloadData];
            [weakself.homeCollectionView.mj_footer endRefreshing];
            [weakself.homeCollectionView.mj_header endRefreshing];

        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    }];
}


- (void)startLocation{
    [TZLocationManager.manager startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        self.homeCollectionView.mj_header.hidden = NO;
        self.dingBt.hidden = YES;
        CLLocation *CurrentLocation = [locations lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.longitude] forKey:@"longstr"];
        [defaults setObject:[NSString stringWithFormat:@"%f", CurrentLocation.coordinate.latitude] forKey:@"latstr"];
    
        [defaults synchronize];
        [self giveML_getCityHostsApi];
        
        
        
    } failureBlock:^(NSError *error) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lo = [defaults objectForKey:@"longstr"];
        if (!lo) {
            [self.dingBt removeFromSuperview];
            self.homeCollectionView.mj_header.hidden = YES;
            UIButton *dingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            dingBtn.backgroundColor = kZhuColor;
            dingBtn.layer.cornerRadius = 10;
            [dingBtn addTarget:self action:@selector(dingClick) forControlEvents:UIControlEventTouchUpInside];
            [dingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            dingBtn.center = CGPointMake(ML_ScreenWidth / 2, self.view.height / 2 );
            [dingBtn setTitle:@"重新定位" forState:UIControlStateNormal];
            [self.view addSubview:dingBtn];
            self.dingBt = dingBtn;
        }
    }];
}
-(void)dingClick{
    [self opentNotificationAlertWithTitle:@"定位"];
}


- (void)opentNotificationAlertWithTitle:(NSString *)title
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"无法使%@，前往：\"设置>%@\"中打开%@权限", title, app_Name, title];

    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@权限未开启", title] message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        }
        
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    
    [[UIViewController topShowViewController] presentViewController:alertCon animated:YES completion:^{
        
    }];
    
}

/**动态页面**/
#pragma mark -- 获取招呼列表------
-(void)giveMLZhaohuListApi{
    MLZhaohuListApi *api = [[MLZhaohuListApi alloc]initWithstatus:@"1" limit:@"10" page:@"1" token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"招呼设置列表----%@",response.data);
        self.zhaohudata  = response.data[@"callContents"];
        if (self.zhaohudata.count) {
            
            self.titleLabel.text = [NSString stringWithFormat:@"%@",self.zhaohudata[0][@"content"]];
            [self.ML_showTableview reloadData];
        }
    } error:^(MLNetworkResponse *response) {
        NSLog(@"招呼设置列表 %@ %@",response.data,response.msg);
    } failure:^(NSError *error) {
        NSLog(@"招呼设置列表 %@ ",error.localizedDescription);
    }];
}






-(void)giveML_getTypeHostsApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getUserOperationsApi *api = [[ML_getUserOperationsApi alloc]initWithtoken:token page:@(self.dongtaiPage) limit:@"20" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSArray *arr = response.data[@"operations"];
        arr = [NSArray changeType:arr];
        if (weakself.dongtaiPage == 1) {
            [weakself.dongtaiArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {

            [weakself.dongtaiArray addObject:dic];
 
        }
        if (arr.count) {
            [weakself.homeCollectionView reloadData];
            [weakself.homeCollectionView.mj_footer endRefreshing];
            [weakself.homeCollectionView.mj_header endRefreshing];
        } else {
            [weakself.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.homeCollectionView.mj_footer endRefreshing];
        [weakself.homeCollectionView.mj_header endRefreshing];
        
    }];
}

-(void)downClick{
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];
    self.img.image = [UIImage imageNamed:@"Sliceirow40"];
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"zhaohubg"];
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
    self.bglistimg = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sectionView.mas_left).mas_offset(33);
        make.right.mas_equalTo(self.sectionView.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.bgview.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(306);
    }];
    self.ML_showTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ML_showTableview.delegate = self;
    self.ML_showTableview.dataSource = self;
    self.ML_showTableview.backgroundColor = UIColor.clearColor;
    self.ML_showTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ML_showTableview.layer.cornerRadius = 12;
    self.ML_showTableview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2500].CGColor;
    self.ML_showTableview.layer.shadowOffset = CGSizeMake(0,0);
    self.ML_showTableview.layer.shadowOpacity = 1;
    self.ML_showTableview.layer.shadowRadius = 3;
    self.ML_showTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ML_showTableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [img addSubview:self.ML_showTableview];
    [self.ML_showTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(img).mas_offset(0);
        make.top.mas_equalTo(img.mas_top).mas_offset(15);
        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-5);
    }];

    if (self.isDashan == NO) {
        self.isDashan = YES;
    }else{
        self.isDashan = NO;
        self.img.image = [UIImage imageNamed:@"Sliceirow40down"];

        [self.ML_showTableview removeFromSuperview];
        [self.bglistimg removeFromSuperview];
    }
}

-(void)giveZHaohutop:(NSString *)index{
    MLZhidingZhaohuApi *zhidingapi = [[MLZhidingZhaohuApi alloc]initWithcontentId:index token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [zhidingapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

@end
