//
//  NECallViewController.m
//  NERtcCallKit
//
//  Created by I am Groot on 2020/8/21.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "NECallViewController.h"
#import "NECustomButton.h"
#import "NEVideoOperationView.h"
#import <Toast/UIView+Toast.h>
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "NTESDemoConfig.h"
#import "LDSGiftView.h"
#import "LDSGiftCellModel.h"
#import "LDSGiftModel.h"
#import "LDSGiftShowManager.h"
#import "LVRollingScreenView.h"
#import "UIButton+ML.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "NTESTimerHolder.h"
#import "FUManager.h"
#import "UIImage+ML.h"
#import "IQKeyboardManager.h"
//#import "FUCamera.h"
//#import "NIMKitUrlManager.h"
//#import "authpack.h"

@interface NECallViewController ()<NERtcCallKitDelegate,NEVideoViewDelegate, LDSGiftViewDelegate,NERtcEngineDelegateEx, NERtcEngineDelegateEx, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong,nonatomic)NEVideoView *smallVideoView;
@property(strong,nonatomic)NEVideoView *bigVideoView;
@property(strong,nonatomic)UIImageView *remoteAvatorView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *subTitleLabel;
@property(strong,nonatomic)UIButton *switchCameraBtn;
@property(strong,nonatomic)UIButton *hangupBtn;
/// 取消呼叫
@property(strong,nonatomic)NECustomButton *cancelBtn;
/// 拒绝接听
@property(strong,nonatomic)NECustomButton *rejectBtn;
/// 接听
@property(strong,nonatomic)NECustomButton *acceptBtn;
@property(strong,nonatomic)NEVideoOperationView *operationView;
@property(assign,nonatomic)NERtcCallType type;
@property(assign,nonatomic)NERtcCallStatus status;
/// 对方账号
@property(strong,nonatomic)NSString *otherUserID;
/// 自己账号
@property(strong,nonatomic)NSString *myselfID;
@property(strong,nonatomic)NSString *callLogId;
@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音
@property (nonatomic, assign) BOOL isJujue;
@property (nonatomic,assign) NSInteger statsCount; // 计算网络统计次数，前3次产生误差，忽略
@property (nonatomic,strong) UILabel *statsLabel; // 显示网络异常状态
@property (nonatomic,strong) UILabel *connectingLabel; // 显示正在接通
@property (nonatomic,assign) BOOL isCalled;
@property (nonatomic,strong)NERtcCallKitJoinChannelEvent *event;
@property (nonatomic,strong) UILabel *durationLabel;
@property (nonatomic,strong) UILabel *chargeStandardV;
@property (nonatomic, strong) dispatch_source_t timer;
@property(nonatomic,strong) LDSGiftView *giftView;
@property (nonatomic,strong) UIButton *gitfButton;
@property (nonatomic,strong) UIButton *biBtn;
@property (nonatomic,strong) UIButton *sheBtn;
@property (nonatomic,strong) UIImageView *avV;
@property (nonatomic,strong) UIImageView *avVBg;
@property (nonatomic,strong) UIImageView *bigImg;
@property (nonatomic,strong) UILabel *qianV;
@property (nonatomic,strong) UIButton *agebtn;
@property (nonatomic,strong) UIButton *dizhiBtn;
@property (nonatomic,strong) UIButton *nameBtn;
@property (nonatomic,strong) SelVideoPlayer *ttplayer;
@property (nonatomic,strong) NSString *skill_video;
@property (nonatomic,strong) UIButton *sysBtn;
@property (nonatomic,strong) UIView *sendView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *tabV;
@property (nonatomic,strong) NSMutableArray *tabVListArr;
@property (strong, nonatomic)UIButton *chatBtn;
@property (strong, nonatomic)UIImageView *img_bg;

//上个页面传过来的参数
@property (nonatomic, copy) NSString *roomId;  //房间ID
@property (nonatomic, assign) uint64_t userId; //本人uid

//Demo的 canvas 模型，包括uid 和 container, 用来建立sdk canvas
//@property (nonatomic, strong) NTESDemoUserModel *localCanvas;  //本地
//@property (nonatomic, strong) NTESDemoUserModel *remoteCanvas; //远端
@property (nonatomic, assign)NSInteger durationDesc;
/** 外部设备采集 */
//@property(nonatomic, strong) FUCaptureCamera *mCamera;
//@property(nonatomic, strong) FUDemoManager *demoManager;
//@property (nonatomic,strong)FUBaseViewControllerManager *basemanger;
//@property (nonatomic,strong)FULocalDataManager *localdatamage;
//@property (nonatomic,strong)FUManager *fumange;

//@property (nonatomic,strong)UIImageView *piPeibgView;
@property (nonatomic,strong)UIView *lupinmaskView;
@end

@implementation NECallViewController


#pragma mark - JPSuspensionEntranceProtocol

- (BOOL)jp_isHideNavigationBar {
    return YES;
}

//- (NSString *)jp_suspensionCacheMsg {
//    return nil;
//}
//
//- (UIImage *)jp_suspensionLogoImage {
//    return [UIImage imageNamed:@"Ellipse 24"];
//}

- (void)jp_requestSuspensionLogoImageWithLogoView:(UIImageView *)logoView {

    NEVideoView *bigVideoView = [[NEVideoView alloc] initWithFrame:logoView.bounds];
    [logoView addSubview:bigVideoView];
    
    [self setupRemoteView:bigVideoView forUser:self.otherUserID];
}


- (instancetype)initWithOtherMember:(NSString *)member isCalled:(BOOL)isCalled type:(NERtcCallType)type {
    self = [super init];
    if (self) {
        [self.navigationController setNavigationBarHidden:YES];
        
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.isCalled = isCalled;
        if (isCalled) {
            self.status = NERtcCallStatusCalled;
        }else {
            self.status = NERtcCallStatusCalling;
        }
        self.type = type;
        self.otherUserID = member;
        self.myselfID = [NIMSDK sharedSDK].loginManager.currentAccount;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    
      [[IQKeyboardManager sharedManager] setEnable:NO];
      [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
      [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    JPSEInstance.suspensionView = nil;
    [self setupRemoteView:self.smallVideoView.videoView forUser:self.otherUserID];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
      [[IQKeyboardManager sharedManager] setEnable:YES];
      [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
      [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
//    [self.mCamera resetFocusAndExposureModes];
//    [self.mCamera stopCapture];
    /* 清一下信息，防止快速切换有人脸信息缓存 */
//    [[FUManager shareManager] onCameraChange];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
}
// 在键盘将要出现时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘的高度
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sendView.hidden = NO;
        self.sendView.frame = CGRectMake(0, ML_ScreenHeight - keyboardHeight - 60, ML_ScreenWidth, 60);
    } completion:^(BOOL finished) {
        
    }];
    
    // 在此处执行你希望在键盘出现时执行的操作
    NSLog(@"键盘将要出现，高度为%f", keyboardHeight);
    
}

// 在键盘将要隐藏时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    // 在此处执行你希望在键盘隐藏时执行的操作
    NSLog(@"键盘将要隐藏");
    self.sendView.hidden = YES;
}

- (void)jieMsg:(NSNotification *)notification {

    NSArray *arr = notification.object;
    
    for (NIMMessage *msg in arr) {
        if ([msg.from integerValue] == [self.otherUserID integerValue] && msg.text.length) {
            NSDictionary *dataDic = self.response.data;
            NSDictionary *dic2 = dataDic[@"otherInfo"];
                    
            [self.tabVListArr addObject:[NSString stringWithFormat:@"%@：%@", dic2[@"name"], msg.text]];
            [self.tabV reloadData];
            // 滚动到最后一行
            NSInteger numberOfRows = [self.tabV numberOfRowsInSection:0];
            if (numberOfRows > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                [self.tabV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jieMsg:) name:@"jieMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self addluPinNotifacation];

    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    [self setupSDK];
    [self updateUIStatus:self.status];
    if (!self.autoJie) {
        [self.player play];
        
    } else {
        
        [self acceptEvent:_acceptBtn];
    }
    
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tichuRoom:) name:@"tichuRoom" object:nil];


    
    if (self.type == NERtcCallTypeVideo) {
    
        //象芯
        [[FUManager shareManager] loadFilter];
        [[FUManager shareManager] setAsyncTrackFaceEnable:NO];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程

//        [self.mCamera startCapture];
    });
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return NO;
}

- (void)suspension {
    
      [[IQKeyboardManager sharedManager] setEnable:YES];
      [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
      [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [JPSEInstance popViewController:self];
}

- (void)onNERtcEngineVideoFrameCaptured:(CVPixelBufferRef)bufferRef rotation:(NERtcVideoRotationType)rotation {

    fuSetDefaultRotationMode(3);
    [[FUManager shareManager] renderItemsToPixelBuffer:bufferRef];
    NSLog(@"asdf==onNERtcEngineVideoFrameCaptured");
    
}

- (void)tichuRoom:(NSNotification *)nt
{
    WEAK_SELF(weakSelf);
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
        STRONG_SELF(strongSelf);
        strongSelf.acceptBtn.enabled = YES;
        [strongSelf destroy];
    }];
    
    

    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"login/logout"];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {
        
    }];
    
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
     {
         extern NSString *NTESNotificationLogout;
         [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    }];
        
    
}

