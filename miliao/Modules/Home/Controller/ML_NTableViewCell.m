//
//  ML_NTableViewCell.m
//  SiLiaoBack
//
//  Created by 密码：0000 on 2024/1/7.
//
#import "UIImage+ML.h"
#import "ML_NTableViewCell.h"
#import "ML_sayHelloApi.h"
#import "MLFocusApi.h"
@interface ML_NTableViewCell ()
@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)UILabel *distanc;
@property(nonatomic,strong)UIImageView *videoimg;
@end

@implementation ML_NTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}

- (void)setIssearch:(NSInteger)issearch{
    _issearch=issearch;
    if(issearch){
        [self.helloBt removeTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
        [self.helloBt addTarget:self action:@selector(guanzhuBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.helloBt setBackgroundImage:kGetImage(@"Cfollow_NO") forState:UIControlStateNormal];
        [self.helloBt setBackgroundImage:kGetImage(@"Cfollow") forState:UIControlStateSelected];
        if ([self.dic[@"focus"]boolValue]) {
            self.helloBt.selected = YES;
        }else{
            self.helloBt.selected = NO;
        }
    }else{
        [self.helloBt removeTarget:self action:@selector(guanzhuBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.helloBt addTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
        self.helloBt.selected = NO;
        [self.helloBt setBackgroundImage:kGetImage(@"helloBG") forState:UIControlStateNormal];
    }
}

- (void)setIsguanzhu:(NSInteger)isguanzhu{

}

- (void)initUI{
    //背景阴影
    UIView *backView=[[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    self.backview=backView;
    backView.backgroundColor=[UIColor clearColor];

    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(340*mWidthScale);
        make.height.mas_equalTo(90*mHeightScale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    //UI元素
    self.headIV = [[UIImageView alloc]init];
    self.headIV.layer.cornerRadius=18*mWidthScale;
    self.headIV.layer.masksToBounds=YES;
    [backView addSubview:self.headIV];
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8*mWidthScale);
        make.width.mas_equalTo(78*mWidthScale);
        make.height.mas_equalTo(78*mWidthScale);
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    
    
    self.isliveing = [[UIImageView alloc]initWithImage:kGetImage(@"isliveing")];
    [self.contentView addSubview:self.isliveing];
    [self.isliveing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
        make.left.mas_equalTo(self.headIV.mas_right).offset(10*mWidthScale);
        make.bottom.mas_equalTo(self.headIV.mas_bottom);
    }];
    
    self.videoimg = [[UIImageView alloc]initWithImage:kGetImage(@"videoimg")];
    [self.headIV addSubview:self.videoimg];
    [self.videoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.videoimg.hidden = YES;
    
    self.isking=[[UIImageView alloc]initWithImage:kGetImage(@"isking")];
    [self.headIV addSubview:self.isking];
    [self.isking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*mWidthScale);
        make.bottom.mas_equalTo(-10*mHeightScale);
        make.width.mas_equalTo(42*mWidthScale);
        make.height.mas_equalTo(12*mHeightScale);
    }];
    self.isking.hidden=YES;
    
    self.nickName=[[UILabel alloc]init];
    self.nickName.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    self.nickName.textColor=[UIColor colorWithHexString:@"#000000"];
    [backView addSubview:self.nickName];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIV.mas_right).offset(10*mWidthScale);
        make.top.mas_equalTo(self.headIV.mas_top);
        make.height.mas_equalTo(24*mHeightScale);
    }];
    self.nickName.text=@"阿双方都是借口借口v";
    
    self.isonline =[[UIImageView alloc]initWithImage:kGetImage(@"isonline")];
    [backView addSubview:self.isonline];
    [self.isonline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60*mWidthScale);
        make.top.mas_equalTo(self.headIV.mas_bottom).offset(-12*mHeightScale);
        make.width.mas_equalTo(32*mWidthScale);
        make.height.mas_equalTo(12*mHeightScale);
    }];
    
    
    
    
    self.ageBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
