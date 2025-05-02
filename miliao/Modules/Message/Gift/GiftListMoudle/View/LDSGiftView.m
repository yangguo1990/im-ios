//
//  LDSGiftView.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftView.h"
#import "LDSGiftCollectionViewCell.h"
#import "LDSGiftCellModel.h"
#import "LDSHorizontalLayout.h"
#import "UIButton+ML.h"
#import "ML_CustomMsgConvertModel.h"
#import "LDSGiftShowManager.h"
#import "LVRollingScreenView.h"
#import "LDSHorizontalLayout.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 判断是否是iPhone X
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX YES
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define Nav_Bar_HEIGHT (iPhoneX ? 88.f : 64.f)
// 导航+状态
#define Nav_Status_Height (STATUS_BAR_HEIGHT+Nav_Bar_HEIGHT)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//距离底部的间距
#define Bottom_Margin(margin) ((margin)+HOME_INDICATOR_HEIGHT)

static NSString *cellID = @"LDSGiftCollectionViewCell";

@interface LDSGiftView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 底部功能栏 */
@property(nonatomic,strong) UIView *bottomView;
/** 礼物显示 */
@property(nonatomic,strong) UICollectionView *collectionView;
/** ccb余额 */
@property(nonatomic,strong) UILabel *biLabel;
@property(nonatomic,strong) UIButton *chongBtn;
@property(nonatomic,strong) UIButton *topBtn;
@property(nonatomic,strong) UIButton *sendBtn;
@property(nonatomic,strong) UIView *xzBoView;
@property(nonatomic,strong) UIView *bLive1;
@property(nonatomic,strong) UIView *bLive2;
/** 上一次点击的model */
@property(nonatomic,strong) LDSGiftCellModel *preModel;
/** pagecontro */
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) UIView *countBgViwe;
@property(nonatomic,strong) NSArray *countArr;
@property(nonatomic,assign) NSInteger xuanItem;
@end

@implementation LDSGiftView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.countArr = @[@{@"ge" : @"1314", @"name" : Localized(@"一生一世", nil)}, @{@"ge" : @"520", @"name" : Localized(@"我爱你", nil)}, @{@"ge" : @"66", @"name" : Localized(@"一切顺利", nil)}, @{@"ge" : @"10", @"name" : Localized(@"十全十美", nil)}, @{@"ge" : @"1", @"name" : Localized(@"一心一意", nil)}];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaGiftCion) name:@"shuaGiftCion" object:nil];
        [self p_SetUI];
    }
    return self;
}

//-(void)shuaGiftCion
//{
//    [self setBiLabelChongFrame];
//}

- (void)bottomViewTap
{

}

- (void)topClickBtn:(UIButton *)btn
{
    self.topBtn.selected = NO;
    btn.selected = YES;
    self.topBtn = btn;
    
    if (btn.tag == 1) {
        self.bLive1.hidden = YES;
        self.bLive2.hidden = NO;
    } else {
        
        self.bLive1.hidden = NO;
        self.bLive2.hidden = YES;
    }
}