- (void)initTimer
{
    
    __block NSInteger count = 0;
     //创建队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置定时器时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    //设置回调
    kSelf;
    dispatch_source_set_event_handler(self.timer, ^{
        //重复执行的事件
        count++;
        
        NSInteger shi = count / 3600;
        NSInteger fen = count / 60;
        NSInteger miao = count % 60;
        
        weakself.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", shi, fen, miao];
        if (miao == 57) {
            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.otherUserID, @"channelId" : [NSString stringWithFormat:@"%llu", weakself.event.cid], @"channelName" : self.event.cname?:@"", @"isNotSend" : @(![ML_AppUtil isCensor])} urlStr:@"im/inCall"];
            
            kSelf;
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                
                NSDictionary *dic = response.data;
                if ([dic[@"mind"] boolValue] && [ML_AppUtil isCensor]) {
                    
                        NSString *toast = [NSString stringWithFormat:@"预计当前金额可通话剩余不足%@分钟，是否去充值？", dic[@"rest"]];
                    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
                    tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : toast};

                }
                
                
                if ([response.status intValue] == 106 && [ML_AppUtil isCensor]) {
                    
                    kSelf2;
                    if (weakself.timer) {
                        dispatch_source_cancel(weakself.timer); // 取消定时器
                    }
                    
                    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
                        [weakself2 destroy];
                    }];
                    
                    NSString *str = response.msg;
                    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
                    tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : str?:@"余额不足，请充值！"};
                    
                }
                
                [ML_AppUserInfoManager shuaWithCoin:[NSString stringWithFormat:@"%@", self.response.data[@"standard"]]];
                
            } error:^(MLNetworkResponse *response) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    });
    
    dispatch_resume(self.timer);
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player stop];
}
#pragma mark - SDK
- (void)setupSDK {
    
    //呼叫组件设置rtc代理中转
    [NERtcCallKit sharedInstance].engineDelegate = self;
    
    NERtcEngine *coreEngine = [NERtcEngine sharedEngine];
     // 美颜设置
    NSDictionary *params = @{
        kNERtcKeyVideoCaptureObserverEnabled: @YES  // 开启视频数据采集回调
    };
    [coreEngine setParameters:params];
    
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [NERtcCallKit sharedInstance].timeOutSeconds = 30;
    if (self.status == NERtcCallStatusCalling) {
        WEAK_SELF(weakSelf);
        NSLog(@"CallVC: Start call: %@", self.otherUserID);
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"call": @"testValue"} options:0 error:nil];
        NSString *attachment = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [NERtcCallKit.sharedInstance call:self.otherUserID
//                                     type:self.type
//                               attachment:attachment
//                               completion:^(NSError * _Nullable error) {
//            STRONG_SELF(strongSelf);
//            [self setupLocalView];
//            if (error) {
//                [strongSelf.view makeToast:error.localizedDescription];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [strongSelf destroy];
//                });
//            }
//        }];
        
        [NERtcCallKit.sharedInstance call:self.otherUserID type:self.type attachment:attachment globalExtra:nil withToken:nil channelName:[self ML_GetUniqueDeviceIdentifierAsString] completion:^(NSError * _Nullable error) {
                   
            STRONG_SELF(strongSelf);
            [weakSelf setupLocalView];
            if (error) {
                [strongSelf.view makeToast:error.localizedDescription];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf destroy];
                });
            }
            
        }];
    }
    
}


#pragma mark - 消息发送时间截获
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if (error) {
        switch (error.code) {
            case 20000:
            {
                kplaceToast(Localized(@"参数非法！", nil));
                break;
            }
            case 20001:
            {
                kplaceToast(Localized(@"您的账户被封禁！", nil));
                break;
            }
            case 20002:
            {
                kplaceToast(Localized(@"对方账户被封禁！", nil));
                break;
            }
            case 20003:
            {
                kplaceToast(Localized(@"对方账号已注销！", nil));
                break;
            }
            case 20004:
            {
                kplaceToast(Localized(@"您没有IM权限！", nil));
                break;
            }
            case 20005:
            {
                kplaceToast(Localized(@"对方没有IM权限！", nil));
                break;
            }
            case 20006:
            {
                kplaceToast(Localized(@"你已被对方拉黑！", nil));
                break;
            }
            case 20007:
            {
                kplaceToast(Localized(@"对方已被你拉黑！", nil));
                break;
            }
            case 20008:
            {
                kplaceToast(Localized(@"对方已开启勿扰！", nil));
                break;
            }
            case 20009:
            {
                kplaceToast(Localized(@"身份相同，不能相互通信！", nil));
                break;
            }
            case 20010:
            {
                kplaceToast(Localized(@"主播与主播不能相互通信！", nil));
                break;
            }
            case 20011:
            {
                kplaceToast(Localized(@"消息内容不能为空！", nil));
                break;
            }
            case 20012:
            {
                kplaceToast(Localized(@"消息涉嫌违规，无法发送！", nil));
                break;
            }
            case 20013:
            {
                kplaceToast(Localized(@"今日免费额度用尽！", nil));
                break;
            }
            case 20014:
            {
                kplaceToast(Localized(@"金币不足，无法发送！", nil));
                break;
            }
            case 20015:
            {
                kplaceToast(Localized(@"不支持消息类型！", nil));
                break;
            }
            case 20016:
            {
                kplaceToast(Localized(@"不支持回调类型！", nil));
                break;
            }
            case 20017:
            {
                kplaceToast(Localized(@"请先关闭勿扰模式才能发消息！", nil));
                break;
            }
            case 20018:
            {
                kplaceToast(Localized(@"需要对方回复才能再次发起消息！", nil));
                break;
            }
            default:
                break;
        }
        NSLog(@"发送结果报错 =======%@", error);
    }

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // 隐藏键盘
    
    if (!textField.text.length) {
        return NO;
    }
    
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.otherUserID, @"type" : @"2", @"message" : textField.text?:@""} urlStr:@"im/imPre"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        
        NIMMessage *message = [[NIMMessage alloc] init];
        message.text = textField.text;
        kSelf2;
        NSError * error = nil;
        // @"15198698"
        NIMSession * session = [NIMSession session:weakself.otherUserID type:NIMSessionTypeP2P];
        [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:&error];
        if(error){
            PNSToast([UIViewController topShowViewController].view, Localized(@"发送失败", nil), 1.0);
        } else {

            [weakself2.tabVListArr addObject:[NSString stringWithFormat:@"%@：%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.name, message.text]];
            [weakself2.tabV reloadData];
            // 滚动到最后一行
            NSInteger numberOfRows = [weakself2.tabV numberOfRowsInSection:0];
            if (numberOfRows > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                [weakself2.tabV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        
        textField.text = nil;
        
    } error:^(MLNetworkResponse *response) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
    } failure:^(NSError *error) {

    }];
    
    
    return YES;
}

- (void)chatBtnClick
{
    [self.textField becomeFirstResponder];
    self.sendView.hidden = NO;
    
}

#pragma mark - UI
- (void)setupUI {
//    UITextField *backTf=[[UITextField alloc]initWithFrame:self.view.bounds];
//    backTf.secureTextEntry = YES;
//    [self.view addSubview:backTf];
//    [backTf.subviews.firstObject addSubview:self.bigVideoView];
    
    [self.view addSubview:self.bigVideoView];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.bigVideoView.frame = self.view.bounds;
//    [self.bigVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(0);
//        make.size.mas_equalTo([UIScreen mainScreen].bounds.size);
//    }];
    
    
    
    UIButton *sysBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, statusHeight + 20, 30, 30)];
    sysBtn.hidden = YES;
    [sysBtn setImage:kGetImage(@"video_icon_minimized") forState:UIControlStateNormal];
    [sysBtn addTarget:self action:@selector(suspension) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sysBtn];
    self.sysBtn = sysBtn;
    
    CGFloat iH = ML_ScreenWidth * 110 / 375;
    UIImageView *img_bg = [[UIImageView alloc] initWithImage:kGetImage(@"background")];
    img_bg.hidden = YES;
    img_bg.frame = CGRectMake(0, ML_ScreenHeight - iH, ML_ScreenWidth, iH);
    [self.view addSubview:img_bg];
    self.img_bg = img_bg;
    
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, ML_ScreenHeight - 20 - 48, 48, 48)];
    chatBtn.hidden = YES;
    [chatBtn setImage:kGetImage(@"icon_chat_bg_t") forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatBtn];
    self.chatBtn = chatBtn;
    
    
    _gitfButton = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 44 - 48, chatBtn.y, chatBtn.width, chatBtn.height)];
    _gitfButton.hidden = YES;
    _gitfButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
    [_gitfButton addTarget:self action:@selector(giftbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_gitfButton setImage:kGetImage(@"icon_liwu_66_nor") forState:UIControlStateNormal];
    _gitfButton.tag = 3;
    [self.view addSubview:_gitfButton];
    
    UIButton *biBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 24 - 60, ML_ScreenHeight - 290, 60, 90)];
    biBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
    [biBtn addTarget:self action:@selector(microPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [biBtn setImage:kGetImage(@"icon_maikefengyiguan_66_sel") forState:UIControlStateSelected];
    [biBtn setImage:[UIImage imageNamed:@"icon_maikefengyikai_66_nor"] forState:UIControlStateNormal];
    biBtn.tag = 3;
    biBtn.hidden = YES;
    [self.view addSubview:biBtn];
    self.biBtn = biBtn;
    UILabel *biLV = [[UILabel alloc] initWithFrame:CGRectMake(-15, 60, biBtn.width + 30, 30)];
    biLV.textColor = [UIColor whiteColor];
    biLV.tag = 5;
    biLV.font = kGetFont(13);
    biLV.text = @"麦克风已开";
    biLV.textAlignment = NSTextAlignmentCenter;
    [self.biBtn addSubview:biLV];
    
    UIButton *sheBtn = [[UIButton alloc] initWithFrame:CGRectMake(biBtn.x, CGRectGetMaxY(biBtn.frame) + 10, 60, 90)];
    sheBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
    [sheBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sheBtn setImage:[UIImage imageNamed:@"icon_qiehuanshexiangtou_66_sel"] forState:UIControlStateSelected];
    [sheBtn setImage:[UIImage imageNamed:@"icon_qiehuanshexiangtou_66_nor"] forState:UIControlStateNormal];
    sheBtn.tag = 3;
    sheBtn.hidden = YES;
    [self.view addSubview:sheBtn];
    self.sheBtn = sheBtn;
    UILabel *sheLV = [[UILabel alloc] initWithFrame:CGRectMake(-15, 60, biBtn.width + 30, 30)];
    sheLV.textColor = [UIColor whiteColor];
    sheLV.tag = 5;
    sheLV.font = kGetFont(13);
    sheLV.text = @"摄像头已开";
    sheLV.textAlignment = NSTextAlignmentCenter;
    [self.sheBtn addSubview:sheLV];

    UIView *bbView = [[UIView alloc] initWithFrame:CGRectMake(0, ML_ScreenHeight, 0, 0)];
    bbView.hidden = YES;
    bbView.backgroundColor = [UIColor whiteColor];
    self.sendView = bbView;
    
    // 创建UITextField实例 icon_guaduan_80_nor
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(24, 10, ML_ScreenWidth - 48, 40)];
    textField.returnKeyType = UIReturnKeySend;
    textField.borderStyle = UITextBorderStyleNone;
    textField.delegate = self;
    textField.textColor = [UIColor blackColor];
//    textField.placeholder = Localized(@"点击向Ta发消息", nil);
//    textField.layer.cornerRadius = 20;
//    textField.layer.masksToBounds = YES;
    // 创建带有红色文字颜色的 attributedPlaceholder 对象
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"点击向Ta发消息", nil) attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]}];
    // 设置 textField 的 attributedPlaceholder 属性
    textField.attributedPlaceholder = attributedPlaceholder;
    // 设置背景图片
    textField.background = [UIImage imageNamed:@"input_box_40"];
    self.textField = textField;
    
    
    self.tabV = [[UITableView alloc]initWithFrame:CGRectMake(24, img_bg.y - 130, ML_ScreenWidth / 2 + 45, 110) style:UITableViewStylePlain];
    self.tabV.backgroundColor = UIColor.clearColor;
