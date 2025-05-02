//
//  ML_MineFocusffViewController.m
//  miliao
//
//  Created by apple on 2022/9/14.
//

#import "ML_MineFocusffViewController.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "MLminefensiTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_FocusBottomTableViewCell.h"
#import "MLGetUserFriendsApi.h"
#import <MJRefresh/MJRefresh.h>
#import "ML_HostdetailsViewController.h"
#import "ML_sayHelloApi.h"
#import "UIViewController+MLHud.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "ML_NTableViewCell.h"

@interface ML_MineFocusffViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIView *ML_headview;
@property (nonatomic,copy) NSString *userId;;
@property (nonatomic, assign)int ML_Page;
@property (nonatomic,strong)UIView *tableHeadView;

@end

@implementation ML_MineFocusffViewController

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 60*mHeightScale)];
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_tableHeadView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(_tableHeadView.mas_centerY);
            make.width.mas_equalTo(90*mWidthScale);
            make.height.mas_equalTo(16*mHeightScale);
        }];
        iv.image = kGetImage(@"guanzhuH");
    }
    return _tableHeadView;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self giveML_focusApi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    
    kSelf;
    self.tableView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        weakself.ML_Page = 1;
        [weakself giveML_focusApi];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //#import "Rob_euCHNRefreshGifHeader.h"
    //#import "Rob_euCHNRefreshFooter.h"
    self.tableView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.ML_Page ++;

        [weakself giveML_focusApi];
    }];
}

-(void)giveML_focusApi{
    kSelf;
    MLGetUserFriendsApi *api = [[MLGetUserFriendsApi alloc]initWithtoUserId:@"" token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token type:@"0" page:@(self.ML_Page) limit:@"20" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSArray *arr = response.data[@"friends"];
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.data removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            [weakself.data addObject:dic];
        }
        if (arr.count) {
            [weakself.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [self.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakself.tableView.mj_header endRefreshing];
        }
        
        if (arr.count == 0 && self.ML_Page == 1) {
            weakself.tableView.mj_footer.hidden = YES;
        }else{
            weakself.tableView.mj_footer.hidden = NO;
        }
        
        
        

    } error:^(MLNetworkResponse *response) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
    }];
}


-(void)setupUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ML_NTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    
   
    
    
    
    //初始化一个emptyView
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"queshengzhi"
                                                       titleStr:nil
                                                      detailStr:@""];
    //元素竖直方向的间距
    emptyView.subViewMargin = 0.0f;
    emptyView.contentViewY = 30;
    //设置空内容占位图
    self.tableView.ly_emptyView = emptyView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_NTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSMutableDictionary *nmdict = [NSMutableDictionary dictionary];
    //NSLog(@"dict--------%@",dict);
    //[nmdict setObject:@"15198698" forKey:@"userId"];
    [self.data[indexPath.row] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@ and obj = %@", key, obj);
        if ([key isEqualToString:@"id"]) {
            self.userId = obj;
            [nmdict removeObjectForKey:key];
        }
        [nmdict setObject:obj forKey:key];
    }];
    [nmdict setObject:self.userId forKey:@"userId"];
    [nmdict removeObjectForKey:@"id"];
    
    
    cell.dic=nmdict;
    cell.issearch = YES;
    cell.isguanzhu = NO;
//    MLminefensiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//      if(cell == nil) {
//          cell =[[MLminefensiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//          cell.backgroundColor = [UIColor whiteColor];
//      }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.tag = indexPath.row;
//    cell.dict = self.data[indexPath.row];
//    [cell setClickCellVideoBlock:^(NSInteger index) {
//        [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@",self.data[index][@"id"]] isCalled:NO type:NERtcCallTypeVideo];
//    }];
//    [cell setClickbuttonBlock:^(NSInteger index,UIButton *btn) {
//            //打招呼状态，0-未打招呼 1-已打招呼，type=3和4时存在
//        btn.tag = indexPath.row;
//            if ([[btn currentTitle] isEqualToString:@""]) {
////            if ([self.data[index][@"call"] integerValue] == 0) {
////                [self giveapitoUserId:[NSString stringWithFormat:@"%@",self.data[index][@"id"]] btn:btn];
////            }else{
//                [self gotoChatVC:[NSString stringWithFormat:@"%@",self.data[index][@"id"]]];
//            } else {
//                [self giveapitoUserId:[NSString stringWithFormat:@"%@",self.data[index][@"id"]] btn:btn];
//            }
//        }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102*mHeightScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
    
    NSMutableDictionary *nmdict = [NSMutableDictionary dictionary];
    //NSLog(@"dict--------%@",dict);
    //[nmdict setObject:@"15198698" forKey:@"userId"];
    [self.data[indexPath.row] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@ and obj = %@", key, obj);
        if ([key isEqualToString:@"id"]) {
            self.userId = obj;
            [nmdict removeObjectForKey:key];
        }
        [nmdict setObject:obj forKey:key];
    }];
    [nmdict setObject:self.userId forKey:@"userId"];
    [nmdict removeObjectForKey:@"id"];
     ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@", nmdict[@"userId"]]];
    vc.dict = nmdict;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60*mHeightScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeadView;
}

//打招呼---
-(void)giveapitoUserId:(NSString *)toUserId btn:(UIButton *)btn{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:toUserId extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        NSLog(@"打招呼%@",response.data);
        [self showMessage:@"打招呼成功,可以给好友私信啦"];
        [btn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(28);
        }];
//        [self.tableView reloadData];
        
        
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.data[btn.tag]];
        [muDic setObject:@(1) forKey:@"call"];
        [self.data replaceObjectAtIndex:btn.tag withObject:muDic];
        
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        //[self giveML_focusApi];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}


@end
