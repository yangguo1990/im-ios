//
//  MLLoginDianxinWebViewController.m
//  miliao
//
//  Created by apple on 2022/11/12.
//

#import "MLLoginDianxinWebViewController.h"
#import <Masonry/Masonry.h>
#import "ML_SettingTableViewCell.h"
#import "MLLoginWebViewController.h"

@interface MLLoginDianxinWebViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong)NSArray *ML_celltitleArray;


@end

@implementation MLLoginDianxinWebViewController

-(NSArray *)ML_celltitleArray{
    if (_ML_celltitleArray == nil) {
            _ML_celltitleArray = @[@"天翼账号服务协议",@"天翼账号隐私政策"];
    }
    return _ML_celltitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.text = @"天翼账号服务协议与隐私政策";
    [self setupUI];
}

-(void)setupUI{
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tab];
    self.tab = tab;
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ML_celltitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ML_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
                if(!cell) {
                cell = [[ML_SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
               }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
    if (indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
    }
            return cell;
        }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
        vc.navtitle = @"天翼账号服务协议";
        vc.webhtml = Mldianxinacounttml;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
        vc.navtitle = @"天翼账号隐私政策";
        vc.webhtml = Mldianxinprivacytml;
        [self.navigationController pushViewController:vc animated:YES];
    }
  }



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

@end