//    self.tabV.hidden = YES;
    self.tabV.delegate = self;
    self.tabV.dataSource = self;
    self.tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tabV];
    self.tabVListArr = [NSMutableArray array];
    
    
    
    _hangupBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 40, chatBtn.y - 50, 80, 80)];;
    _hangupBtn.hidden = YES;
    [_hangupBtn addTarget:self action:@selector(hangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_hangupBtn setImage:[UIImage imageNamed:@"icon_guaduan_80_nor"] forState:UIControlStateNormal];
    [self.view addSubview:_hangupBtn];
    
    [self.view addSubview:bbView];
    // 添加到父视图中
    [self.sendView addSubview:textField];
    [textField layoutIfNeeded];
    
    [self.view addSubview:self.switchCameraBtn];
    
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusHeight + 20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
//    [self.view addSubview:self.callTypeBtn];
//    [self.callTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.switchCameraBtn.mas_top);
//        make.leading.mas_equalTo(self.switchCameraBtn.mas_trailing).offset(10);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
    [self.view addSubview:self.smallVideoView];
    [self.smallVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusHeight + 20);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(90, 160));
    }];
    [self.view addSubview:self.remoteAvatorView];
    [self.remoteAvatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusHeight + 20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remoteAvatorView.mas_top).offset(5);
        make.right.mas_equalTo(self.remoteAvatorView.mas_left).offset(-8);
        make.left.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    [self.view addSubview:self.subTitleLabel];
//    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ML_ScreenHeight / 2 + 40);
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(20);
//    }];
    
    /// 取消按钮
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(80, 103));
    }];
    // 正在接通
    [self.view addSubview:self.connectingLabel];
    [self.connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top).mas_offset(-20);
    }];
    /// 接听和拒接按钮
    [self.view addSubview:self.rejectBtn];
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(- self.view.frame.size.width/4.0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(80, 103));
    }];
    
    [self.view addSubview:self.acceptBtn];
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.frame.size.width/4.0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(80, 103));
    }];
    [self.view addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(44 + 3 * 60, 60));
        make.bottom.mas_equalTo(-50);
    }];
    [self.view addSubview:self.statsLabel];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.operationView.mas_top).mas_offset(-20);
    }];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ML_ScreenWidth, 40)];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.durationLabel];
    
//    _gitfButton = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 47 - 60, ML_ScreenHeight - 290, 60, 90)];
//    _gitfButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
//    [_gitfButton addTarget:self action:@selector(giftbtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_gitfButton setImage:kGetImage(@"icon_liwu_66_nor") forState:UIControlStateNormal];
//    _gitfButton.tag = 3;
//    _gitfButton.hidden = YES;
//    [self.view addSubview:_gitfButton];
//    UILabel *liV = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _gitfButton.width, 30)];
//    liV.textColor = [UIColor whiteColor];
//    liV.font = kGetFont(13);
//    liV.text = Localized(@"礼物", nil);
//    liV.textAlignment = NSTextAlignmentCenter;
//    [_gitfButton addSubview:liV];
    
//    UIButton *biBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 30, ML_ScreenHeight - 290, 60, 90)];
//    biBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
//    [biBtn addTarget:self action:@selector(microPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
//    [biBtn setImage:kGetImage(@"icon_maikefengyikai_66_nor") forState:UIControlStateNormal];
//    [biBtn setImage:[UIImage imageNamed:@"icon_maikefengyiguan_66_sel"] forState:UIControlStateSelected];
//    biBtn.tag = 3;
//    biBtn.hidden = YES;
//    [self.view addSubview:biBtn];
//    self.biBtn = biBtn;
//    UILabel *biLV = [[UILabel alloc] initWithFrame:CGRectMake(-15, 60, _gitfButton.width + 30, 30)];
//    biLV.textColor = [UIColor whiteColor];
//    biLV.tag = 5;
//    biLV.font = kGetFont(13);
//    biLV.text = @"麦克风已开";
//    biLV.textAlignment = NSTextAlignmentCenter;
//    [self.biBtn addSubview:biLV];
//
//    UIButton *sheBtn = [[UIButton alloc] initWithFrame:CGRectMake(47, ML_ScreenHeight - 290, 60, 90)];
//    sheBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; // btn 对齐方式
//    [sheBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [sheBtn setImage:[UIImage imageNamed:@"icon_qiehuanshexiangtou_66_nor"] forState:UIControlStateNormal];
//    [sheBtn setImage:[UIImage imageNamed:@"icon_qiehuanshexiangtou_66_sel"] forState:UIControlStateSelected];
//    sheBtn.tag = 3;
//    sheBtn.hidden = YES;
//    [self.view addSubview:sheBtn];
//    self.sheBtn = sheBtn;
//    UILabel *sheLV = [[UILabel alloc] initWithFrame:CGRectMake(-15, 60, _gitfButton.width + 30, 30)];
//    sheLV.textColor = [UIColor whiteColor];
//    sheLV.tag = 5;
//    sheLV.font = kGetFont(13);
//    sheLV.text = @"摄像头已开";
//    sheLV.textAlignment = NSTextAlignmentCenter;
//    [self.sheBtn addSubview:sheLV];

