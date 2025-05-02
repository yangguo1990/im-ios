//
//  MLMineXingxiangViewController.m
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLMineXingxiangViewController.h"
#import "MLGetLableLibApi.h"
#import "MLMineBiaoqianCollectionViewCell.h"
#import <Colours/Colours.h>
#import "UIViewController+MLHud.h"

@interface MLMineXingxiangViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *datacolor;

@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,assign)BOOL isOpen;
@end

@implementation MLMineXingxiangViewController

-(NSMutableArray *)dataid{
    if (_dataid == nil) {
        _dataid = [NSMutableArray array];
    }
    return _dataid;
}
-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(NSMutableArray *)datacolor{
    if (_datacolor == nil) {
        _datacolor = [NSMutableArray array];
    }
    return _datacolor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"形象标签", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    [self giveMLGetLableLibApi];
    [self setupUI];
    self.isOpen = NO;
}

//xingxiang----
-(void)giveMLGetLableLibApi{
    MLGetLableLibApi *api = [[MLGetLableLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] host:@"1"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [response.data[@"lableLib"] enumerateObjectsUsingBlock:^(NSMutableDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop){
            //[dict setValue:@"0" forKey:@"isopen"];
            [weakself.data addObject:dict];
        }];
        [weakself.ML_homeCollectionView reloadData];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(void)setupUI{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.backgroundColor = kZhuColor.CGColor;
//    btn.layer.cornerRadius = 25;
    [btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
    [btn setTitle:Localized(@"完成", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"最多选择三个标签", nil);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(29 + 64);
    }];

    //1、实例化一个流水布局
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       //1-1、设置Cell大小
       flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-51)/4, 32);
       //1-2、设置四周边距
       flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
       //1-3、设置最小列之间的距离
       flowLayout.minimumInteritemSpacing = 7;
       //1-4、设置最小行之间的距离
       flowLayout.minimumLineSpacing = 12;
       //2、实例化创建一个 UICollectionView
       //UICollectionView必须有一个 flowLayout ，必须在实例化的时候进行设置
        self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
        self.ML_homeCollectionView.backgroundColor = [UIColor whiteColor];
       //4、设置数据源代理
       self.ML_homeCollectionView.dataSource = self;
       self.ML_homeCollectionView.delegate = self;
       //添加到视图中
       [self.view addSubview:self.ML_homeCollectionView];
       //注册Cell视图
       [self.ML_homeCollectionView registerClass:[MLMineBiaoqianCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-40);
    }];

}

//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.data.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLMineBiaoqianCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[MLMineBiaoqianCollectionViewCell alloc]init];
        }
    cell.nameLabel.text = self.data[indexPath.row][@"name"];
    cell.nameLabel.tag = indexPath.row;
    kSelf;
    [self.dataid enumerateObjectsUsingBlock:^(NSString *textlabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textlabel isEqualToString:cell.nameLabel.text]) {
            cell.nameLabel.textColor = UIColor.whiteColor;
            cell.bgview.backgroundColor = kGetColor(@"ff6fb3");
        }
    }];
    
    //cell.nameLabel.textColor = [UIColor colorWithHexString:self.data[indexPath.row][@"color"]];
    [cell setReturnBlock:^(UILabel * _Nonnull showText, UIView * _Nonnull bgview) {
        NSLog(@"选择的内容----%@",showText.text);
        [weakself setupshowText:showText bgview:bgview];
    }];
        return cell;
}

-(void)setupshowText:(UILabel *)showText bgview:(UIView *)bgview{
    if ([self.dataid containsObject:showText.text]) {
        [self.dataid removeObject:showText.text];
        showText.textColor = [UIColor colorFromHexString:@"#999999"];
        bgview.backgroundColor = [UIColor colorFromHexString:@"#EEEEEE"];
    }else{
        if (self.dataid.count <= 2) {
            NSLog(Localized(@"最多选择三个标签", nil));
            [self.dataid addObject:showText.text];
            showText.textColor = UIColor.whiteColor;
            bgview.backgroundColor = kGetColor(@"ff6fb3");
        }else{
            [self showMessage:@"最多选择三个"];
        }
    }
    NSLog(@"选择标签-----%@",self.dataid);
}


-(void)btnClick{
    NSLog(Localized(@"完成", nil));
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *str in self.dataid) {
        
        for (NSDictionary *dic in self.data) {
            if ([str isEqualToString:dic[@"name"]]) {
                [muArr addObject:dic];
                break;
            }
        }
        
    }
    self.returnBlock(self.dataid, muArr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"adsfasdfasd=f===");
}

@end
