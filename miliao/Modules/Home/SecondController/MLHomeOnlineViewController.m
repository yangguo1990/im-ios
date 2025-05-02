//
//  MLHomeOnlineViewController.m
//  miliao
//
//  Created by apple on 2022/11/14.
//

#import "MLHomeOnlineViewController.h"
#define kPulseAnimation @"kPulseAnimation"
#import "MLOnlineMatchingHostListApi.h"
#import "MLHomeOnlineyuanViewcellCollectionViewCell.h"
#import "MLMyLayout.h"


@interface MLHomeOnlineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_onlinArray;
@property (nonatomic,strong)NSMutableArray *ML_onlinArray2;
@property (nonatomic,strong)NSDictionary *onlineDict;


@property (nonatomic,strong)UIImageView *viewbgimg;
@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UIImageView *oneimg;
@property (nonatomic,strong)UIImageView *twoimg;
@property (nonatomic,strong)UIImageView *threeimg;
@property (nonatomic,strong)UIImageView *img;

@property (nonatomic,strong)UIImageView *hostimg;
@property (nonatomic,strong)UIImageView *userimg;
@property (nonatomic,strong)UIImageView *xinimg;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *namelabel;

@property (nonatomic,strong)UILabel *errorlabel;
@property (nonatomic,strong)UIButton *bbtn;
@property (nonatomic,assign)BOOL isCall;
@end

@implementation MLHomeOnlineViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent; //白色
}

-(NSMutableArray *)ML_onlinArray{
    if (_ML_onlinArray == nil) {
        _ML_onlinArray = [NSMutableArray array];
    }
    return _ML_onlinArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isCall = NO;
    [self.view.layer removeAllAnimations];
    
}

-(void)giveMLOnlineMatchingHostListApi{
    MLOnlineMatchingHostListApi *api = [[MLOnlineMatchingHostListApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] limit:@"6"];
    
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        if (self.isCall) {
            self.ML_onlinArray = [NSMutableArray arrayWithArray:response.data[@"users"]];
            
//            NSDictionary *aDic = [self.ML_onlinArray lastObject];
            [self.img sd_setImageWithURL:kGetUrlPath([ML_AppUserInfoManager sharedManager].currentLoginUserData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
            
            
            if (self.ML_onlinArray.count > 0) {//匹配成功
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    if (self.isCall) {
                        [self test];
                    }
                });
                
            }else{
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self errortest];
                });
            }
            [self.ML_homeCollectionView reloadData];
        } else {
            kplaceToast(@"匹配已取消");
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCall = YES;
    self.isEnablePanGesture = NO;
    //onlinettbg
    self.ML_navView.backgroundColor = UIColor.clearColor;
//    self.ML_backBtn.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    UIImageView *viewbgimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 290*mHeightScale, ML_ScreenWidth, 522*mHeightScale)];
    viewbgimg.image = [UIImage imageNamed:@"bgCC"];
    viewbgimg.userInteractionEnabled = YES;
    [self.view addSubview:viewbgimg];
    self.viewbgimg = viewbgimg;

    UILabel *label = [[UILabel alloc]init];
    label.text = @"正在匹配中，请稍等...";
    label.textColor = [UIColor colorWithHexString:@"#e30bf5"];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    [viewbgimg addSubview:label];
    self.label = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewbgimg.mas_centerX);
        make.bottom.mas_equalTo(viewbgimg.mas_bottom).offset(-100);
    }];
    

    UIImageView *oneimg = [[UIImageView alloc]init];
    oneimg.image = [UIImage imageNamed:@"Ellipse 24"];
    oneimg.alpha = 1;
    [viewbgimg addSubview:oneimg];
    self.oneimg = oneimg;
    [oneimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.right.mas_equalTo(viewbgimg.mas_centerX).mas_offset(-50);
        make.bottom.mas_equalTo(viewbgimg.mas_bottom).mas_offset(-180);
    }];
    UIImageView *twoimg = [[UIImageView alloc]init];
    twoimg.image = [UIImage imageNamed:@"Ellipse 24"];
    twoimg.alpha = 1;
    [viewbgimg addSubview:twoimg];
    self.twoimg = twoimg;
    [twoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.right.mas_equalTo(viewbgimg.mas_centerX).mas_offset(-70);
        make.bottom.mas_equalTo(viewbgimg.mas_bottom).mas_offset(-210);
    }];

    UIImageView *threeimg = [[UIImageView alloc]init];
    threeimg.image = [UIImage imageNamed:@"Ellipse 24"];
    threeimg.alpha = 1;
    [viewbgimg addSubview:threeimg];
    self.threeimg = threeimg;
    [threeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(viewbgimg.mas_centerX).mas_offset(70);
        make.bottom.mas_equalTo(viewbgimg.mas_bottom).mas_offset(-200);
    }];

    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionRepeat animations:^{
           oneimg.alpha  = 0.0;
           twoimg.alpha = 0.0;
           threeimg.alpha = 0.0;
        } completion:^(BOOL finished) {
            oneimg.alpha  = 0.8;
            twoimg.alpha = 0.7;
            threeimg.alpha = 0.5;
            [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionRepeat animations:^{
                oneimg.alpha  = 1;
                twoimg.alpha = 1;
                threeimg.alpha = 1;
            } completion:^(BOOL finished) {
                oneimg.alpha  = 0.1;
                twoimg.alpha = 0.2;
                threeimg.alpha = 0.3;
            }];
    }];
    
    
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 138*mWidthScale, 138*mWidthScale)];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.center = CGPointMake(188*mWidthScale, 295*mHeightScale);
    self.img.layer.cornerRadius = self.img.bounds.size.width / 2;
    self.img.layer.masksToBounds = YES;
    [viewbgimg addSubview:self.img];
    
    [self waveAnimationLayerWithView:self.img diameter:180 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:250 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:300 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:350 duration:5];
    
    [self setupUI];
    
    [self giveMLOnlineMatchingHostListApi];
    
}