//    _hangupBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 30, ML_ScreenHeight - 150, 60, 60)];;
//    _hangupBtn.hidden = YES;
//    [_hangupBtn addTarget:self action:@selector(hangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_hangupBtn setImage:[UIImage imageNamed:@"call_cancel"] forState:UIControlStateNormal];
//    [self.view addSubview:_hangupBtn];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabVListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
     if(cell == nil) {
         cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aCell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = [UIColor clearColor];
         
         UIImageView *imgV = [[UIImageView alloc] init];
         imgV.contentMode = UIViewContentModeScaleAspectFill;
         imgV.tag = 10;
         imgV.layer.cornerRadius = 16;
         imgV.layer.masksToBounds = YES;
         imgV.image = kGetImage(@"copy_display_box");
         [cell addSubview:imgV];
         
         UILabel *deV = [[UILabel alloc] init];
         deV.numberOfLines = 0;
         deV.font = kGetFont(12);
         deV.textColor = [UIColor whiteColor];
         deV.tag = 11;
         [imgV addSubview:deV];
     }
    for (UIView *imgV in cell.subviews) {
        
        if (imgV.tag == 10) {
            
            imgV.frame = CGRectMake(0, 0, tableView.width, 40);
            
            for (UILabel *dev in imgV.subviews) {
        
                if (dev.tag == 11) {
                    NSString *str = self.tabVListArr[indexPath.row];
                    dev.text = str;
                    CGSize size = [dev.text sizeWithFont:dev.font maxSize:CGSizeMake(tableView.width - 16, 100)];
                    
                    
                    imgV.frame = CGRectMake(0, 0, tableView.width, size.height + 14);


                    dev.frame = CGRectMake(8, 0, size.width, imgV.height);
             
                    
                    break;
                }
            }
            
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    CGFloat cellHei = 48;
    for (UIView *imgV in cell.subviews) {

        if (imgV.tag == 10) {


            for (UILabel *dev in imgV.subviews) {

                if (dev.tag == 11) {

                    CGSize size = [dev.text sizeWithFont:dev.font maxSize:CGSizeMake(tableView.width - 16, 100)];

                    cellHei = size.height + 14;

                    break;
                }
            }

        }
    }
    
    return cellHei + 8;
}


- (void)setResponse:(MLNetworkResponse *)response
{
    _response = response;
    NSDictionary *dataDic = response.data;
    NSDictionary *dic2 = dataDic[@"otherInfo"];
    
    
    if ([dic2[@"backgroundCoverUrl"] containsString:@".mp4"] && !_autoJie) {
        
        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        configuration.shouldAutoPlay = YES;
        configuration.supportedDoubleTap = YES;
        configuration.shouldAutorotate = YES;
        configuration.repeatPlay = YES;
        configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
        configuration.sourceUrl = kGetUrlPath(dic2[@"backgroundCoverUrl"]);
        configuration.videoGravity = SelVideoGravityResizeAspectFill;
        SelVideoPlayer *ttplayer = [[SelVideoPlayer alloc]initWithFrame:self.view.bounds configuration:configuration];
        [self.view addSubview:ttplayer];
        self.ttplayer = ttplayer;
        [ttplayer _playVideo];
        
    } else {
        
        UIImageView *bigImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
        bigImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:bigImg];
        self.bigImg = bigImg;
        [bigImg sd_setImageWithURL:kGetUrlPath(dic2[@"icon"])];
    }

    
    
    [self setupUI];
//    if (self.autoJie) {
//
//        [self setupUI];
//    } else {
//
//        [self setupUI];
        
//        if (![[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
    
    UIImageView *avVBg = [[UIImageView alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 60, ML_NavViewHeight - 16, 120, 120)];
    avVBg.image = kGetImage(@"card_phone_background");
    [self.view addSubview:avVBg];
    self.avVBg =avVBg;
    
    
            UIImageView *avV = [[UIImageView alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 44, ML_NavViewHeight, 88, 88)];
            avV.layer.cornerRadius = avV.width / 2;
            avV.layer.masksToBounds = YES;
            [self.view addSubview:avV];
            self.avV =avV;
            
            UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(avVBg.x, CGRectGetMaxY(avVBg.frame) + 10, avVBg.width, 40)];
            nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            nameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
            [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:nameBtn];
            self.nameBtn =nameBtn;
            
            UIButton *dizhiBtn = [[UIButton alloc] initWithFrame:CGRectMake(avV.x, CGRectGetMaxY(nameBtn.frame) + 20, 200, 20)];
    dizhiBtn.hidden = ![[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue];
            dizhiBtn.titleLabel.font = kGetFont(14);
            [dizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.dizhiBtn setImage:kGetImage(@"icon_dingwei_15_FFF_nor") forState:UIControlStateNormal];
            [self.view addSubview:dizhiBtn];
            self.dizhiBtn = dizhiBtn;
            
            UIButton *agebtn = [[UIButton alloc] init];
            agebtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
            agebtn.layer.cornerRadius = 10;
            agebtn.layer.masksToBounds = YES;
            [self.view addSubview:agebtn];
            self.agebtn = agebtn;
            
            UILabel *qianV = [[UILabel alloc] init];
            qianV.textColor = [UIColor whiteColor];
            qianV.font = kGetFont(14);
            qianV.textColor = [UIColor colorWithHexString:@"#ffffff"];
            [self.view addSubview:qianV];
            self.qianV = qianV;
            
            [self.avV sd_setImageWithURL:kGetUrlPath(dic2[@"icon"])];
            
            
            self.chargeStandardV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 40)];
            self.chargeStandardV.textColor = [UIColor whiteColor];
            self.chargeStandardV.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
            self.chargeStandardV.textAlignment = NSTextAlignmentCenter;
            self.chargeStandardV.numberOfLines = 0;
            self.chargeStandardV.font = kGetFont(14);
            [self.view addSubview:self.chargeStandardV];
            
            if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
                
                self.chargeStandardV.text = [NSString stringWithFormat:@"每分钟收益%@积分接通后开始计费", dataDic[@"standard"]];
            } else {
                
                self.chargeStandardV.text = [NSString stringWithFormat:@"主播聊天%@米/分钟，将在接通后开始收费", dataDic[@"standard"]];
                
            }
            if (![ML_AppUtil isCensor]) {
                self.chargeStandardV.hidden = YES;
            }
            self.chargeStandardV.hidden = YES;
            
            CGSize size = [self.chargeStandardV.text sizeWithFont:self.chargeStandardV.font maxSize:CGSizeMake(ML_ScreenWidth - 30, 50)];
            self.chargeStandardV.frame = CGRectMake(ML_ScreenWidth / 2 - size.width / 2 - 7.5, ML_ScreenHeight / 2 - 10, size.width + 15, 40);
            self.chargeStandardV.layer.cornerRadius = self.chargeStandardV.height / 2;
            self.chargeStandardV.layer.masksToBounds = YES;
            
            
            [self.nameBtn setTitle:dic2[@"name"]?:@"" forState:UIControlStateNormal];
            switch ([dic2[@"identity"] integerValue]) {
                case 0:
                    [self.nameBtn setImage:nil forState:UIControlStateNormal];
                    break;
                case 10:
                    [self.nameBtn setImage:[UIImage imageNamed:@"huangjinIcon"] forState:UIControlStateNormal];
                    break;
                case 20:
                    [self.nameBtn setImage:[UIImage imageNamed:@"boIcon"] forState:UIControlStateNormal];
                    break;
                case 30:
                    [self.nameBtn setImage:[UIImage imageNamed:@"zuanshiIcon"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
            CGSize nameSize = [[self.nameBtn currentTitle] sizeWithFont:self.nameBtn.font maxSize:CGSizeMake(ML_ScreenWidth / 2, 100)];
//            self.nameBtn.frame = CGRectMake(self.avVBg.x, CGRectGetMaxY(self.avV.frame) + 10, nameSize.width, nameSize.height);
    self.nameBtn.frame = CGRectMake(self.avVBg.x, CGRectGetMaxY(self.avVBg.frame) + 10, nameSize.width, 40);
            //    NSString *str = [NSString stringWithFormat:@"%@%@", dic2[@"name"]?:@"", self.type == NERtcCallTypeVideo? @"邀请你视频通话":@"邀请你语音通话"];
            //    self.subTitleLabel.text = str;
            //    CGSize subSize = [str sizeWithFont:self.subTitleLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 40, 50)];
            //    subSize.width += 15;
            //    self.subTitleLabel.frame = CGRectMake((ML_ScreenWidth - subSize.width) / 2, ML_ScreenHeight / 2 + 40, subSize.width, 40);
            
            //    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.mas_equalTo(ML_ScreenHeight / 2 + 40);
            //        make.right.mas_equalTo(0);
            //        make.left.mas_equalTo(0);
            //        make.height.mas_equalTo(20);
            //    }];
            
            if ([dic2[@"gender"] intValue] == 1) {
                [self.agebtn setTitle:[NSString stringWithFormat:@"♂%@", dic2[@"age"]] forState:UIControlStateNormal];
                self.agebtn.backgroundColor = [UIColor colorWithHexString:@"#0491FF"];
                //            [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
            } else {
                [self.agebtn setTitle:[NSString stringWithFormat:@"♀%@", dic2[@"age"]] forState:UIControlStateNormal];
                self.agebtn.backgroundColor = [UIColor colorWithHexString:@"#FB4240"];
                //            [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
                
            }
            
            
            [self.dizhiBtn setTitle:[NSString stringWithFormat:@"♂%@", dic2[@"city"]?:@""] forState:UIControlStateNormal];
            CGSize dizhiBtnSize = [[self.dizhiBtn currentTitle] sizeWithFont:self.dizhiBtn.font maxSize:CGSizeMake(ML_ScreenWidth / 2, 100)];
            self.dizhiBtn.frame = CGRectMake(self.nameBtn.x, CGRectGetMaxY(self.nameBtn.frame) + 5, dizhiBtnSize.width, dizhiBtnSize.height);
            
            self.agebtn.frame = CGRectMake(self.dizhiBtn.hidden?self.avV.x:CGRectGetMaxX(self.dizhiBtn.frame) + 10, self.dizhiBtn.y, 35, 20);
            
            NSArray *arr = dic2[@"userLabels"];
            //    arr = @[@{@"name" : @"asdf", @"color" : @"#333333"}, @{@"name" : @"asdf", @"color" : @"#999999"}];
            CGFloat maxW = self.avV.x;
            int i = 0;
            for (NSDictionary *dic in arr) {
                
                CGSize laVsize = [dic[@"name"]?:@"" sizeWithFont:kGetFont(12) maxSize:CGSizeMake(100, 20)];
                UILabel *laV = [[UILabel alloc] initWithFrame:CGRectMake(maxW, CGRectGetMaxY(self.agebtn.frame) + 15, laVsize.width + 15, 23)];
                laV.textColor = [UIColor whiteColor];
                laV.font = kGetFont(12);
                laV.backgroundColor = [UIColor colorWithHexString:dic[@"color"]];
                laV.text = dic[@"name"];
                laV.layer.cornerRadius = 11.5;
                laV.layer.masksToBounds = YES;
                laV.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:laV];
                laV.tag = 10000 + i;
                maxW = CGRectGetMaxX(laV.frame) + 12;
                i ++;
            }
            
            self.qianV.text = [dic2[@"persionSign"] length]?dic2[@"persionSign"]:@"";
            CGSize qianVSize = [self.qianV.text sizeWithFont:self.qianV.font maxSize:CGSizeMake(ML_ScreenWidth / 2, 100)];
            self.qianV.frame = CGRectMake(self.nameBtn.x, CGRectGetMaxY(self.agebtn.frame) + (arr.count?50:0), qianVSize.width, qianVSize.height);
//        }
//    }
    
}

- (void)giftbtnClick
{
    [self.giftView showGiftView];
}

- (LDSGiftView *)giftView {
    if (_giftView == nil) {
        _giftView = [[LDSGiftView alloc] init];
        _giftView.delegate = self;
        _giftView.userId = [NSString stringWithFormat:@"%@", self.otherUserID];
        NSArray *giftArr = [ML_AppConfig sharedManager].giftArr;
        _giftView.dataArray = giftArr;
        _giftView.giveType = @(0);
//        _giftView.relationId = [NSString stringWithFormat:@"%llu", self.event.cid];
        _giftView.relationId = self.callLogId?:@"";
        _giftView.userName = [[NIMKit sharedKit].provider infoByUser:self.otherUserID option:nil].showName;
        
   
    }
    return _giftView;
}


#pragma mark - LDSGiftViewDelegate
- (void)giftViewSendGiftInView:(LDSGiftView *)giftView data:(LDSGiftCellModel *)model {
    
    NSLog(@"点击-- %@",model.name);

}



- (void)updateUIStatus:(NERtcCallStatus)status {
    switch (status) {
        case NERtcCallStatusCalling:
        {
//            self.titleLabel.text = [NSString stringWithFormat:@"正在呼叫 %@",self.otherUserID];
//            self.subTitleLabel.text = @"等待对方接听……";
            
            NSDictionary *dic2 = self.response.data[@"otherInfo"];
            NSString *str = [NSString stringWithFormat:@"正在等待%@接受你的邀请", dic2[@"name"]?:@""];
            self.subTitleLabel.text = str;
            CGSize subSize = [str sizeWithFont:self.subTitleLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 40, 50)];
            subSize.width += 15;
            self.subTitleLabel.frame = CGRectMake((ML_ScreenWidth - subSize.width) / 2, ML_ScreenHeight / 2 + 40, subSize.width, 40);
            self.subTitleLabel.hidden = YES;
//            self.remoteAvatorView.hidden = NO;
            self.smallVideoView.hidden = YES;
            self.cancelBtn.hidden = NO;
            self.rejectBtn.hidden = YES;
            self.acceptBtn.hidden = YES;
            self.switchCameraBtn.hidden = YES;
            self.sysBtn.hidden = YES;
            self.img_bg.hidden = YES;
//            self.sendView.hidden = YES;
            self.tabV.hidden = YES;
            self.operationView.hidden = YES;
//            self.callTypeBtn.hidden = YES;
            _gitfButton.hidden = YES;
            _chatBtn.hidden = YES;
            _biBtn.hidden = YES;
            _sheBtn.hidden = YES;
            _hangupBtn.hidden = YES;
        }
            break;
        case NERtcCallStatusCalled:
        {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",self.otherUserID];
//            self.remoteAvatorView.hidden = NO;
            
            NSDictionary *dic2 = self.response.data[@"otherInfo"];
            NSString *str = [NSString stringWithFormat:@"%@%@", dic2[@"name"]?:@"", self.type == NERtcCallTypeVideo? @"邀请你视频通话":@"邀请你语音通话"];
            self.subTitleLabel.text = str;
            CGSize subSize = [str sizeWithFont:self.subTitleLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 40, 50)];
            subSize.width += 15;
            self.subTitleLabel.frame = CGRectMake((ML_ScreenWidth - subSize.width) / 2, ML_ScreenHeight / 2 + 40, subSize.width, 40);
            self.subTitleLabel.hidden = YES;
            
            self.smallVideoView.hidden = YES;
            self.cancelBtn.hidden = YES;
            self.rejectBtn.hidden = NO;
            self.acceptBtn.hidden = NO;
            self.switchCameraBtn.hidden = YES;
            self.operationView.hidden = YES;
            self.sysBtn.hidden = YES;
            self.img_bg.hidden = YES;
//            self.sendView.hidden = YES;
            self.tabV.hidden = YES;
            _gitfButton.hidden = YES;
            _chatBtn.hidden = YES;
            _biBtn.hidden = YES;
            _sheBtn.hidden = YES;
            _hangupBtn.hidden = YES;
        }
            break;
        case NERtcCallStatusInCall:
        {
            self.switchCameraBtn.hidden = NO;
            self.sysBtn.hidden = NO;
            self.img_bg.hidden = NO;
//            self.sendView.hidden = YES;
            self.tabV.hidden = NO;
            _hangupBtn.hidden = NO;
            _gitfButton.hidden = NO;
            _chatBtn.hidden = NO;
            _biBtn.hidden = NO;
            if ([self.response.data[@"otherInfo"][@"host"] boolValue]) {
                
                _sheBtn.hidden = NO;
            } else {
                _biBtn.frame = _sheBtn.frame;
                _sheBtn.hidden = YES;
            }
            
//            self.operationView.hidden = NO;
            if (self.type == NERtcCallTypeVideo) {
                self.titleLabel.hidden = YES;
                self.subTitleLabel.hidden = YES;
//                self.switchCameraBtn.hidden = NO;
                
                self.operationView.cameraBtn.hidden = NO;
                self.operationView.switchAudio.hidden = NO;
                [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.view.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(44 + 60 * 4, 60));
                    make.bottom.mas_equalTo(-50);
                }];
                
            }else {
                self.switchCameraBtn.hidden = YES;
                self.titleLabel.text = [NSString stringWithFormat:@"%@",self.otherUserID];
                self.subTitleLabel.text = @"正在语音通话";
                self.titleLabel.hidden = NO;
                self.subTitleLabel.hidden = NO;
                self.operationView.cameraBtn.hidden = YES;
                self.operationView.switchAudio.hidden = YES;
                [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.view.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(44 + 60 * 2, 60));
                    make.bottom.mas_equalTo(-50);
                }];
                self.switchCameraBtn.hidden = YES;
            }
            self.smallVideoView.hidden = NO;
