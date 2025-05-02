//
//  ML_dynamicViewController.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_dynamicViewController.h"
#import "MJRefresh.h"
#import "ML_dynamicTableViewCell.h"
#import <Masonry/Masonry.h>
#import "ML_getUserOperationsApi.h"
#import "ML_sayHelloApi.h"
#import "ML_HostdetailsViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "UIViewController+MLHud.h"
#import <Colours/Colours.h>
#import "MLZhaohuListApi.h"
#import "MLDynameSHowTableViewCell.h"
#import "MLZhidingZhaohuApi.h"
#import "MLHostcallUserApi.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"

@interface ML_dynamicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIImageView *bgview;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)NSMutableArray *zhaohudata;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign)BOOL isDashan;

@property (nonatomic, assign)int ML_Page;
@property (nonatomic,strong)UIImageView *bglistimg;
@end

@implementation ML_dynamicViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self giveML_getTypeHostsApi];
    [self giveMLZhaohuListApi];
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];
    self.img.image = [UIImage imageNamed:@"Sliceirow40down"];
}


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
    } failure:^(NSError *error) {
    }];
}

-(void)giveZHaohutop:(NSString *)index{
    MLZhidingZhaohuApi *zhidingapi = [[MLZhidingZhaohuApi alloc]initWithcontentId:index token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [zhidingapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        //NSLog(@"置顶招呼----%@",response.data);
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}


-(void)giveML_getTypeHostsApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getUserOperationsApi *api = [[ML_getUserOperationsApi alloc]initWithtoken:token page:@(self.ML_Page) limit:@"20" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSArray *arr = response.data[@"operations"];
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

-(NSMutableArray *)zhaohudata{
    if (_zhaohudata == nil) {
        _zhaohudata = [NSMutableArray array];
    }
    return _zhaohudata;
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
    self.isDashan = NO;
    
    kSelf;
    self.tablview.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_Page = 1;
        [weakself giveML_getTypeHostsApi];
        
    }];
    
    [self.tablview.mj_header beginRefreshing];
   
    self.tablview.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_getTypeHostsApi];
    }];


}

-(void)setupUI{
    UIImageView *bgview = [[UIImageView alloc]init];
    bgview.image = [UIImage imageNamed:@"zhaohubghead"];
    bgview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downClick)];
    [bgview addGestureRecognizer:tap];
    [self.view addSubview:bgview];
    self.bgview = bgview;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(8);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = Localized(@"招呼语:", nil);
    numberLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    numberLabel.textColor = [UIColor blackColor];
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
    
    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.backgroundColor = UIColor.clearColor;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.tableFooterView = [UIView new];
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(bgview.mas_bottom).mas_offset(5);
    }];
    
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.imageSize = CGSizeMake(180, 220);
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 30;
    //设置空内容占位图
    self.tablview.ly_emptyView = emptyView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.ML_showTableview]) {
        return self.zhaohudata.count;
    }else{
        return self.data.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.ML_showTableview]) {
        MLDynameSHowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
          if(cell == nil) {
              cell =[[MLDynameSHowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"showcell"];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
          }
        cell.nameLabel.text = self.zhaohudata[indexPath.row][@"content"];
        return cell;
        
    }else{
        ML_dynamicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_dy"];
          if(cell == nil) {
              cell =[[ML_dynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_dy"];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
          }
        cell.dict = self.data[indexPath.row];
        cell.tag = indexPath.row;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setClickCellVideoBlock:^(NSInteger index) {
            [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]] isCalled:NO];
        }];
        kSelf;
        [cell setClickbuttonBlock:^(NSInteger index, UIButton *btn) {
                //打招呼状态，0-未打招呼 1-已打招呼，type=3和4时存在
            if ([self.data[index][@"call"] integerValue] == 0) {
                //[self giveapitoUserId:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]]];
                
                [self giveapitoUserId:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]] operationLogId:[NSString stringWithFormat:@"%@",weakself.data[index][@"id"]] cell:cell btn:btn];
            }else{
                [self gotoChatVC:[NSString stringWithFormat:@"%@",self.data[index][@"userId"]]];
            }
        }];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.ML_showTableview]) {
        return 54;
    }else{
        return 104;
    }
 }

-(void)giveapitoUserId:(NSString *)toUserId operationLogId:(NSString *)operationLogId cell:(ML_dynamicTableViewCell *)cell btn:(UIButton *)btn{
    if (!self.zhaohudata.count) {
        return;
    }
    kSelf;
    MLHostcallUserApi *api = [[MLHostcallUserApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] operationLogId:operationLogId contentId:[NSString stringWithFormat:@"%@", self.zhaohudata[0][@"id"]] toUserId:toUserId];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        //[self showMessage:@"打招呼成功,可以给好友私信啦"];
        //[self giveML_getTypeHostsApi];
        btn.selected = !btn.selected;
        
        if (!btn.selected) {
            btn.layer.borderWidth = 0.5;
            btn.frame = CGRectMake(ML_ScreenWidth - 12 - 65, cell.nameLabel.y, 65, 32);
        }else{
            btn.layer.borderWidth = 0;
            btn.frame = CGRectMake(ML_ScreenWidth - 65, cell.nameLabel.y, 40, 28);
        }
        
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:weakself.data[cell.tag]];
        [muDic setObject:@(![muDic[@"call"] boolValue]) forKey:@"call"];
        [weakself.data replaceObjectAtIndex:cell.tag withObject:muDic];
        
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [self.tablview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.ML_showTableview]) {
        self.img.image = [UIImage imageNamed:@"Sliceirow40down"];
        MLDynameSHowTableViewCell * cell = (MLDynameSHowTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        self.titleLabel.text = cell.nameLabel.text;
        [self giveZHaohutop:[NSString stringWithFormat:@"%@",self.zhaohudata[indexPath.row][@"id"]]];
        [self.ML_showTableview removeFromSuperview];
        [self.bglistimg removeFromSuperview];
        self.isDashan = NO;
    }else{
        [self.ML_showTableview removeFromSuperview];
        [self.bglistimg removeFromSuperview];
        ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
        vc.dict = self.data[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)downClick{
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];
    self.img.image = [UIImage imageNamed:@"Sliceirow40"];
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"zhaohubg"];
    [self.view addSubview:img];
    self.bglistimg = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(33);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.bgview.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(306);
    }];

    self.ML_showTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ML_showTableview.delegate = self;
    self.ML_showTableview.dataSource = self;
    self.ML_showTableview.backgroundColor = UIColor.clearColor;
    self.ML_showTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.ML_showTableview.layer.cornerRadius = 12;
    self.ML_showTableview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2500].CGColor;
   
    self.ML_showTableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.view addSubview:self.ML_showTableview];
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

@end