//    self.ageBt.backgroundColor=[UIColor colorWithHexString:@"FDE9F1"];
//    self.ageBt.layer.cornerRadius=8*mHeightScale;
    [backView addSubview:self.ageBt];
    [self.ageBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nickName.mas_centerY);
        make.width.mas_equalTo(16*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    
    
    self.isreal=[[UIImageView alloc]initWithImage:kGetImage(@"isreal")];
    [backView addSubview:self.isreal];
    [self.isreal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageBt.mas_right).offset(2);
        make.centerY.mas_equalTo(self.ageBt.mas_centerY);
        make.width.mas_equalTo(42*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    
//    [self.ageBt setImage:kGetImage(@"female") forState:UIControlStateNormal];
//    [self.ageBt setTitleColor:[UIColor colorWithHexString:@"ff458e"] forState:UIControlStateNormal];
    
    self.addressBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [self.addressBt setTitleColor:kGetColor(@"aaa6ae") forState:UIControlStateNormal];
    [backView addSubview:self.addressBt];
    [self.addressBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_left);
        make.top.mas_equalTo(self.nickName.mas_bottom);
        make.height.mas_equalTo(20*mHeightScale);
    }];

    self.addressBt.titleLabel.font=[UIFont systemFontOfSize:12];
    self.helloBt=[[UIButton alloc]initWithFrame:CGRectMake(100, 20, 80, 20)];
    [self.helloBt setBackgroundImage:kGetImage(@"helloBG") forState:UIControlStateNormal];
    [self.helloBt setBackgroundImage:kGetImage(@"icon_message_24") forState:UIControlStateSelected];
    [backView addSubview:self.helloBt];
    [self.helloBt addTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.helloBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10*mWidthScale);
        make.width.mas_equalTo(66*mWidthScale);
        make.height.mas_equalTo(28*mHeightScale);
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    self.dashanBt=[[UIButton alloc]initWithFrame:CGRectMake(100, 38, 80, 20)];
    [self.dashanBt setBackgroundImage:kGetImage(@"shipinBt") forState:UIControlStateNormal];
    [self.dashanBt addTarget:self action:@selector(shipinBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.dashanBt];
    [self.dashanBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10*mWidthScale);
        make.width.mas_equalTo(66*mWidthScale);
        make.height.mas_equalTo(28*mHeightScale);
        make.top.mas_equalTo(51*mHeightScale);
    }];
    self.dashanBt.hidden=YES;
    
}

- (void)shipinBtClick{
    [self gotoCallVCWithUserId:self.isId?self.dic[@"id"]:self.dic[@"userId"] isCalled:NO];
}
//搭讪
- (void)dashanBtClick{
    kSelf;
    if(!self.helloBt.selected){
        NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
        ML_sayHelloApi *api = [[ML_sayHelloApi alloc] initWithtoken:token toUserId:self.isId?self.dic[@"id"]:self.dic[@"userId"] extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"打招呼%@",response.data);
            kplaceToast(Localized(@"打招呼成功,可以给好友私信啦", nil));
            [SVProgressHUD dismiss];
            [weakself.dic setValue:@"1" forKey:@"call"];
            weakself.helloBt.selected = YES;
            //        btn.selected = !btn.selected;
            //        [btn removeFromSuperview];
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [self gotoChatVC:self.isId?self.dic[@"id"]:self.dic[@"userId"]];
    }
}
//关注
-(void)guanzhuBtClick:(UIButton*)button{
    if(!button.selected){
        [self giveMLFocusApi:@"1"];
    }else{
        UIAlertController *alercontroller=[UIAlertController alertControllerWithTitle:@"操作提示" message:@"确定不再关注此用户吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"不再关注" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self giveMLFocusApi:@"0"];
        }];
        [alercontroller addAction:cancel];
        [alercontroller addAction:sure];
        [[self findCurrentShowingViewController]presentViewController:alercontroller animated:YES completion:nil];
    }
}

- (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;

}