//            self.remoteAvatorView.hidden = YES;
            self.cancelBtn.hidden = YES;
            self.rejectBtn.hidden = YES;
            self.acceptBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - event
- (void)cancelEvent:(NECustomButton *)button {
    WEAK_SELF(weakSelf);
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
        STRONG_SELF(strongSelf);
        [strongSelf.view makeToast:error.localizedDescription];
    }];
    [self destroy];
}

- (void)rejectEvent:(NECustomButton *)button {
    self.acceptBtn.enabled = NO;
    WEAK_SELF(weakSelf);
    switch (button.tag) {
        case 0: { // 拒绝
            weakSelf.isJujue = YES;
            [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
                STRONG_SELF(strongSelf);
                strongSelf.acceptBtn.enabled = YES;
                [strongSelf destroy];
            }];
            break;
        }
        case 1: { // 挂断
            [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
                STRONG_SELF(strongSelf);
                strongSelf.acceptBtn.enabled = YES;
                [strongSelf destroy];
            }];
        }
        default:
            break;
    }
}

- (void)setAutoJie:(BOOL)autoJie
{
    _autoJie = autoJie;
    
//    [self setupSDK];
    
//    [self acceptEvent:_acceptBtn];
    
}

- (void)acceptEvent:(NECustomButton *)button {
    
    self.chargeStandardV.hidden = YES;
    
    if ([self.response.status intValue] == 106 && [ML_AppUtil isCensor]) {
        
        NSString *str = self.response.msg;
        ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
        tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : str?:@"余额不足，请充值！"};
        [self rejectEvent:self.rejectBtn];
    } else {
        
        [self jieting];
    }
}