#pragma mark -设置UI
- (void)p_SetUI {
    
    UIView *bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height-Bottom_Margin(40+(kBottomSafeAreaHeight)), self.frame.size.width, Bottom_Margin(40+(kBottomSafeAreaHeight)))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTap)]];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
   
    CGFloat collH = 234;
    UIView *topView = [[UIView alloc] initWithFrame: CGRectMake(0, CGRectGetMinY(bottomView.frame)-collH - 46, self.frame.size.width, 66)];
    topView.layer.cornerRadius = 14;
    topView.layer.masksToBounds = YES;
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 46)];
    [btn1 setTitle:Localized(@"礼物", nil) forState:UIControlStateNormal];
    btn1.tag = 0;
    btn1.selected = YES;
    btn1.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]; // 字重
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(topClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn1];
    self.topBtn = btn1;
    
    
    UIView *b1V = [[UIView alloc] initWithFrame: CGRectMake((btn1.width - 20) / 2, btn1.height - 5, 20, 5)];
    b1V.backgroundColor = [UIColor blackColor];
    b1V.layer.cornerRadius = b1V.height / 2;
    [btn1 addSubview:b1V];
    self.bLive1 = b1V;
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame), 0, btn1.width, btn1.height)];
    [btn2 setTitle:@"背包" forState:UIControlStateNormal];
    btn2.tag = 1;
    btn2.hidden = YES;
    btn2.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]; // 字重
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(topClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn2];
    
    UIView *b2V = [[UIView alloc] initWithFrame: CGRectMake((btn1.width - 20) / 2, btn1.height - 5, 20, 5)];
    b2V.backgroundColor = [UIColor blackColor];
    b2V.layer.cornerRadius = b1V.height / 2;
    b2V.hidden = YES;
    [btn2 addSubview:b2V];
    self.bLive2 = b2V;
    
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0, 50, 343*mWidthScale, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [topView addSubview:lineView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(0, 0, ML_ScreenWidth, 20)];
    self.pageControl.currentPageIndicatorTintColor = kZhuColor;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"f0f1f5"];
    self.pageControl.hidden = YES;
    [bottomView addSubview:self.pageControl];
    
    UILabel *ccbLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 75, 20)];
    ccbLabel.text = Localized(@"剩余米币：", nil);
    ccbLabel.font = kGetFont(14);
    ccbLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:ccbLabel];
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    UILabel *biLabel = [UILabel new];
    biLabel.text = currentData.coin;
    biLabel.font = kGetFont(14);
    biLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:biLabel];
    [biLabel sizeToFit];
    CGRect frame = biLabel.frame;
    biLabel.frame = CGRectMake(CGRectGetMaxX(ccbLabel.frame), ccbLabel.y, frame.size.width+10, 20);
    self.biLabel = biLabel;
    
    UIButton *chongBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.biLabel.frame), self.biLabel.y, 70, self.biLabel.height)];
    [chongBtn setTitle:Localized(@"充值", nil) forState:UIControlStateNormal];
    chongBtn.titleLabel.font = kGetFont(14);
    [chongBtn setTitleColor:kGetColor(@"ff0000") forState:UIControlStateNormal];
    [chongBtn addTarget:self action:@selector(ML_ClickChongBtnBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:chongBtn];
    self.chongBtn = chongBtn;
    
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width - 100, ccbLabel.y-10, 80, 40)];
    [sendBtn setBackgroundColor:kZhuColor];
    sendBtn.titleLabel.font = kGetFont(14);
    sendBtn.layer.cornerRadius = 20;
    [sendBtn setTitle:Localized(@"赠送", nil) forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(ML_ClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn;
    
    UIView *xzBoView = [UIView new];
    xzBoView.backgroundColor = [UIColor whiteColor];
    xzBoView.layer.borderColor=kZhuColor.CGColor;
    xzBoView.layer.borderWidth=0.5;
    xzBoView.layer.cornerRadius = 20;
    [bottomView addSubview:xzBoView];
    [bottomView addSubview:sendBtn];
    self.xzBoView = xzBoView;
    
    UIButton *xzBtn = [UIButton new];
//    xzBtn.backgroundColor = [UIColor orangeColor];
    xzBtn.layer.cornerRadius = 20;
    [xzBtn setTitle:@"1" forState:UIControlStateNormal];
    [xzBtn setImage:kGetImage(@"acc_xia_gift") forState:UIControlStateNormal];
    [xzBtn setImage:kGetImage(@"acc_sh_gift") forState:UIControlStateSelected];
    [xzBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [xzBtn addTarget:self action:@selector(xzGiftCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [xzBtn sizeToFit];
    [xzBtn setIconInRightWithSpacing:10];
    CGRect frame2 = xzBtn.frame;
    xzBtn.frame = CGRectMake(10, 0, frame2.size.width + 30, sendBtn.height);
    [xzBoView addSubview:xzBtn];
    self.countBtn = xzBtn;
    
    self.xzBoView.frame = CGRectMake(sendBtn.x - xzBtn.width - 10, sendBtn.y, xzBtn.width + 40, sendBtn.height);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
    CGFloat itemW = 79*mWidthScale;
    CGFloat itemH = 96*mHeightScale;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
//    LDSHorizontalLayout *layout = [[LDSHorizontalLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)-20, ML_ScreenWidth, collH) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.contentSize = CGSizeMake((ML_ScreenWidth-32) * (self.dataArray.count / 8), 0);
    [collectionView registerClass:[LDSGiftCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
}

//- (CGSize)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *)indexPath
//{
//    CGSize size = CGSizeMake(ML_ScreenWidth / 4, 96);
//    return size;
//}
//
//- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex: (NSInteger)section
//{
//    return UIEdgeInsetsMake(15, 15, 5, 15); //  分别为上、左、下、右
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}

- (void)xzGiftCountBtnClick:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.collectionView.userInteractionEnabled = NO;
        self.chongBtn.userInteractionEnabled = NO;
        
        self.countBgViwe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - ML_TabbarHeight)];
        [self addSubview:self.countBgViwe];
        
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 140, 0, 150, 0)];
        view1.backgroundColor = [UIColor whiteColor];
        view1.layer.cornerRadius = 10;
        view1.layer.masksToBounds = YES;
        [self.countBgViwe addSubview:view1];
        
        int i = 0;
        for (NSDictionary *dic in self.countArr) {
            UIButton *countBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 40, view1.width, 40)];
            countBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [countBtn setTitle:[NSString stringWithFormat:@"    %@", dic[@"ge"]] forState:UIControlStateNormal];
            [countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [countBtn addTarget:self action:@selector(countSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:countBtn];
            countBtn.tag = i;
            
            UILabel *ccbLabel = [[UILabel alloc] initWithFrame:CGRectMake(view1.width / 2, 0, view1.width / 2, countBtn.height)];
            ccbLabel.text = dic[@"name"];
            ccbLabel.font = kGetFont(14);
            ccbLabel.textColor = [UIColor blackColor];
            ccbLabel.textAlignment = NSTextAlignmentLeft;
            [countBtn addSubview:ccbLabel];
            
            if (i == self.countArr.count - 1) {
                view1.frame = CGRectMake(ML_ScreenWidth - 160, self.countBgViwe.height - CGRectGetMaxY(countBtn.frame) - 5, 150, CGRectGetMaxY(countBtn.frame));
            }
            i++;
        }
    } else {
        [self.countBgViwe removeFromSuperview];
        self.countBgViwe = nil;
        self.chongBtn.userInteractionEnabled = YES;
        self.collectionView.userInteractionEnabled = YES;
        
    }
}

