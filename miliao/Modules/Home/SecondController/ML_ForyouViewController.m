//
//  ML_ForyouViewController.m
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import "ML_ForyouViewController.h"
#import <Masonry/Masonry.h>
#import "ML_HotCollectionViewCell.h"
#import <Colours/Colours.h>
#import "ML_ForyouApi.h"
#import "ML_HostVideoViewController.h"
#import "ML_HostdetailsViewController.h"
#import "MJRefresh.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
@interface ML_ForyouViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *foryouArray;
@property (nonatomic,assign) int ML_Page;
@end

@implementation ML_ForyouViewController

-(NSMutableArray *)foryouArray{
    if (_foryouArray == nil) {
        _foryouArray = [NSMutableArray array];
    }
    return _foryouArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}


static NSString *ident = @"cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.text = Localized(@"为你优选", nil);
    [self setupUI];
//    [self giveML_ForyouApi];

    kSelf;
    self.ML_homeCollectionView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_Page = 1;
        [weakself giveML_ForyouApi];
        
    }];
    
    [self.ML_homeCollectionView.mj_header beginRefreshing];
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.ML_homeCollectionView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_ForyouApi];
    }];

}


-(void)giveML_ForyouApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_ForyouApi *api = [[ML_ForyouApi alloc]initWithtoken:token page:@(self.ML_Page) limit:@"20" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"hosts"];
        NSLog(@"%@",self.foryouArray);
        
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.foryouArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.foryouArray addObject:dic];
            
//            if (weakself.data.count > [response.data[@"total"] intValue]) {
//
//                [weakself.data removeLastObject];
//
//                break;
//            }
        }
        if (arr.count) {
            [weakself.ML_homeCollectionView reloadData];
            [weakself.ML_homeCollectionView.mj_footer endRefreshing];
            [weakself.ML_homeCollectionView.mj_header endRefreshing];
        } else {
            [weakself.ML_homeCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.ML_homeCollectionView.mj_footer endRefreshing];
        [weakself.ML_homeCollectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.ML_homeCollectionView.mj_footer endRefreshing];
        [weakself.ML_homeCollectionView.mj_header endRefreshing];
        
    }];
}

-(void)setupUI{

    //1、实例化一个流水布局
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       //1-1、设置Cell大小
       flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-21)/2, 180);
       //1-2、设置四周边距
       flowLayout.sectionInset = UIEdgeInsetsMake(2, 5, 2, 5);
       //1-3、设置最小列之间的距离
       //flowLayout.minimumLineSpacing = 7;
       //1-4、设置最小行之间的距离
       //flowLayout.minimumLineSpacing = 7;
       //2、实例化创建一个 UICollectionView
       //UICollectionView必须有一个 flowLayout ，必须在实例化的时候进行设置
        self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
//    self.ML_homeCollectionView.backgroundColor = [UIColor whiteColor];
       //4、设置数据源代理
    self.ML_homeCollectionView.dataSource = self;
    self.ML_homeCollectionView.delegate = self;
       //添加到视图中
       [self.view addSubview:self.ML_homeCollectionView];
       //注册Cell视图
       [self.ML_homeCollectionView registerClass:[ML_HotCollectionViewCell class] forCellWithReuseIdentifier:ident];
    self.ML_homeCollectionView.backgroundColor = UIColor.whiteColor;
       [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReusableView"];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.left.right.top.mas_equalTo(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
}

//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.foryouArray.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ML_HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[ML_HotCollectionViewCell alloc]init];
        }
         cell.dict = self.foryouArray[indexPath.item];

        return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.foryouArray[indexPath.item];
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        if ([self.foryouArray[indexPath.item][@"coverType"] integerValue] == 0) {
            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
            vc.dict = self.foryouArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
            vc.dict = self.foryouArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
    }
}


@end