- (void)jieting
{
    
    _rejectBtn.hidden= YES;
    _acceptBtn.hidden= YES;
    
    _bigVideoView.hidden = NO;
    self.acceptBtn.enabled = NO;
    self.connectingLabel.hidden = NO;
    self.rejectBtn.tag = 1; // 给拒绝按钮打个标签，再点击拒绝等同于挂断
    WEAK_SELF(weakSelf);
    [[NERtcCallKit sharedInstance] accept:^(NSError * _Nullable error) {
        STRONG_SELF(strongSelf);
        if (error) {
            strongSelf.connectingLabel.hidden = YES;
            strongSelf.acceptBtn.enabled = YES;
            NSString *errorToast = [NSString stringWithFormat:@"接听失败%@",error.localizedDescription];
            [strongSelf.view.window makeToast:errorToast];
            [strongSelf destroy];
        } else {
            [strongSelf.player stop];
        }
    }];
}

- (void)switchCallTypeEvent:(UIButton *)button {
//    button.enabled = NO;
//    NERtcCallType newType = self.type == NERtcCallTypeVideo ? NERtcCallTypeAudio : NERtcCallTypeVideo;
//    __weak typeof(self) wself = self;
//    [NERtcCallKit.sharedInstance switchCallType:newType completion:^(NSError * _Nullable error) {
//        __strong typeof(wself) sself = wself;
//        if (!sself) return;
//        if (error) {
//            [sself.view makeToast:error.localizedDescription];
//            return;
//        }
//        [sself handleCallTypeChange:newType];
//    }];
}

- (void)switchCameraBtn:(UIButton *)button { //
    if (![[NERtcCallKit sharedInstance] switchCamera]) {
        
        [[FUManager shareManager] onCameraChange];
    }
}

- (void)microPhoneClick:(UIButton *)button {
    button.selected = !button.selected;
    for (UILabel *view in button.subviews) {
        if (view.tag == 5) {
            if (button.selected) {
                view.text = @"麦克风已关";
            } else {
                view.text = @"麦克风已开";
            }
            break;
        }
    }
    [[NERtcCallKit sharedInstance] muteLocalAudio:button.selected];
}

- (void)cameraBtnClick:(UIButton *)button {

    button.selected = !button.selected;
    for (UILabel *view in button.subviews) {
        if (view.tag == 5) {
            if (button.selected) {
                view.text = @"摄像头已关";
            } else {
                view.text = @"摄像头已开";
            }
            break;
        }
    }
    
    BOOL muted = button.selected;
    
    [NERtcCallKit.sharedInstance muteLocalVideo:muted];
    [self onVideoMuted:muted userID:self.myselfID];
    if (muted) {
        self.statsCount = 0; // 打开摄像头后会有正常的统计数据波动，同样忽略前3次统计
    }
}

- (void)hangupBtnClick:(UIButton *)button {
    kSelf;
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
       
        [weakself destroy];
    }];
}

#pragma mark - NERtcCallKitDelegate
// 有人进来房间 读秒UI优化双方在这个方法
- (void)onUserEnter:(NSString *)userID {
    
    [_ttplayer _pauseVideo];
    
    self.otherUserID = userID;
//    [[NERtcCallKit sharedInstance] setupRemoteView:self.smallVideoView.videoView forUser:self.otherUserID];
    [self setupRemoteView:self.smallVideoView.videoView forUser:self.otherUserID];
    self.statsCount = 0;
    if (self.type == NERtcCallTypeAudio) {
        self.connectingLabel.hidden = YES;
        [self updateUIStatus:NERtcCallStatusInCall];
    }
}

// 能看到对方首首帧画面
- (void)onFirstVideoFrameDecoded:(NSString *)userID width:(uint32_t)width height:(uint32_t)height {
    
//    [self.piPeibgView removeFromSuperview];
//    self.piPeibgView = nil;
    
    // 美颜
//    NSLog(@"%@",[FULocalDataManager shareManager].persistentBeauty.beautySkins);
//    self.localdatamage = [FULocalDataManager shareManager];
//    self.demoManager = [FUDemoManager setupFaceUnityDemoInController:self originY:ML_ScreenHeight + FUBottomBarHeight];
    
    if (self.ttplayer) {
        
        [self.ttplayer _pauseVideo];
        [self.ttplayer _deallocPlayer];
        [self.ttplayer removeFromSuperview];
    }
    [self.bigImg removeFromSuperview];
    
    for (UIView *view in self.view.subviews) {
        if (view.tag >= 10000) {
            [view removeFromSuperview];
        }
    }
    self.avV.hidden = YES;
    self.avVBg.hidden = YES;
    self.nameBtn.hidden = YES;
    self.dizhiBtn.hidden = YES;
    self.agebtn.hidden = YES;
    self.qianV.hidden = YES;
    self.subTitleLabel.hidden = YES;
    self.chargeStandardV.hidden = YES;
    _bigVideoView.hidden = NO;
    
    [self initTimer];
    [self.player stop];
    
    self.connectingLabel.hidden = YES;
    if (self.isCalled) {
        [self setupLocalView];
    }
    [self setupRemoteView];
    [self updateUIStatus:NERtcCallStatusInCall];
    [self becomeBigVideoView:self.smallVideoView];
}

- (void)onUserAccept:(NSString *)userID {

//        //加入成功，建立本地canvas渲染本地视图
//        NERtcVideoCanvas *canvas = [self setupLocalCanvas];
//        [NERtcEngine.sharedEngine setupLocalVideoCanvas:canvas];
  
//    if (self.ttplayer) {
//
//        [self.ttplayer _pauseVideo];
//
//    }
//
//    for (UIView *view in self.view.subviews) {
//        if (view.tag >= 10000) {
//            [view removeFromSuperview];
//        }
//    }
//    self.avV.hidden = YES;
//    self.nameBtn.hidden = YES;
//    self.dizhiBtn.hidden = YES;
//    self.agebtn.hidden = YES;
//    self.qianV.hidden = YES;
//    self.subTitleLabel.hidden = YES;
//    self.chargeStandardV.hidden = YES;
    
    
    NSLog(@"CallVC: User %@ accept", userID);
    [self.player stop];
    self.connectingLabel.hidden = NO;
    self.cancelBtn.enabled = NO;
}
- (void)onUserCancel:(NSString *)userID {
    if (self.otherUserID != userID) { return; }
    kplaceToast(@"对方取消邀请");
    [self destroy];
}

- (void)onVideoMuted:(BOOL)muted userID:(NSString *)userID {
    NSString *tips = [self.myselfID isEqualToString:userID]?@"关闭了摄像头":@"对方关闭了摄像头";
    BOOL tipForceHidden = self.type == NERtcCallTypeAudio;
    if ([self.bigVideoView.userID isEqualToString:userID]) {
        self.bigVideoView.titleLabel.hidden = !muted || tipForceHidden;
        self.bigVideoView.titleLabel.text = tips;
    }
    if ([self.smallVideoView.userID isEqualToString:userID]) {
        self.smallVideoView.titleLabel.hidden = !muted || tipForceHidden;
        self.smallVideoView.titleLabel.text = tips;
    }
}

