//
//  MLCityViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "ML_MeiliYaoqingVC.h"
#import "ML_MeiCell.h"
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

@interface ML_MeiliYaoqingVC ()<UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,assign)int ML_Page;
@property(nonatomic,strong)UIButton *dingBtn;
@property (nonatomic ,strong) CLLocationManager *LocationManager;

@property (nonatomic,strong)UILabel *laNameV1;
@property (nonatomic,strong)UILabel *laJiangV1;
@property (nonatomic,strong)UIButton *LingBtn1;

@property (nonatomic,strong)UILabel *laNameV2;
@property (nonatomic,strong)UILabel *laJiangV2;
@property (nonatomic,strong)UIButton *LingBtn2;

@property (nonatomic,assign)BOOL isLing;
@property (nonatomic,strong)UILabel *laNameV3;
@property (nonatomic,strong)UILabel *laJiangV3;
@property (nonatomic,strong)UIButton *LingBtn3;
@property (nonatomic,strong)UIImageView *cv1;
@property (nonatomic,strong)UIImageView *cv2;
@property (nonatomic,strong)UIImageView *cv3;
@end

@implementation ML_MeiliYaoqingVC

-(void)giveML_getTypeHostsApi{

    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"way" : self.way, @"type" : self.type} urlStr:@"top/getUserTop"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

    
        NSArray *arr = response.data[@"tops"];
       
        
        arr = [NSArray changeType:arr];
        if (weakself.ML_Page == 1) {
            [weakself.data removeAllObjects];
            
        }
         int i = 0;
        for (NSDictionary *dic in arr) {
            
            [weakself.data addObject:dic];
            
            if (i == 0) {
                
                self.LingBtn1.hidden = !([self.type intValue]==3);
                
                [self.cv1 sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
                self.laNameV1.text = dic[@"name"];
                if ([self.type intValue] == 3){
                    self.laJiangV1.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"奖励：", nil), dic[@"reward"]?:@"", Localized(@"元", nil)];
                } else {
                    self.laJiangV1.hidden = ([self.way intValue] != 4);
                }
                self.LingBtn1.selected = ![dic[@"status"] boolValue];
                
                
                if ([self.way intValue] == 4) {
                    if ([self.type intValue] != 3){
                        self.laJiangV1.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"邀请首充：", nil), dic[@"num"]?:@"", Localized(@"人", nil)];
                    }
                }
                
                
                self.LingBtn1.userInteractionEnabled = [self.data[self.LingBtn1.tag][@"userId"] intValue] == [ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId intValue];
                
            } else if (i == 1) {
                
                self.LingBtn2.userInteractionEnabled = [self.data[self.LingBtn2.tag][@"userId"] intValue] == [ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId intValue];
                self.LingBtn2.hidden = self.LingBtn1.hidden;
                
                self.laNameV2.text = dic[@"name"];
                if ([self.type intValue] == 3){
                    self.laJiangV2.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"奖励：", nil), dic[@"reward"]?:@"", Localized(@"元", nil)];
                } else {
                    self.laJiangV2.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"距上名差：", nil), dic[@"distance"]?:@"", Localized(@"积分", nil)];
                }
                
                
                if ([self.way intValue] == 4) {
                    if ([self.type intValue] != 3){
                        self.laJiangV2.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"邀请首充：", nil), dic[@"num"]?:@"", Localized(@"人", nil)];
                    }
                }
                
                
                self.LingBtn2.selected = ![dic[@"status"] boolValue];
                [self.cv2 sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
            } else if (i == 2) {
                
                self.LingBtn3.userInteractionEnabled = [self.data[self.LingBtn3.tag][@"userId"] intValue] == [ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId intValue];
                
                self.LingBtn3.hidden = self.LingBtn1.hidden;
                self.laNameV3.text = dic[@"name"];
                if ([self.type intValue] == 3){
                    self.laJiangV3.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"奖励：", nil), dic[@"reward"]?:@"", Localized(@"元", nil)];
                } else {
                    self.laJiangV3.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"距上名差：", nil), dic[@"distance"]?:@"", Localized(@"积分", nil)];
                }
                self.LingBtn3.selected = ![dic[@"status"] boolValue];
                [self.cv3 sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
                
                
                if ([self.way intValue] == 4) {
                    if ([self.type intValue] != 3){
                        self.laJiangV3.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"邀请首充：", nil), dic[@"num"]?:@"", Localized(@"人", nil)];
                    }
                }
                
            }
            
            i ++;
        }
