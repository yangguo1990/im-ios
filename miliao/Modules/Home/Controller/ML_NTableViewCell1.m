//
//  ML_NTableViewCell.m
//  SiLiaoBack
//
//  Created by 密码：0000 on 2024/1/7.
//

#import "ML_NTableViewCell.h"
#import "ML_sayHelloApi.h"
#import "MLFocusApi.h"
#import "UIButton+ML.h"
#import "UIImage+ML.h"
@interface ML_NTableViewCell ()
@property(nonatomic,strong)UIView *backview;
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
//    _issearch=issearch;
//    if(issearch){
//        [self.helloBt removeTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.helloBt addTarget:self action:@selector(guanzhuBtClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.helloBt setBackgroundImage:kGetImage(@"Cfollow_NO") forState:UIControlStateNormal];
//        [self.helloBt setBackgroundImage:kGetImage(@"Cfollow") forState:UIControlStateSelected];
//    }else{
//        [self.helloBt removeTarget:self action:@selector(guanzhuBtClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.helloBt addTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
//        self.helloBt.selected = NO;
//        [self.helloBt setBackgroundImage:kGetImage(@"helloBG") forState:UIControlStateNormal];
//    }
}

- (void)setIsguanzhu:(NSInteger)isguanzhu{
//    _isguanzhu=isguanzhu;
//    if(isguanzhu){
//        [self.helloBt mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-10*mwidthscale);
//            make.width.mas_equalTo(66*mwidthscale);
//            make.height.mas_equalTo(28*mheightscale);
//            make.centerY.mas_equalTo(self.backview.mas_centerY).mas_offset(-18*mheightscale);
//        }];
//        self.dashanBt.hidden=NO;
//    }else{
//        [self.helloBt mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-10*mwidthscale);
//            make.width.mas_equalTo(66*mwidthscale);
//            make.height.mas_equalTo(28*mheightscale);
//            make.centerY.mas_equalTo(self.backview.mas_centerY);
//        }];
//        self.dashanBt.hidden=YES;
//    }
}

- (void)initUI{
    //背景阴影
    self.backgroundColor = [UIColor clearColor];
    UIView *backView=[[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    self.backview=backView;
    backView.backgroundColor=kGetColor(@"2c2c2f");
    backView.layer.cornerRadius=12;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor =kGetColor(@"424347").CGColor;
    backView.layer.borderWidth = 1;
//    backView.layer.shadowOpacity=0.3;
//    backView.layer.shadowOffset=CGSizeMake(-0.5, 0.5);
//    backView.layer.shadowColor= [UIColor colorWithHexString:@"C579E5"].CGColor;
//    backView.layer.shadowRadius=1.5;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28*mwidthscale);
        make.right.mas_equalTo(-16*mwidthscale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(92);
    }];
    //UI元素
    self.headIV = [[UIImageView alloc]init];
    self.headIV.layer.cornerRadius=10;
    self.headIV.layer.masksToBounds=YES;
    [self.contentView addSubview:self.headIV];
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mwidthscale);
        make.width.mas_equalTo(76*mwidthscale);
        make.height.mas_equalTo(76*mwidthscale);
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    self.isliveing = [[UIImageView alloc]initWithImage:kGetImage(@"isliveing")];
    [self.headIV addSubview:self.isliveing];
    [self.isliveing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    
    UIImageView *videoimg =[[UIImageView alloc]init];
    videoimg.image = [UIImage imageNamed:@"icon_shiping_36_nor"];
    [self.headIV addSubview:videoimg];
    self.videoimg = videoimg;
    [videoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(16);
    }];
    

    self.isking=[[UIImageView alloc]initWithImage:kGetImage(@"wangpaibo")];
    [self.headIV addSubview:self.isking];
    [self.isking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(48*mwidthscale);
        make.height.mas_equalTo(14*mheightscale);
    }];
    self.isking.hidden=YES;
    
    self.nickName=[[UILabel alloc]init];
    self.nickName.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    self.nickName.textColor=[UIColor colorWithHexString:@"#ffffff"];
    [backView addSubview:self.nickName];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(88*mwidthscale);
        make.top.mas_equalTo(self.headIV.mas_top);
        make.height.mas_equalTo(20*mheightscale);
    }];
    self.nickName.text=@"阿双方都是借口借口v";
    
    self.isonline =[[UIImageView alloc]initWithImage:kGetImage(@"label_online")];
    [backView addSubview:self.isonline];
    [self.isonline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_right).offset(10);
        make.centerY.mas_equalTo(self.nickName.mas_centerY);
        make.width.mas_equalTo(34*mwidthscale);
        make.height.mas_equalTo(14*mheightscale);
    }];
    
    self.opretion =[[UIImageView alloc]init];