//匹配成功-------
-(void)test{
    NSLog(@"匹配成功");
    
    int r = arc4random() % [self.ML_onlinArray count];
    
    self.onlineDict = [self.ML_onlinArray objectAtIndex:r];

    self.oneimg.hidden = YES;
    self.twoimg.hidden = YES;
    self.threeimg.hidden = YES;
    self.img.hidden = YES;
    self.ML_homeCollectionView.hidden = YES;
    
    self.label.text = Localized(@"匹配成功，正在接通...", nil);
    
    self.hostimg = [[UIImageView alloc]init];
    self.hostimg.contentMode = UIViewContentModeScaleAspectFill;
    [self.hostimg sd_setImageWithURL:kGetUrlPath([ML_AppUserInfoManager sharedManager].currentLoginUserData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
    self.hostimg.layer.masksToBounds = YES;
    self.hostimg.layer.cornerRadius = 12;
    [self.viewbgimg addSubview:self.hostimg];
    [self.hostimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(136);
        make.height.mas_equalTo(142);
        make.right.mas_equalTo(self.viewbgimg.mas_centerX).mas_offset(-10);
        make.top.mas_equalTo(self.label.mas_top).mas_offset(-229);
    }];
    
    self.userimg = [[UIImageView alloc]init];
    self.userimg.contentMode = UIViewContentModeScaleAspectFill;
    [self.userimg sd_setImageWithURL:kGetUrlPath(self.onlineDict[@"icon"]) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
    self.userimg.layer.cornerRadius = 12;
    self.userimg.layer.masksToBounds = YES;
    [self.viewbgimg addSubview:self.userimg];
    [self.userimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(136);
        make.height.mas_equalTo(142);
        make.left.mas_equalTo(self.viewbgimg.mas_centerX).mas_offset(10);
        make.top.mas_equalTo(self.label.mas_top).mas_offset(-229);
    }];

    self.xinimg = [[UIImageView alloc]init];
    self.xinimg.contentMode = UIViewContentModeScaleAspectFill;
    self.xinimg.image = [UIImage imageNamed:@"Slicexin"];
    [self.viewbgimg addSubview:self.xinimg];
    [self.xinimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.centerX.mas_equalTo(self.viewbgimg.mas_centerX);
        make.centerY.mas_equalTo(self.hostimg.mas_centerY);
        
    }];
    
    UILabel *namelabel = [[UILabel alloc]init];
    namelabel.text = self.onlineDict[@"name"];
    namelabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    namelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.viewbgimg addSubview:namelabel];
    self.namelabel = namelabel;
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.viewbgimg.mas_centerX);
        make.top.mas_equalTo(self.userimg.mas_bottom).mas_offset(36);
    }];
    
    BOOL isAnimating = NO;
    NSArray *layerArr = [NSArray arrayWithArray:self.img.superview.layer.sublayers];
    for (CALayer *layer in layerArr) {
        if ([layer.animationKeys containsObject:kPulseAnimation]) {
            isAnimating = YES;
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
            [self um_onlineMatching];
            [self dismissViewControllerAnimated:NO completion:nil];

            [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@", self.onlineDict[@"userId"]] isCalled:NO];
//            [self gotoCallVCWithUserId:@"36061822" isCalled:NO type:NERtcCallTypeVideo];
        });
    });
    
}


- (void)um_onlineMatching {
      NSDictionary *eventParams = @{@"Um_Key_PageName":@"在线匹配",
                                    @"Um_Key_UserID":[NSString stringWithFormat:@"%@", self.onlineDict[@"userId"]],
                                    @"Um_Key_Type":@"1"
                                  };

//    [MobClick beginEvent:@"5124" primarykey:@"oneTouchChat" attributes:eventParams];
}