- (void)countSendBtnClick:(UIButton *) btn{
    
    self.countBtn.selected = NO;
    self.chongBtn.userInteractionEnabled = YES;
    self.collectionView.userInteractionEnabled = YES;
    
    NSDictionary *dic = self.countArr[btn.tag];
    [self.countBgViwe removeFromSuperview];
    self.countBgViwe = nil;
    
    [self.countBtn setTitle:dic[@"ge"] forState:UIControlStateNormal];
    [self.countBtn sizeToFit];
    [self.countBtn setIconInRightWithSpacing:10];
    CGRect frame2 = self.countBtn.frame;
    self.countBtn.frame = CGRectMake(10, 0, frame2.size.width + 30, self.sendBtn.height);
    self.xzBoView.frame = CGRectMake(self.sendBtn.x - self.countBtn.width - 10, self.sendBtn.y, self.countBtn.width + 40, self.sendBtn.height);
    
    
    NSLog(@"ge == %@", dic[@"ge"]);
}

- (void)ML_ClickChongBtnBtn
{
    [self gotoChongVC];
    [self hiddenGiftView];
}

- (void)setBiLabelChongFrame
{
   
    self.biLabel.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.coin;
    [self.biLabel sizeToFit];
    CGRect frame = self.biLabel.frame;
    self.biLabel.frame = CGRectMake(self.biLabel.x, 25, frame.size.width, 20);
    self.chongBtn.frame = CGRectMake(CGRectGetMaxX(self.biLabel.frame), self.biLabel.y, 50, self.biLabel.height);
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    
    if (!dataArray.count) {
        
        if (self.topBtn.tag == 1) {
        
        } else {
            
            [SVProgressHUD showWithStatus:Localized(@"礼物数据加载中...", nil)];
            
            // 礼物列表
            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"im/getGifts"];
            kSelf;
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                
                
                [SVProgressHUD dismiss];
                
                NSMutableArray *muArr = [NSMutableArray array];
                
                for (NSDictionary *dic in response.data[@"gifts"]) {
                    LDSGiftCellModel *gift = [LDSGiftCellModel mj_objectWithKeyValues:dic];
                    [muArr addObject:gift];
                }
                [ML_AppConfig sharedManager].giftArr = muArr;
                
                NSArray *giftArr = [ML_AppConfig sharedManager].giftArr;
                weakself.dataArray = giftArr;
                
                [weakself showGiftView];
                
            } error:^(MLNetworkResponse *response) {
                
                [SVProgressHUD dismiss];
                
            } failure:^(NSError *error) {
                
                [SVProgressHUD dismiss];
                
            }];
        }
    } else {
        
        _dataArray = nil;
        
        if (self.topBtn.tag == 1) {
        
        } else {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[ML_AppConfig sharedManager].giftArr];
            for (LDSGiftCellModel *model in arr) {
                model.isSelected = NO;
            }
            _dataArray = arr;
        }
    }

    self.pageControl.numberOfPages = (dataArray.count-1)/8+1;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden =  !((dataArray.count-1)/8);
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LDSGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    if (indexPath.item < self.dataArray.count) {
        LDSGiftCellModel *model = self.dataArray[indexPath.item];
    
        model.isSelected = (indexPath.row == self.xuanItem);
    
        cell.model = model;
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.xuanItem = indexPath.row;
    
    if (indexPath.row < self.dataArray.count) {
        self.preModel.isSelected = NO;
        LDSGiftCellModel *model = self.dataArray[indexPath.row];
        model.isSelected = YES;
        if ([self.preModel isEqual:model]) {
//            [collectionView reloadData];
        }else {
//            self.preModel.isSelected = NO;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }];

        }
        self.preModel = model;
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    self.pageControl.currentPage = x/SCREEN_WIDTH+0.5;

}

#pragma mark -发送
- (void)ML_ClickSendBtn {
    
    __block LDSGiftCellModel *theModel = nil;
    //找到已选中的礼物
    BOOL isBack = NO;
    for (LDSGiftCellModel *model in self.dataArray) {
        if (model.isSelected) {
            isBack = YES;
            theModel = model;
//            if ([self.delegate respondsToSelector:@selector(giftViewSendGiftInView:data:)]) {
//                [self.delegate giftViewSendGiftInView:self data:model];
//            }
        }
    }
    if (!isBack) {
        //提示选择礼物
        NSLog(@"没有选择礼物");
//        return;
        if (self.dataArray.count) {
            theModel = [self.dataArray firstObject];
        }
    }
    UserInfoData * userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    if ([userData.coin integerValue] < ([[self.countBtn currentTitle] integerValue] * [theModel.coin integerValue])) {
        
        ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
        tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : @"余额不足，请充值！"};
//        PNSToast([UIViewController topShowViewController].view, @"余额不足", 1.0);
        [self hiddenGiftView];
        return;
    }

    
    LDSGiftModel *giftModel = [[LDSGiftModel alloc] init];
    giftModel.userIcon = theModel.icon;
    giftModel.userName = self.userName;
    giftModel.giftName = theModel.name;
    giftModel.giftImage = theModel.icon;
    giftModel.giftGifImage = theModel.icon_gif;
    giftModel.giftId = theModel.ID;
    giftModel.defaultCount = 0;
    giftModel.sendCount = [[self.countBtn currentTitle] integerValue];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.userId?:@"", @"giftId" : theModel.ID, @"type" : self.giveType, @"relationId" : self.relationId?:@"", @"num" : [self.countBtn currentTitle]} urlStr:@"im/giveGift"];
    
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
         
         
             UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
             currentData.coin = [NSString stringWithFormat:@"%ld", [response.data[@"restCoin"] integerValue]];
             [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
  
         weakself.biLabel.text = currentData.coin;
         
         [weakself sendGiftMsg:theModel];
         
         [[LDSGiftShowManager shareInstance] showGiftViewWithBackView:[UIViewController topShowViewController].view info:giftModel completeBlock:^(BOOL finished) {
             //结束
         }];

         if (giftModel.giftGifImage.length) {
             [weakself hiddenGiftView];
             [[LVRollingScreenView sharedRollingScreenView] startShowGiftViewWithBigGiftModel:giftModel];
         }

     } error:^(MLNetworkResponse *response) {

     } failure:^(NSError *error) {
         
     }];
    
    
}

