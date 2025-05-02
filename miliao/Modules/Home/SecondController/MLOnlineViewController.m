//
//  MLOnlineViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLOnlineViewController.h"
#import <Masonry/Masonry.h>
#import "ML_OnlineCollectionViewCell.h"
#import <Colours/Colours.h>
#import "ML_getTypeHostsApi.h"
#import "MJRefresh.h"
#import "ML_HostVideoViewController.h"
#import "ML_HostdetailsViewController.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
@interface MLOnlineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_onlinArray;
@property (nonatomic, assign)int ML_Page;
@end

@implementation MLOnlineViewController


static NSString *ident = @"cell";

-(NSMutableArray *)ML_onlinArray{
    if (_ML_onlinArray == nil) {
        _ML_onlinArray = [NSMutableArray array];
    }
    return _ML_onlinArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.ML_titleLabel.text = Localized(@"在线", nil);
    [self setupUI];

    kSelf;
    self.ML_homeCollectionView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_homeCollectionView.mj_footer.hidden = NO;
        weakself.ML_Page = 1;
        [weakself giveML_showOnlineApi];
        
    }];
    
    [self.ML_homeCollectionView.mj_header beginRefreshing];
    

    self.ML_homeCollectionView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_showOnlineApi];
    }];
}

-(void)giveML_showOnlineApi{
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc]initWithtoken:currentData.token type:@"1" page:@(self.ML_Page) limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
       
        NSArray *arr = response.data[@"hosts"];
        
        arr = [NSArray changeType:arr];
        
        if (weakself.ML_Page == 1) {
            [weakself.ML_onlinArray removeAllObjects];
            
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.ML_onlinArray addObject:dic];
            
//            if (weakself.ML_onlinArray.count > [response.data[@"total"] intValue]) {
//
//                [weakself.ML_onlinArray removeLastObject];
//
//                break;
//            }
        }
        
        if (arr.count) {
            [weakself.ML_homeCollectionView reloadData];
        } else {
            
            self.ML_homeCollectionView.mj_footer.hidden = YES;
        }
        
        [weakself.ML_homeCollectionView.mj_footer endRefreshing];
        [weakself.ML_homeCollectionView.mj_header endRefreshing];
        
    
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
       [self.ML_homeCollectionView registerClass:[ML_OnlineCollectionViewCell class] forCellWithReuseIdentifier:ident];
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
    
    return self.ML_onlinArray.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ML_OnlineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[ML_OnlineCollectionViewCell alloc]init];
        }
    cell.dict = self.ML_onlinArray[indexPath.item];
        return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.ML_onlinArray[indexPath.item];
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        if ([self.ML_onlinArray[indexPath.item][@"coverType"] integerValue] == 0) {
            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
            vc.dict = self.ML_onlinArray[indexPath.row];
         
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
            vc.dict = self.ML_onlinArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
    }
}





@end