//    self.opretion.layer.cornerRadius = 7*mheightscale;
//    self.opretion.layer.masksToBounds = YES;
//    self.opretion.backgroundColor = kGetColor(@"ffe95b");
//    self.opretion.textColor = kGetColor(@"333333");
//    self.opretion.font = [UIFont systemFontOfSize:14];
    [backView addSubview:self.opretion];
    [self.opretion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.isonline.mas_right).offset(10);
        make.centerY.mas_equalTo(self.nickName.mas_centerY);
        make.height.mas_equalTo(14*mheightscale);
    }];

    self.isreal=[[UIImageView alloc]initWithImage:kGetImage(@"tags_real_18")];
    [backView addSubview:self.isreal];
    [self.isreal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.width.mas_equalTo(42*mwidthscale);
        make.height.mas_equalTo(22*mheightscale);
    }];
    
    self.ageBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [backView addSubview:self.ageBt];
    [self.ageBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_left);
        make.top.mas_equalTo(self.nickName.mas_bottom).offset(10);
        make.width.mas_equalTo(39*mwidthscale);
        make.height.mas_equalTo(16*mheightscale);
    }];
    [self.ageBt setImage:kGetImage(@"female") forState:UIControlStateNormal];
    [self.ageBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ageBt.titleLabel.font=[UIFont systemFontOfSize:10];
    [self.ageBt setIconInLeftWithSpacing:3];
    
    self.addressBt=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.addressBt.backgroundColor=[UIColor colorWithHexString:@"414044"];
    self.addressBt.layer.cornerRadius=8*mheightscale;
    self.addressBt.layer.masksToBounds = YES;
    [backView addSubview:self.addressBt];
    [self.addressBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageBt.mas_right).offset(-10*mwidthscale);
        make.top.mas_equalTo(self.ageBt.mas_top);
        make.bottom.mas_equalTo(self.ageBt.mas_bottom);
    }];
    self.addressBt.textColor = [UIColor whiteColor];
    self.addressBt.font=[UIFont systemFontOfSize:10];
    [backView bringSubviewToFront:self.ageBt];
   
    
    self.signLabel=[[UILabel alloc]init];
    self.signLabel.textColor=[UIColor colorWithHexString:@"#a9a9ab"];
    self.signLabel.font=[UIFont systemFontOfSize:12];
    [backView addSubview:self.signLabel];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageBt.mas_left);
        make.top.mas_equalTo(self.addressBt.mas_bottom).offset(10);
        make.height.mas_equalTo(18*mheightscale);
        make.width.mas_equalTo(160);
    }];
    self.signLabel.text=@"废话都回复的客户翻江倒海风景";
    
    
    
    
    self.helloBt=[[UIButton alloc]initWithFrame:CGRectMake(100, 20, 80, 20)];
    [self.helloBt setBackgroundImage:kGetImage(@"icon_pick_up_24") forState:UIControlStateNormal];
    [self.helloBt setBackgroundImage:kGetImage(@"icon_message_24") forState:UIControlStateSelected];
    [backView addSubview:self.helloBt];
    [self.helloBt addTarget:self action:@selector(dashanBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.helloBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*mwidthscale);
        make.width.mas_equalTo(39*mwidthscale);
        make.height.mas_equalTo(21*mheightscale);
        make.top.mas_equalTo(26*mheightscale);
    }];
    
    
    self.dashanBt=[[UIButton alloc]initWithFrame:CGRectMake(100, 38, 80, 20)];
    [self.dashanBt setBackgroundImage:kGetImage(@"shipinBt") forState:UIControlStateNormal];
    [self.dashanBt addTarget:self action:@selector(shipinBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.dashanBt];
    [self.dashanBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*mwidthscale);
        make.width.mas_equalTo(39*mwidthscale);
        make.height.mas_equalTo(21*mheightscale);
        make.top.mas_equalTo(60*mheightscale);
    }];
}

//- (void)setIsdong:(BOOL)isdong{
//    _isdong = isdong;
//    if(isdong){
//        self.level.hidden = NO;
//    }else{
//        self.level.hidden = YES;
//    }
//}

