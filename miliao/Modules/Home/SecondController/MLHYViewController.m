//
//  MLHYViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLHYViewController.h"
#import <Masonry/Masonry.h>
#import "ML_HotCollectionViewCell.h"
#import <Colours/Colours.h>
#import "ML_getTypeHostsApi.h"
#import "MJRefresh.h"
#import "ML_HostVideoViewController.h"
#import "ML_HostdetailsViewController.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface MLHYViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_newpersonArray;
@property (nonatomic,assign) int ML_Page;
@end

@implementation MLHYViewController


static NSString *ident = @"cell";

-(NSMutableArray *)ML_newpersonArray{
    if (_ML_newpersonArray == nil) {
        _ML_newpersonArray = [NSMutableArray array];
    }
    return _ML_newpersonArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.whiteColor;

//    self.ML_titleLabel.text = Localized(@"新人", nil);
    [self setupUI];
//    [self giveML_newpersonApi];

    kSelf;
    self.ML_homeCollectionView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_Page = 1;
        [weakself giveML_newpersonApi];
        
    }];
    
    [self.ML_homeCollectionView.mj_header beginRefreshing];
    self.ML_homeCollectionView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_newpersonApi];
    }];


}

-(void)giveML_newpersonApi{
        NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:token type:@"7" page:@(self.ML_Page) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"hosts"];
        NSLog(@"%@",self.ML_newpersonArray);
        
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.ML_newpersonArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.ML_newpersonArray addObject:dic];
            

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
     flowLayout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
     flowLayout.minimumInteritemSpacing = 7;
     flowLayout.minimumLineSpacing = 7;

       //2、实例化创建一个 UICollectionView
       //UICollectionView必须有一个 flowLayout ，必须在实例化的时候进行设置
        self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
    self.ML_homeCollectionView.backgroundColor = [UIColor clearColor];
       //4、设置数据源代理
    self.ML_homeCollectionView.dataSource = self;
    self.ML_homeCollectionView.delegate = self;
       //添加到视图中
       [self.view addSubview:self.ML_homeCollectionView];
       //注册Cell视图
       [self.ML_homeCollectionView registerClass:[ML_HotCollectionViewCell class] forCellWithReuseIdentifier:ident];
       [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReusableView"];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
}

//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.ML_newpersonArray.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ML_HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[ML_HotCollectionViewCell alloc]init];
        }
    cell.dict = self.ML_newpersonArray[indexPath.item];
        return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.ML_newpersonArray[indexPath.item];
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        if ([self.ML_newpersonArray[indexPath.item][@"coverType"] integerValue] == 0) {
            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
            vc.dict = self.ML_newpersonArray[indexPath.item];

            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
            vc.dict = self.ML_newpersonArray[indexPath.item];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
    }
}



@end
