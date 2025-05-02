//
//  CMVideoRecordView.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#define NOTIFICATION_RESIGN_ACTIVE              @"appResignActive"
#define NOTIFICATION_BECOME_ACTIVE              @"appBecomeActive"

#import "CMVideoRecordView.h"
#import "CMVideoRecordPlayer.h"
#import "CMVideoRecordManager.h"
#import "CMVideoRecordProgressView.h"
#import "ML_getUploadToken.h"
#import "ML_MineEditViewController.h"
#import "MLMineHostRenzhengViewController.h"
@interface CMVideoRecordView ()<CMVideoRecordDelegate>
@property (nonatomic, strong)NSURL *outputFilePath;
@property (nonatomic, strong) CMVideoRecordManager *recorderManager;
@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordBackView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) CMVideoRecordProgressView *progressView;
@property (nonatomic, strong) NSURL *recordVideoUrl;
@property (nonatomic, strong) NSURL *recordVideoOutPutUrl;
@property (nonatomic, assign) BOOL videoCompressComplete;
@property (nonatomic, strong) CMVideoRecordPlayer *playView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic,strong) dispatch_source_t timer;

@property (nonatomic,assign) int timerCount;
@property (nonatomic,strong)UIImageView *masImageView;
@end

@implementation CMVideoRecordView

- (void)initTimer
{
    
    __block int count = 0;
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
        weakself.timeLabel.text = [NSString stringWithFormat:@"%d%@", count, Localized(@"秒", nil)];
        weakself.timerCount = count;

        
    });
//    dispatch_source_cancel(self.timer);
    dispatch_resume(self.timer);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_navView.hidden = YES;
    [self initSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActiveToRecordState)
                                                 name:NOTIFICATION_RESIGN_ACTIVE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveToRecordState)
                                                 name:NOTIFICATION_BECOME_ACTIVE
                                               object:nil];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    [_contentView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(self->_contentView.mas_left).mas_offset(16);
        make.top.mas_equalTo(self->_contentView.mas_top).mas_offset(55);
    }];
    
    
    self.masImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.masImageView.image = kGetImage(@"masIV");
    [self.view addSubview:self.masImageView];
    self.masImageView.userInteractionEnabled = YES;
    UIButton *backBt = [[UIButton alloc]initWithFrame:CGRectMake(16, 55, 80, 60)];
    [self.masImageView addSubview:backBt];
    [backBt addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bottomBt = [[UIButton alloc]initWithFrame:CGRectMake(16*mWidthScale, 730*mHeightScale, 343*mWidthScale, 48*mHeightScale)];
    [self.masImageView addSubview:bottomBt];
    [bottomBt addTarget:self action:@selector(goshipin:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goshipin:(UIButton*)sender{
    [self.masImageView removeFromSuperview];
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.ML_navView.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playView.player pause];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)resignActiveToRecordState {
    if (self.playView.player) {
        [self.playView.player pause];
    }
}

- (void)becomeActiveToRecordState {
    if (self.playView.player) {
        [self.playView.player play];
    }
}


#pragma mark - 初始化视图
- (void)initSubViews {
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    _recorderManager = [[CMVideoRecordManager alloc] init];
    _recorderManager.delegate = self;
    [_contentView.layer addSublayer:self.recorderManager.preViewLayer];
    _recorderManager.preViewLayer.frame = CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight - 296);
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [_contentView addSubview:_bottomView];
    [_contentView addSubview:self.recordBackView];
    [_contentView addSubview:self.backButton];
    [_contentView addSubview:self.tipLabel];
    //[_contentView addSubview:self.switchCameraButton];
    [_contentView addSubview:self.progressView];
    [_contentView addSubview:self.recordBtn];
    [_contentView addSubview:self.focusImageView];
    [_contentView bringSubviewToFront:_recordBtn];
    [self addFocusGensture];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(296);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"视频认证", nil);
    titlelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_bottomView.mas_centerX);
        make.top.mas_equalTo(self->_bottomView.mas_top).mas_offset(12);
    }];

    UILabel *titlelabelone = [[UILabel alloc]init];
    titlelabelone.text = @"·拍摄3-10秒视频，通过审核有丰富奖励";
    titlelabelone.numberOfLines = 0;
    titlelabelone.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabelone.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabelone.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:titlelabelone];
    [titlelabelone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_bottomView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self->_bottomView.mas_right).mas_offset(-5);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(14);
    }];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 50, ML_ScreenHeight - 160, 100, 30)];
    self.timeLabel.text = [NSString stringWithFormat:@"0%@", Localized(@"秒", nil)];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:self.timeLabel];
}

#pragma mark - 点按时聚焦

- (void)addFocusGensture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_contentView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point= [tapGesture locationInView:self.contentView];
    if (150 < point.y && point.y < self.view.frame.size.height - 200) {
        [self setFocusCursorWithPoint:point];
        [self.recorderManager setFoucusWithPoint:point];
    }
}

- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.focusImageView.alpha = 1;
        self.focusImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(autoHideFocusImageView) withObject:nil afterDelay:1];
    }];
}

- (void)autoHideFocusImageView {
    self.focusImageView.alpha = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _recorderManager.preViewLayer.frame = self.view.bounds;
}

- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"record_video_focus"]];
        _focusImageView.alpha = 0;
        _focusImageView.frame = CGRectMake(0, 0, 75, 75);
    }
    return _focusImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"record_video_back"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(60, self.recordBtn.center.y - 18, 36, 36);
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CMVideoRecordProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[CMVideoRecordProgressView alloc] initWithFrame:self.recordBackView.frame];
    }
    return _progressView;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraButton setImage:[UIImage imageNamed:@"record_video_camera"] forState:UIControlStateNormal];
        _switchCameraButton.frame = CGRectMake(self.view.frame.size.width - 20 - 28, 40, 30, 28);
        [_switchCameraButton addTarget:self action:@selector(clickSwitchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

- (UIView *)recordBackView {
    if (!_recordBackView) {
        CGRect rect = self.recordBtn.frame;
        CGFloat gap = 7.5;
        rect.size = CGSizeMake(rect.size.width + gap*2, rect.size.height + gap*2);
        rect.origin = CGPointMake(rect.origin.x - gap, rect.origin.y - gap);
        _recordBackView = [[UIView alloc]initWithFrame:rect];
        _recordBackView.backgroundColor = [UIColor whiteColor];
        _recordBackView.alpha = 0.6;
        [_recordBackView.layer setCornerRadius:_recordBackView.frame.size.width/2];
    }
    return _recordBackView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 180)/2, self.recordBackView.frame.origin.y + 80, 180, 20)];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"长按拍摄";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipLabel;
}

- (UIView *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIView alloc] init];
        CGFloat deta = [UIScreen mainScreen].bounds.size.width/375;
        CGFloat width = 60.0*deta;
        _recordBtn.frame = CGRectMake((self.view.frame.size.width - width)/2, self.view.frame.size.height - 107*deta, 60, 60);
        [_recordBtn.layer setCornerRadius:_recordBtn.frame.size.width/2];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        // 长按时间
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
        [_recordBtn addGestureRecognizer:press];
        // 点击事件
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
//        [_recordBtn addGestureRecognizer:tap];
//        _recordBtn.userInteractionEnabled = YES;
    }
    return _recordBtn;
}

#pragma mark - 点击事件
- (void)clickSwitchCamera {
    [self.recorderManager switchCamera];
}

- (void)clickBackButton {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)takePicture:(UITapGestureRecognizer *)gesture {
    [self.recorderManager takePhoto];
}


#pragma mark - 开始录制
- (void)startRecord:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        self.timerCount = 0;
        
        [self initTimer];
        NSLog(@"adfadf");
        
        self.recordVideoUrl = nil;
        self.videoCompressComplete = NO;
        self.recordVideoOutPutUrl = nil;
        //[self startRecordAnimate];
        CGRect rect = self.progressView.frame;
        rect.size = CGSizeMake(self.recordBackView.frame.size.width + 3 , self.recordBackView.frame.size.height + 3);
        rect.origin = CGPointMake(self.recordBackView.frame.origin.x + 1.5, self.recordBackView.frame.origin.y + 1.5);
        //rect.size = CGSizeMake(self.recordBackView.frame.size.width - 3, self.recordBackView.frame.size.height - 3);
        //rect.origin = CGPointMake(self.recordBackView.frame.origin.x + 1.5, self.recordBackView.frame.origin.y + 1.5);
        self.progressView.frame = self.recordBackView.frame;
        self.backButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        NSURL *url = [NSURL fileURLWithPath:[CMVideoRecordManager cacheFilePath:YES]];
        [self.recorderManager startRecordToFile:url];
    } else if(gesture.state >= UIGestureRecognizerStateEnded) {
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateCancelled) {
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateFailed) {
        [self stopRecord];
    }
}

- (void)startRecordAnimate {
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(0.66, 0.66);
        self.recordBackView.transform = CGAffineTransformMakeScale(6.5/5, 6.5/5);
    }];
}

#pragma mark - 停止录制
- (void)stopRecord {
//    self.timeLabel.text = @"0秒";
//    self.timerCount = 0;

    dispatch_source_cancel(self.timer);
    
    [self.recorderManager stopCurrentVideoRecording];
}