- (void)shipinBtClick{
    if(self.isId){
        
        [self gotoCallVCWithUserId:self.dic[@"id"] isCalled:NO type:NERtcCallTypeVideo];
    }else{
        [self gotoCallVCWithUserId:self.dic[@"userId"] isCalled:NO type:NERtcCallTypeVideo];
    }
    
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
    
    /*
    //方法2：遍历方法
    while (1)
    {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            
        //} else if (vc.childViewControllers.count > 0) {
        //    //如果是普通控制器，找childViewControllers最后一个
        //    vc = [vc.childViewControllers lastObject];
        } else {
            break;
        }
    }
    return vc;
    //*/
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
        [self.isliveing sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        //[self.player pause];

    }else{
//        NSString *cover = dict[@"cover"];
        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";

        NSString *icon = [NSString stringWithFormat:@"%@%@", [dic objectForKey: @"cover"], dd];
        NSURL *ee = kGetUrlPath(icon);
        
        self.videoimg.hidden = NO;
        if ([[dic objectForKey: @"cover"] containsString:@".gif"]) {
            [self.isliveing sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"cover"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
        } else {
            [self.isliveing sd_setImageWithURL:ee placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
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
        [self.ageBt setBackgroundImage:kGetImage(@"label_male_18") forState:UIControlStateNormal];
        [self.ageBt setTitle:[[dic objectForKey: @"age"]stringValue] forState:UIControlStateNormal];
    }else{
        //女
        [self.ageBt setBackgroundImage:kGetImage(@"label_female_18") forState:UIControlStateNormal];
        [self.ageBt setTitle:[[dic objectForKey: @"age"]stringValue] forState:UIControlStateNormal];
    }
    if(!self.isdong){
        self.signLabel.text=[dic objectForKey: @"persionSign"];
    }else{
        self.signLabel.text=[dic objectForKey: @"interval"];
    }
    
    [self.headIV sd_setImageWithURL:kGetUrlPath([dic objectForKey: @"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    if(dic[@"city"]){
        double distance = [dic[@"distance"]doubleValue];
        NSString * citydis = [NSString stringWithFormat:@"   %@ | %.2fkm   ",dic[@"city"],distance/1000];
        self.addressBt.text = citydis;
    }else{
        self.addressBt.text = @"      ";
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

//- (void)setUsermodel:(ML_UserModel *)usermodel{
//    _usermodel=usermodel;
//    if ([usermodel.coverType integerValue] == 0) {
////        self.videoimg.hidden = YES;
////        self.playerLayer = nil;
////        [self.playerLayer removeFromSuperlayer];
////        self.playerItem = nil;
//        [self.isliveing sd_setImageWithURL:kGetUrlPath(usermodel.cover) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
//        //[self.player pause];
//
//    }else{
////        NSString *cover = dict[@"cover"];
//        NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";
//
//        NSString *icon = [NSString stringWithFormat:@"%@%@", usermodel.cover, dd];
//        NSURL *ee = kGetUrlPath(icon);
//
////        self.videoimg.hidden = YES;
//        if ([usermodel.cover containsString:@".gif"]) {
//            [self.isliveing sd_setImageWithURL:kGetUrlPath(usermodel.cover) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
//        } else {
//            [self.isliveing sd_setImageWithURL:ee placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
//        }
//    }
//
//    if ([usermodel.name isEqual:[NSNull null]]) {
//        self.nickName.text = @"";
//    }else{
//        self.nickName.text = usermodel.name;
//    };
//
//    //在线状态，0-离线 1-勿扰 2-在聊 3-在线
//    //在线 空闲 忙碌
//    if ([usermodel.online integerValue] == 1) {
//        self.isonline.image = AppDelegate.shareAppDelegate.busyImage;
//    }else if ([usermodel.online integerValue] == 2){
//        self.isonline.image = [UIImage imageNamed:@"Sliceliao52"];
//    }else if ([usermodel.online integerValue] == 3){
//        self.isonline.image = kGetImage(@"label_online");
//    } else {
//        self.isonline.image = AppDelegate.shareAppDelegate.offlineImage;
//    }
//    if(usermodel.gender.integerValue == 1){
//        //男
//        self.ageBt.backgroundColor=[UIColor colorWithHexString:@"edf6ff"];
//        [self.ageBt setImage:kGetImage(@"male") forState:UIControlStateNormal];
//        [self.ageBt setTitleColor:[UIColor colorWithHexString:@"4da6ff"] forState:UIControlStateNormal];
//        self.ageBt.titleLabel.font=[UIFont systemFontOfSize:12];
//        [self.ageBt setTitle:usermodel.age forState:UIControlStateNormal];
//    }else{
//        //女
//        self.ageBt.backgroundColor=[UIColor colorWithHexString:@"FDE9F1"];
//        [self.ageBt setImage:kGetImage(@"female") forState:UIControlStateNormal];
//        [self.ageBt setTitleColor:[UIColor colorWithHexString:@"ff458e"] forState:UIControlStateNormal];
//        self.ageBt.titleLabel.font=[UIFont systemFontOfSize:12];
//        [self.ageBt setTitle:usermodel.age forState:UIControlStateNormal];
//    }
//    self.signLabel.text=usermodel.persionSign;
//    [self.headIV sd_setImageWithURL:kGetUrlPath(usermodel.icon) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
//}
//

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