-(void)giveMLFocusApi:(NSString *)indexstr{
    MLFocusApi *api = [[MLFocusApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:self.isId?self.dic[@"id"]:self.dic[@"userId"] type:indexstr];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"关注接口----%@",response.data);
        if ([indexstr isEqualToString:@"1"]) {
            self.helloBt.selected = YES;
        }else{
            self.helloBt.selected = NO;
        }
//        [self.tablview reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

- (void)setDic:(NSDictionary *)dic{
    _dic=dic;
    if ([[dic objectForKey: @"coverType"]integerValue] == 0) {
        self.videoimg.hidden = YES;
//        self.playerLayer = nil;
//        [self.playerLayer removeFromSuperlayer];
//        self.playerItem = nil;
        [self.headIV sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        //[self.player pause];

    }else{
//        NSString *cover = dict[@"cover"];
        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";

        NSString *icon = [NSString stringWithFormat:@"%@%@", [dic objectForKey: @"cover"], dd];
        NSURL *ee = kGetUrlPath(icon);
        
        self.videoimg.hidden = NO;
        if ([[dic objectForKey: @"cover"] containsString:@".gif"]) {
            [self.headIV sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        } else {
            [self.headIV sd_setImageWithURL:ee placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        }
    }
    
    if ([[dic objectForKey: @"name"] isEqual:[NSNull null]]) {
        self.nickName.text = @"";
    }else{
        self.nickName.text = [dic objectForKey: @"name"];
    };
    
    if([dic[@"call"]intValue] == 0){
        self.helloBt.selected = NO;
    }else{
        self.helloBt.selected = YES;
    }
    
    if([dic[@"host"]intValue] == 1){
        self.isreal.hidden  = NO;
    }else{
        self.isreal.hidden  = YES;
    }
    
    //在线状态，0-离线 1-勿扰 2-在聊 3-在线
    //在线 空闲 忙碌
    if ([[dic objectForKey: @"online"]integerValue]  == 1) {
        self.isonline.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([[dic objectForKey: @"online"]integerValue]  == 2){
        self.isonline.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([[dic objectForKey: @"online"]integerValue]  == 3){
        self.isonline.image = kGetImage(@"label_online");
    } else {
        self.isonline.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    if([[dic objectForKey: @"gender"]integerValue] == 1){
        //男

        [self.ageBt setBackgroundImage:kGetImage(@"male") forState:UIControlStateNormal];

    }else{
        //女

        [self.ageBt setBackgroundImage:kGetImage(@"female") forState:UIControlStateNormal];

    }
    self.signLabel.text=[dic objectForKey: @"persionSign"];
    [self.headIV sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    if([dic objectForKey:@"city"]){
        
        [self.addressBt setTitle:[NSString stringWithFormat:@"%@岁|%@",[dic objectForKey:@"age"],[dic objectForKey:@"city"]] forState:UIControlStateNormal];
        if(dic[@"distance"]){
            [self.addressBt setTitle:[NSString stringWithFormat:@"%@岁|%@|%.2fkm",[dic objectForKey:@"age"],[dic objectForKey:@"city"],([dic[@"distance"]intValue]/1000.0)] forState:UIControlStateNormal];
        }
    }else{
        [self.addressBt setTitle:[NSString stringWithFormat:@"%@岁",[dic objectForKey:@"age"]] forState:UIControlStateNormal];
    }
    
    if(self.isdong){
        self.opretion.hidden =NO;
        NSDictionary *offlineAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: kGetColor(@"222222")};
        UIColor *offlineColor = [UIColor colorWithHexString:@"#FFE4D6" alpha:0.9];
        CGSize offlineSize = [[dic objectForKey:@"operation"] sizeWithAttributes:offlineAttr];
        CGSize nofflineSize = CGSizeMake(offlineSize.width+20, offlineSize.height);
        UIImage *image = [UIImage imageWithColor:offlineColor size: nofflineSize text:[dic objectForKey:@"operation"] textAttributes:offlineAttr corner:6];
        self.opretion.image = image;
    }else{
        self.opretion.hidden = YES;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