- (void)onCallingTimeOut {
//    [self.view.window makeToast:@"对方无响应"];
    kplaceToast(@"对方无响应");
    [self destroy];
}

- (void)onUserBusy:(NSString *)userID {
//    [self.view.window makeToast:@"对方正在通话中"];
    if (self.otherUserID != userID) { return; }
    kplaceToast(@"对方正在通话中");
    [self destroy];

}
- (void)onCallEnd {
    kplaceToast(@"通话结束");
    [self destroy];
}
- (void)onUserReject:(NSString *)userID {
    if (self.otherUserID != userID) { return; }
    self.isJujue = YES;
//    [self.view.window makeToast:@"对方拒绝了您的邀请"];
    kplaceToast(@"对方拒绝了您的邀请");
    [self destroy];
}

// 自己加入成功的回调，通常用来上报、统计等 这里面有channelId
- (void)onJoinChannel:(NERtcCallKitJoinChannelEvent *)event
{
    
    
//    if (self.ttplayer) {
//
//        [self.ttplayer _pauseVideo];
//
//    }
//
//    for (UIView *view in self.view.subviews) {
//        if (view.tag >= 10000) {
//            [view removeFromSuperview];
//        }
//    }
//    self.avV.hidden = YES;
//    self.nameBtn.hidden = YES;
//    self.dizhiBtn.hidden = YES;
//    self.agebtn.hidden = YES;
//    self.qianV.hidden = YES;
//    self.subTitleLabel.hidden = YES;
//    self.chargeStandardV.hidden = YES;
    
    self.event = event;
    
    [[NSUserDefaults standardUserDefaults] setObject:@{@"toUserId" : self.otherUserID, @"channelId" : [NSString stringWithFormat:@"%llu", self.event.cid], @"channelName" : self.event.cname?:@""} forKey:[NSString stringWithFormat:@"event_%@", self.myselfID]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSLog(@"adsfasdf=======%d", event.cid);

    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.otherUserID, @"channelId" : [NSString stringWithFormat:@"%llu", self.event.cid], @"channelName" : self.event.cname?:@"", @"isNotSend" : @(![ML_AppUtil isCensor])} urlStr:@"im/inCall"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSDictionary *dic = response.data;
        if ([dic[@"mind"] boolValue] && [ML_AppUtil isCensor]) {
            NSString *toast = [NSString stringWithFormat:@"预计当前金额可通话剩余不足%@分钟，是否去充值？", dic[@"rest"]];
            ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
            tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : toast};
        }
        
        // self.callLogId
        if([[dic allKeys] containsObject:@"callLogId"])
        {
            weakself.callLogId = dic[@"callLogId"];
        }
        
        
        if ([response.status intValue] == 106 && [ML_AppUtil isCensor]) {
            
            kSelf2;
            if (weakself.timer) {
                dispatch_source_cancel(weakself.timer); // 取消定时器
            }
            
            [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
                [weakself2 destroy];
            }];
            
            NSString *str = response.msg;
            ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
            tanV.dic = @{@"type" : @(ML_TanchuangViewType_chongzhi), @"data" : str?:@"余额不足，请充值！"};
            
        }
        [ML_AppUserInfoManager shuaWithCoin:[NSString stringWithFormat:@"%@", self.response.data[@"standard"]]];
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
    }];
    
    NSLog(@"cid或者channelId:%llu", event.cid);
}

- (void)onUserLeave:(NSString *)userID {
    if (self.otherUserID != userID) { return; }
    [self.view.window makeToast:@"对方已离开"];
    [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
        [self destroy];
    }];
}

- (void)onUserDisconnect:(NSString *)userID {
    if (self.otherUserID != userID) { return; }
    [self.view.window makeToast:@"对方已断开"];
    [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
        [self destroy];
    }];
}

- (void)onCallTypeChange:(NERtcCallType)callType withState:(NERtcSwitchState)state{
    [self handleCallTypeChange:callType];
}

- (void)onUserNetworkQuality:(NSDictionary<NSString *,NERtcNetworkQualityStats *> *)stats {
    NERtcNetworkQualityStats *otherUserStat = stats[self.otherUserID?:@""];
    if (!otherUserStat) {
        return;
    }
    if (self.statsCount++ < 3) { // 忽略前3次统计
        return;
    }
    switch (otherUserStat.txQuality) {
        case kNERtcNetworkQualityUnknown: {
            self.statsLabel.text = @"对方网络状态可能较差";
            self.statsLabel.hidden = NO;
            break;
        }
        case kNERtcNetworkQualityBad:
        case kNERtcNetworkQualityVeryBad: {
            self.statsLabel.text = @"对方可能网络状态不佳";
            self.statsLabel.hidden = NO;
            break;
        }
        case kNERtcNetworkQualityDown: {
            self.statsLabel.text = @"对方可能网络状态非常差";
            self.statsLabel.hidden = NO;
            break;
        }
        default:
            self.statsLabel.hidden = YES;
            break;
    }
}

- (void)onDisconnect:(NSError *)reason {
    if (reason.code == 30207) {
        [self.view.window makeToast:@"您已断开连接"];
        [self destroy];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@ code=%ld", reason.localizedDescription, reason.code];
        [self.view.window makeToast:string];
    }
   
}

- (void)onOtherClientAccept {
    [self.view.window makeToast:@"已在其他设备接听"];
    [self destroy]; // 已被其他端处理
}

- (void)onOtherClientReject {
    [self.view.window makeToast:@"已在其他设备拒绝"];
    [self destroy]; // 已被其他端处理
}


#pragma mark - NEVideoViewDelegate
- (void)didTapVideoView:(NEVideoView *)videoView {
    if (videoView.isSmall) {
        [self becomeBigVideoView:videoView];
        
        _bigVideoView.layer.borderWidth = _bigVideoView.layer.borderWidth==2?0:2;
        _bigVideoView.layer.cornerRadius = _bigVideoView.layer.cornerRadius==12?0:12;
        _smallVideoView.layer.borderWidth = _smallVideoView.layer.borderWidth==2?0:2;
        _smallVideoView.layer.cornerRadius = _smallVideoView.layer.cornerRadius==12?0:12;
    }
    
    [self.textField resignFirstResponder];
}