#pragma mark - 录制结束循环播放视频
- (void)showVedio:(NSURL *)playUrl {
    
    dispatch_source_cancel(self.timer);
    CMVideoRecordPlayer *playView= [[CMVideoRecordPlayer alloc] initWithFrame:self.view.bounds];
    playView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:playView];
    [_contentView bringSubviewToFront:self.timeLabel];
    playView.playUrl = playUrl;
    __weak typeof(self) weakSelf = self;
    playView.cancelBlock = ^{
        weakSelf.playView = nil;
        [weakSelf clickCancel];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"0%@", Localized(@"秒", nil)];
        weakSelf.timerCount = 0;
    };
    playView.confirmBlock = ^{
        if (!weakSelf.outputFilePath) {
            return ;
        }
        [weakSelf saveVideo];
        if (weakSelf.videoCompletionBlock && weakSelf.recordVideoOutPutUrl) {
            weakSelf.videoCompletionBlock(weakSelf.recordVideoOutPutUrl);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };
    self.playView = playView;
    
    if (self.timerCount < 3) {
        kplaceToast(Localized(@"请录制不小于3秒的视频",nil));
        
        dispatch_source_cancel(self.timer);
        [self.playView.player pause];
        [self.playView removeFromSuperview];
            self.playView = nil;
            [self clickCancel];
        self.timeLabel.text = [NSString stringWithFormat:@"0%@", Localized(@"秒", nil)];
        self.timerCount = 0;
    }
}

- (void)saveVideo {
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.recordVideoUrl path])) {
        //保存视频到相簿
        UISaveVideoAtPathToSavedPhotosAlbum([self.recordVideoUrl path], self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //NSLog(@"保存视频完成--%@",videoPath);
   // 发发发
    [self didFinishRecordingToOutputFilePathvideo];

}

- (void)didFinishRecordingToOutputFilePathvideo
{
    [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
    NSData *data = [[NSData alloc] initWithContentsOfURL:self.outputFilePath];
    kSelf;
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId] dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        kSelf2;
        [ML_CommonApi  uploadImages:@[data] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
            [SVProgressHUD dismiss];
            [weakself2 saveClickWithUrlStr:url];
        }];
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        kplaceToast(@"上传失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        kplaceToast(@"上传失败");
    }];
}

-(void)saveClickWithUrlStr:(NSString *)url{
    dispatch_sync(dispatch_get_main_queue(), ^{
        MLMineHostRenzhengViewController *vc = [[MLMineHostRenzhengViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

- (void)savePhoto:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if (error != NULL) {
        msg = Localized(@"保存图片失败", nil);
    } else {
        msg = Localized(@"保存图片成功", nil);
    }
    NSLog(@"%@", msg);
}

- (void)compressVideo {
//    __weak typeof(self) instance = self;
//    [self.recorderManager compressVideo:self.recordVideoUrl complete:^(BOOL success, NSURL *outputUrl) {
//        if (success && outputUrl) {
//            instance.recordVideoOutPutUrl = outputUrl;
//        }
//        instance.videoCompressComplete = YES;
//    }];
    
    NSURL *sourceURL = self.recordVideoUrl;
//    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
//    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。

    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    
    
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    kSelf;
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        //  NSLog(resultPath);
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse= YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusCompleted:
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                         weakself.recordVideoOutPutUrl = exportSession.outputURL;
                     //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                     weakself.outputFilePath = exportSession.outputURL;
                     break;
                 case AVAssetExportSessionStatusFailed:
                  
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
             }
               
         }];
      
}


#pragma mark - 取消录制的视频
- (void)clickCancel {
//    self.timeLabel.text = @"0秒";
//    self.timerCount = 0;
    dispatch_source_cancel(self.timer);
    
    self.recordBtn.transform = CGAffineTransformMakeScale(1, 1);
    self.recordBackView.transform = CGAffineTransformMakeScale(1, 1);
    [self.recorderManager prepareForRecord];
    self.backButton.hidden = NO;
    self.tipLabel.hidden = NO;
    self.switchCameraButton.hidden = NO;
}

#pragma mark - JCVideoRecordManagerDelegate method
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    [self.progressView setProgress:0];
    if (!error) {
        //播放视频
        self.recordVideoUrl = outputFileURL;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showVedio:outputFileURL];
        });
        [self compressVideo];
    }
}

- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime {
    self.progressView.totolProgress = totalTime;
    self.progressView.progress = currentTime;
}

- (void)takePhotoCompletedWithImage:(UIImage *)image error:(NSError *)error {
    CMVideoRecordPlayer *playView= [[CMVideoRecordPlayer alloc] initWithFrame:self.view.bounds];
    playView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:playView];
    playView.image = image;
    __weak typeof(self) weakSelf = self;
    playView.cancelBlock = ^{
        [weakSelf clickCancel];
    };
    playView.confirmBlock = ^{
        [weakSelf savePhoto:image];
        if (weakSelf.photoCompletionBlock) {
            weakSelf.photoCompletionBlock(image);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };
}
- (void)dealloc {
    if (self.timer == nil) {
        return;
    }
    dispatch_source_cancel(self.timer);
    NSLog(@"orz   dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RESIGN_ACTIVE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_BECOME_ACTIVE object:nil];
}

@end