//        if (arr.count) {
            [weakself.tablview reloadData];
            [weakself.tablview.mj_footer endRefreshing];
            [weakself.tablview.mj_header endRefreshing];
//        } else {
//            [weakself.tablview.mj_footer endRefreshingWithNoMoreData];
//        }
        
        
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

    
    [self setupUI];
        
    kSelf;

//    self.tablview.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
//    
//        weakself.ML_Page ++;
//
//        [weakself giveML_getTypeHostsApi];
//    }];

    self.tablview.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakself.ML_Page = 1;
        [weakself giveML_getTypeHostsApi];
        
    }];
    
    [self.tablview.mj_header beginRefreshing];

}

-(void)setupUI{
    self.tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20*mHeightScale, ML_ScreenWidth, ML_ScreenHeight - 320*mHeightScale) style:UITableViewStylePlain];
    self.tablview.backgroundColor = UIColor.whiteColor;
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.layer.cornerRadius = 16*mHeightScale;
    self.tablview.layer.masksToBounds = YES;
    
    UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 48*mHeightScale)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*mWidthScale, 48*mHeightScale)];
    label1.text = @"排名";
    label1.textColor = kGetColor(@"aaa6ae");
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [tableHead addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60*mWidthScale, 0, 100*mWidthScale, 48*mHeightScale)];
    label2.text = @"用户ID";
    label2.textColor = kGetColor(@"aaa6ae");
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [tableHead addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(160*mWidthScale, 0, 150*mWidthScale, 48*mHeightScale)];
    if (self.way.intValue == 1) {
        label3.text = @"榜单奖励";
    }else{
        label3.text = @"邀请首充人数";
    }
    
    label3.textColor = kGetColor(@"aaa6ae");
    label3.font = [UIFont systemFontOfSize:12];
    label3.textAlignment = NSTextAlignmentCenter;
    [tableHead addSubview:label3];
    self.tablview.tableHeaderView = tableHead;
    
    [self.view addSubview:self.tablview];
}

- (void)imageViewAddTap:(UIGestureRecognizer *)gr
{
    NSInteger tag = gr.view.tag;
    if (tag < self.data.count) {
        NSDictionary *dic = self.data[tag];
        [self gotoInfoVC:[NSString stringWithFormat:@"%@", dic[@"userId"]]];
    }
}

- (void)LingBtnClick:(UIButton *)btn
{
    
    if (btn.tag >= self.data.count || btn.selected || self.isLing) {
        
        return;
    }
    if ([self.data[btn.tag][@"userId"] intValue] != [ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId intValue]) {
        
        return;
    }
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"id" : self.data[btn.tag][@"id"]} urlStr:@"top/receiveReward"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {


        if (btn.tag == 0) {
            
            self.LingBtn1.selected = YES;
        } else if (btn.tag == 1) {
            
            self.LingBtn2.selected = YES;
        } else if (btn.tag == 2) {
            
            self.LingBtn3.selected = YES;
        }
         weakself.isLing = YES;
        
    } error:^(MLNetworkResponse *response) {
        
        [weakself.tablview.mj_footer endRefreshing];
        [weakself.tablview.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakself.tablview.mj_footer endRefreshing];
        [weakself.tablview.mj_header endRefreshing];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
//    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __block ML_MeiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
      if(cell == nil) {
          cell =[[ML_MeiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
    cell.type = [self.type intValue];
    cell.way = [self.way intValue];
    cell.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
            cell.backView.backgroundColor = kGetColor(@"fff9da");
            cell.img.image = kGetImage(@"first");
            break;
        case 1:
            cell.backView.backgroundColor = kGetColor(@"eaeeff");
            cell.img.image = kGetImage(@"second");
            break;
        case 2:
            cell.backView.backgroundColor = kGetColor(@"ff5ea");
            cell.img.image = kGetImage(@"third");
            break;
        default:
            cell.backView.backgroundColor = kGetColor(@"f8f8f8");
            break;
    }

    cell.dict = self.data[indexPath.row];

    kSelf;

    [cell setClickcellCityButtonBlock:^(NSDictionary *dic) {

        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:weakself.data[cell.tag]];
        [muDic setObject:@(0) forKey:@"status"];
        [weakself.data replaceObjectAtIndex:cell.tag withObject:muDic];
        cell.dict = muDic;

        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath_1];
        [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];

    }];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
//    vc.dict = self.data[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