- (void)sendGiftMsg:(LDSGiftCellModel *)theModel
{
    
    
    NIMMessage * message =  [ML_CustomMsgConvertModel msgWithGiftModel:theModel toUserId:self.userId?:@"" withScene:LVChatSceneP2P withCount:[[self.countBtn currentTitle] integerValue] withAnimateType:theModel.type mutiCount:1];
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.scene = NIMNOSSceneTypeMessage;
    setting.shouldBeCounted = YES;
    message.setting = setting;
    message.env = [[NSUserDefaults standardUserDefaults] objectForKey:@"nim_test_msg_env"];
    
    NSError * error = nil;
    NIMSession * session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:&error];
    
    if(error){
        NSString * msg = [NSString stringWithFormat:@"赠送%@失败", theModel.name];
        PNSToast([UIViewController topShowViewController].view, msg, 1.0);
        return;
    }else{
        UserInfoData * userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        userData.activeCoin = [NSString stringWithFormat:@"%ld", [userData.activeCoin integerValue] - [theModel.coin integerValue]];
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
        
        if ([self.delegate respondsToSelector:@selector(giftViewSendGiftInView:data:)]) {
            [self.delegate giftViewSendGiftInView:self data:theModel];
        }
    }
}

- (void)showGiftView {
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    self.biLabel.text = currentData.coin;
    
    if ([self.userId isEqualToString:[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]) {
        PNSToast([UIViewController topShowViewController].view, @"不能送给自己", 1.0);
    } else {
        
        self.countBtn.selected = NO;
        self.chongBtn.userInteractionEnabled = YES;
        self.collectionView.userInteractionEnabled = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            
            self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
        }];
    }
}

- (void)hiddenGiftView {
    
    self.backgroundColor = [UIColor clearColor];
    [self.countBgViwe removeFromSuperview];
    self.countBgViwe = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.countBgViwe) {
        
        [self hiddenGiftView];
    }
}

@end