//匹配失败
-(void)errortest{

    self.label.text = Localized(@"在线匹配失败", nil);
    self.oneimg.hidden = YES;
    self.twoimg.hidden = YES;
    self.threeimg.hidden = YES;
    self.ML_homeCollectionView.hidden = YES;

    self.bbtn = [[UIButton alloc] init/*WithFrame:CGRectMake(ML_ScreenWidth / 2 - 50, CGRectGetMaxY(self.img.frame) + 70, 100, 35)*/];
    [self.bbtn setTitle:Localized(@"重新匹配", nil) forState:UIControlStateNormal];
    [self.bbtn addTarget:self action:@selector(chongxinbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bbtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.bbtn.backgroundColor = [UIColor whiteColor];
    self.bbtn.layer.cornerRadius = 18;
    self.bbtn.layer.masksToBounds = YES;
    self.bbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.viewbgimg addSubview:self.bbtn];
    [self.bbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.label.mas_top).mas_offset(-20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-100);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(100);
        make.height.mas_equalTo(36);
    }];
    
    BOOL isAnimating = NO;
    NSArray *layerArr = [NSArray arrayWithArray:self.img.superview.layer.sublayers];
    for (CALayer *layer in layerArr) {
        if ([layer.animationKeys containsObject:kPulseAnimation]) {
            isAnimating = YES;
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
}

- (void) chongxinbtnClick
{
    [self.errorlabel removeFromSuperview];
    [self.bbtn removeFromSuperview];
    
    self.label.text = Localized(@"正在匹配中，请稍等...", nil);
    self.oneimg.hidden = NO;
    self.twoimg.hidden = NO;
    self.threeimg.hidden = NO;

    self.ML_homeCollectionView.hidden = NO;
    
    self.threeimg.alpha = 1;
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionRepeat animations:^{
           self.oneimg.alpha  = 0.0;
        self.twoimg.alpha = 0.0;
        self.threeimg.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.oneimg.alpha  = 0.8;
            self.twoimg.alpha = 0.7;
            self.threeimg.alpha = 0.5;
            [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionRepeat animations:^{
                self.oneimg.alpha  = 1;
                self.twoimg.alpha = 1;
                self.threeimg.alpha = 1;
            } completion:^(BOOL finished) {
                self.oneimg.alpha  = 0.1;
                self.twoimg.alpha = 0.2;
                self.threeimg.alpha = 0.3;
            }];
    }];

    
    [self waveAnimationLayerWithView:self.img diameter:180 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:250 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:300 duration:5];
    [self waveAnimationLayerWithView:self.img diameter:350 duration:5];
    
    
    [self giveMLOnlineMatchingHostListApi];
}

-(void)backclick{
    self.isCall = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    MLMyLayout * layout = [[MLMyLayout alloc]init];
    self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
       //3、设置背景为白色
    self.ML_homeCollectionView.backgroundColor = [UIColor clearColor];
       //4、设置数据源代理
    self.ML_homeCollectionView.dataSource = self;
    self.ML_homeCollectionView.delegate = self;
    self.ML_homeCollectionView.center = self.view.center;
    self.ML_homeCollectionView.bounds = CGRectMake(0, 0, 320, 320);
    [self.ML_homeCollectionView registerClass:[MLHomeOnlineyuanViewcellCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
       //添加到视图中
       [self.view addSubview:self.ML_homeCollectionView];
       //注册Cell视图
      

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

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
    MLHomeOnlineyuanViewcellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[MLHomeOnlineyuanViewcellCollectionViewCell alloc]init];
        }
    //cell.dict = self.ML_onlinArray[indexPath.item];
    [cell.imageView sd_setImageWithURL:kGetUrlPath(self.ML_onlinArray[indexPath.row][@"icon"])];
        return cell;
}
//diameter 扩散的大小
- (CALayer *)waveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter duration:(CGFloat)duration {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    waveLayer.position = view.center;
    waveLayer.backgroundColor = [[UIColor colorWithRed:64 / 255.0 green:185 / 255.0 blue:216 / 255.0 alpha:1] CGColor];
    [view.superview.layer insertSublayer:waveLayer below:view.layer];//把扩散层放到播放按钮下面
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = INFINITY; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//    scaleAnimation.fromValue = @0.7; //开始的大小
//    scaleAnimation.toValue = @1.0; //最后的大小
        scaleAnimation.fromValue = @1; //开始的大小
        scaleAnimation.toValue = @3; //最后的大小
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.fromValue = @0.4; //开始的大小
//    opacityAnimation.toValue = @0.0; //最后的大小
        opacityAnimation.fromValue = @0.4; //开始的大小
        opacityAnimation.toValue = @0.0; //最后的大小
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:kPulseAnimation];
    
    return waveLayer;
}

- (void)modifyAnimationStatus:(UIButton *)button {
    BOOL isAnimating = NO;
    NSArray *layerArr = [NSArray arrayWithArray:button.superview.layer.sublayers];
    
    for (CALayer *layer in layerArr) {
        if ([layer.animationKeys containsObject:kPulseAnimation]) {
            isAnimating = YES;
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
    
    if (!isAnimating) {
        [self waveAnimationLayerWithView:self.button diameter:160 duration:2];
        [self waveAnimationLayerWithView:self.button diameter:115 duration:2];
    }
}

- (void)dealloc
{
    NSLog(@"====dealloc====HomeOnlineVC");
}

@end