#pragma mark - private mothed
- (void)becomeBigVideoView:(NEVideoView *)videoView {
    [videoView becomeBig];
    
    NSInteger frontIndex = 0;
    NSInteger backIndex = 0;
    NEVideoView *forwardView = [videoView isEqual:self.bigVideoView]?self.smallVideoView:self.bigVideoView;
    for (int i = 0; i < self.view.subviews.count; i ++) {
        UIView *view = self.view.subviews[i];
        if ([view isEqual:videoView]) {
            backIndex = i;
        }
        if ([view isEqual:forwardView]) {
            frontIndex = i;
        }
    }
    [self.view exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
    
    [forwardView becomeSmall];
}
//铃声 - 接收方铃声
- (void)ring
{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    NSError *error;
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategorySoloAmbient withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    if (error) {
        NSLog(@"Error changing audio session category: %@", error.localizedDescription);
    }
    self.player.numberOfLoops = 30;
    [self.player play];
}

- (void)setupLocalView {
    if (self.type == NERtcCallTypeVideo) {
        NSLog(@"setupLocalView=====");
       [[NERtcCallKit sharedInstance] setupLocalView:self.bigVideoView.videoView];
       self.bigVideoView.userID = self.myselfID;
    }
}
- (void)setupRemoteView {
    if (self.type == NERtcCallTypeVideo) {
        NSLog(@"setupRemoteView=====");
//       [[NERtcCallKit sharedInstance] setupRemoteView:self.smallVideoView.videoView forUser:self.otherUserID];
       self.smallVideoView.userID = self.otherUserID;
    }
}
- (void)handleCallTypeChange:(NERtcCallType)type {
    self.type = type;
    BOOL isAudioType = type == NERtcCallTypeAudio; // 音频类型不提示关闭摄像头
    self.bigVideoView.titleLabel.hidden = isAudioType;
    self.smallVideoView.titleLabel.hidden = isAudioType;
//    [self.callTypeBtn setImage:[UIImage imageNamed:isAudioType?@"call_switch_video":@"call_switch_audio"] forState:UIControlStateNormal];
    NSString *toast = [NSString stringWithFormat:@"已切换为%@", type==NERtcCallTypeAudio?@"音频通话":@"视频通话"];
    [self.view makeToast:toast];
    [self updateUIStatus:NERtcCallStatusInCall];
    if (isAudioType) {
        [self.smallVideoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.bigVideoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        self.statsCount = 0;
        [NERtcCallKit.sharedInstance setupLocalView:self.smallVideoView];
//        [NERtcCallKit.sharedInstance setupRemoteView:self.bigVideoView forUser:self.otherUserID];
        [self setupRemoteView:self.bigVideoView forUser:self.otherUserID];
    }
    
}

- (void)setupRemoteView:(UIView *)remoteView forUser:(nonnull NSString *)userID
{
//  NIMSignalingMemberInfo *member = [self.context memberOfAccid:userID];
//  if (!member) {
//    return NCKLogError(@"Member of userID: %@ does NOT exist", userID);
//  }
  if (remoteView) {
    NERtcVideoCanvas *canvas = [[NERtcVideoCanvas alloc] init];
    canvas.renderMode = kNERtcVideoRenderScaleCropFill;
    canvas.container = remoteView;
    canvas.mirrorMode = kNERtcVideoMirrorModeDisabled;
    [NERtcEngine.sharedEngine setupRemoteVideoCanvas:canvas forUserID:[userID integerValue]];
    [NERtcEngine.sharedEngine subscribeRemoteVideo:YES
                                         forUserID:[userID integerValue]
                                        streamType:kNERtcRemoteVideoStreamTypeHigh];
  } else {
    [NERtcEngine.sharedEngine setupRemoteVideoCanvas:nil forUserID:[userID integerValue]];
    [NERtcEngine.sharedEngine subscribeRemoteVideo:NO
                                         forUserID:[userID integerValue]
                                        streamType:kNERtcRemoteVideoStreamTypeHigh];
  }
}

#pragma mark - destroy
- (void)destroy {
    
    [self.giftView hiddenGiftView];
    if (self.ttplayer) {
        
        [self.ttplayer _pauseVideo];
        
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"event_%@", self.myselfID]];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (!self.isJujue && self.event) {
        kSelf;
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"channelId" : [NSString stringWithFormat:@"%llu", self.event.cid]?:@"", @"channelName" : self.event.cname?:@""} urlStr:@"im/stopCall"];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
        } error:^(MLNetworkResponse *response) {

        } failure:^(NSError *error) {
            
        }];
        
    }
    
    
    if ([self.response.data[@"otherInfo"][@"host"] boolValue] && self.event) {
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"channelId" : [NSString stringWithFormat:@"%llu", self.event.cid?:0]} urlStr:@"im/getEvaluationInfo"];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:response.data];
            [muDic setObject:[NSString stringWithFormat:@"%llu", self.event.cid]?:@"" forKey:@"channelId"];
            
            ML_TanchuangView *tanVPing = [ML_TanchuangView shareInstance];
            tanVPing.dic = @{@"type" : @(ML_TanchuangViewType_pingjia), @"data" : muDic};
            tanVPing.isBgHideView = NO;

        } error:^(MLNetworkResponse *response) {

        } failure:^(NSError *error) {
            
        }];
    }
    
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
//    if (self && [self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            if (self.dismissCompletion) {
//                self.dismissCompletion();
//            }
//        }];
//    }
    
    if (self.timer) {
        
        dispatch_source_cancel(self.timer); // 取消定时器
    }
    [[NERtcCallKit sharedInstance] setupLocalView:nil];
    [[NERtcCallKit sharedInstance] removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    
    JPSEInstance.suspensionView = nil;
    
    // 替换dismiss关闭方式
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype  = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - property
- (NEVideoView *)bigVideoView {
    if (!_bigVideoView) {
        _bigVideoView = [[NEVideoView alloc] init];
         _bigVideoView.hidden = YES;  // 暂时注释
        _bigVideoView.isSmall = NO;
        _bigVideoView.delegate = self;
    }
    return _bigVideoView;
}
- (NEVideoView *)smallVideoView {
    if (!_smallVideoView) {
        _smallVideoView = [[NEVideoView alloc] init];
        _smallVideoView.isSmall = YES;
        // 暂时注释_smallVideoView.hidden = YES;// 暂时注释
        _smallVideoView.delegate = self;
    }
    return _smallVideoView;
}
- (UIImageView *)remoteAvatorView {
    if (!_remoteAvatorView) {
        _remoteAvatorView = [[UIImageView alloc] init];
        // 暂时注释_remoteAvatorView.hidden = YES;
        _remoteAvatorView.image = [UIImage imageNamed:@"avator"];
    }
    return _remoteAvatorView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.hidden = YES;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.layer.cornerRadius = 20;
        _subTitleLabel.layer.masksToBounds = YES;
        _subTitleLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.text = @"等待对方接听……";
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UILabel *)statsLabel {
    if (!_statsLabel) {
        _statsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statsLabel.font = [UIFont systemFontOfSize:14];
        _statsLabel.textColor = [UIColor whiteColor];
        _statsLabel.textAlignment = NSTextAlignmentCenter;
        _statsLabel.hidden = YES;
    }
    return _statsLabel;
}

- (NECustomButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[NECustomButton alloc] init];
//        _cancelBtn.titleLabel.text = Localized(@"取消", nil);
        _cancelBtn.imageView.image = [UIImage imageNamed:@"icon_guaduan_80_nor"];
        [_cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

//- (UIButton *)callTypeBtn {
//    if (!_callTypeBtn) {
//        _callTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _callTypeBtn.titleLabel.numberOfLines = 2;
//        _callTypeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_callTypeBtn setImage:[UIImage imageNamed:self.type == NERtcCallTypeAudio ? @"call_switch_video" : @"call_switch_audio"] forState:UIControlStateNormal];
//        [_callTypeBtn addTarget:self action:@selector(switchCallTypeEvent:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _callTypeBtn;
//}

- (NECustomButton *)rejectBtn {
    if (!_rejectBtn) {
        _rejectBtn = [[NECustomButton alloc] init];
        _rejectBtn.hidden= YES;
//        _rejectBtn.titleLabel.text = @"拒绝";
        _rejectBtn.imageView.image = [UIImage imageNamed:@"icon_guaduan_80_nor"];
        _rejectBtn.exclusiveTouch = YES;
        [_rejectBtn addTarget:self action:@selector(rejectEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rejectBtn;
}
- (NECustomButton *)acceptBtn {
    if (!_acceptBtn) {
        _acceptBtn = [[NECustomButton alloc] init];
        _acceptBtn.hidden= YES;
//        _acceptBtn.titleLabel.text = @"接听";
        _acceptBtn.exclusiveTouch = YES;
        _acceptBtn.imageView.image = [UIImage imageNamed:@"hangup"];
        _acceptBtn.imageView.contentMode = UIViewContentModeCenter;
        [_acceptBtn addTarget:self action:@selector(acceptEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}
- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [[UIButton alloc] init];
        _switchCameraBtn.hidden = YES;
        [_switchCameraBtn setImage:[UIImage imageNamed:@"call_switch_camera"] forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}
- (NEVideoOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[NEVideoOperationView alloc] init];
        _operationView.layer.cornerRadius = 30;
        // 暂时注释_operationView.hidden = YES;
        [_operationView.switchAudio addTarget:self action:@selector(switchCallTypeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_operationView.microPhone addTarget:self action:@selector(microPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [_operationView.cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_operationView.hangupBtn addTarget:self action:@selector(hangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationView;
}

- (UILabel *)connectingLabel {
    if (!_connectingLabel) {
        _connectingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _connectingLabel.font = [UIFont systemFontOfSize:15];
        _connectingLabel.textColor = [UIColor whiteColor];
        _connectingLabel.textAlignment = NSTextAlignmentCenter;
        _connectingLabel.hidden = YES;
        _connectingLabel.text = @"正在接通...";
    }
    return _connectingLabel;
}

- (AVAudioPlayer *)player {
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_sender" withExtension:@"mp3"];
        if (self.isCalled) {
            url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"mp3"];
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = 30;
    }
    return _player;
}
//录频监听
- (UIView *)lupinmaskView{
    if (!_lupinmaskView) {
        _lupinmaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];
        _lupinmaskView.backgroundColor = [UIColor blackColor];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, ML_ScreenWidth, 100)];
        label.textColor=[UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
        label.numberOfLines=0;
        label.textAlignment=NSTextAlignmentCenter;
        label.text=@"为了保护用户隐私,禁止录屏!";
        [_lupinmaskView addSubview:label];
    }
    return _lupinmaskView;
}

-(void)addluPinNotifacation{
    if (@available(ios 11.0,*)) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDidChange:) name:UIScreenCapturedDidChangeNotification object:nil];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDidChange:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    }
}

- (void)captureDidChange:(NSNotification*)notifacation{
    [[UIApplication sharedApplication].keyWindow addSubview:self.lupinmaskView];
    if ([UIScreen mainScreen].isCaptured) {
        self.lupinmaskView.hidden=NO;
    }else{
        self.lupinmaskView.hidden=YES;
    }
    
}


- (void)dealloc {
    self.lupinmaskView.hidden = YES;
    [self.lupinmaskView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jieMsg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tichuRoom" object:nil];
    [[FUManager shareManager] destoryItems];
    NSLog(@"%@ dealloc%@",[self class],self);
}
@end
