//
//  FYAppManager.m
//  FanyouApp
//
//  Created by Wei942 on 2021/4/6.
//

#import "FYAppManager.h"

//#import "FYReportController.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
//#import "FYXuanAlbumView.h"

#define kUploadSign @"upload_sign_get"
#define kUserInfo @"self_user_info"
#define kLongitude @"longitude_fy"
#define kLatitude @"latitude_fy"
#define kCityName @"fy_city_name"
#define kOnlineState @"is_online_state"

static NSString *fy_chat_roomid = @"10001";

@interface FYAppManager ()

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isUserYijianLogin;

@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* latitude;

@property (strong, nonatomic) NSString* cityName;
@property (assign, nonatomic) BOOL isOneLineStatus;

@end

@implementation FYAppManager

static id localInstance = nil;
+ (instancetype)shareInstanse {
    if (!localInstance) {
        @synchronized (self) {
            if (!localInstance) {
                localInstance = [[[self class] alloc] init];
            }
        }
    }
    return localInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!localInstance) {
            localInstance = [super allocWithZone:zone];
            return localInstance;
        }
    }
    return nil;
}

- (void)appManagerConfig {
    NSString *longitude = [NSUserDefaults.standardUserDefaults objectForKey:kLongitude];
    NSString *latitude = [NSUserDefaults.standardUserDefaults objectForKey:kLatitude];
    NSString *cityName = [NSUserDefaults.standardUserDefaults objectForKey:kCityName];
    if (!longitude.length) {
        longitude = @"";
    }
    if (!latitude.length) {
        latitude = @"";
    }
    if (!cityName.length) {
        cityName = @"";
    }
    self.longitude = longitude;
    self.latitude = latitude;
    self.cityName = cityName;
    
}

- (void)yijianLoginRight:(BOOL)isRight {
    self.isUserYijianLogin = isRight;
}

//- (BOOL)isLogin {
//    return self.user.user.code;
//}

//- (BOOL)isCanAutoLogin {
//    return (self.isLogin && !self.isLoginIsexpired);
//}

//- (BOOL)isLoginIsexpired
//{
//    if (!self.user.expiredTimestamp.length) {
//        return YES;
//    }
//       NSDate *date = [NSDate date];
//        NSString *timesp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]] ;
//        NSInteger count = [self.user.expiredTimestamp integerValue] - [timesp integerValue];
//    if (count <= 0) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)saveUserInfo:(FYUserData *)user {
//    if (!user) return;
//    NSError *error = nil;
//    NSData *userParam = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:NO error:&error];
////    NSData *userParam = [NSKeyedArchiver archivedDataWithRootObject:user];
//    if (!error) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:userParam forKey:kUserInfo];
//    }
//
//}

- (void)zhuxiaoAccount {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
}

//- (FYUserData *)user {
//    NSData *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
//    if (loginData) {
//        FYUserData *user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
//        return user;
//    }
//    return nil;
//}
//
//- (FYUploadSignData *)uploaadSignData {
//    NSData *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kUploadSign];
//    if (loginData) {
//        FYUploadSignData *user = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
//        return user;
//    }
//    return nil;
//}
//
//- (void)ry_loginWithUser:(FYUserData *)user success:(void (^)(NSString *userId))successBlock {
//    @weakify(self);
//    if (!user.userThirdPlatform.rongCloudId.length) {
//        kToast(@"用户不存在")
//        return;
//    }
//    
//    [FYIM.sharedFYIM connectWithToken:user.userThirdPlatform.rongCloudId dbOpened:^(RCDBErrorCode code) {
//            
//        } success:^(NSString *userId) {
//            
//            [weak_self fy_joinChatRoom];
//            
//            [weak_self saveUserInfo:user];
//
//            
//            RCUserInfo *userInfo =   [[RCUserInfo alloc]init];
//            userInfo.userId = user.user.idField;
//            userInfo.name = user.user.name;
//            userInfo.portraitUri = user.user.icon;
//            [[FYIM sharedFYIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
//            
//            successBlock(userId);
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [NSNotificationCenter.defaultCenter postNotificationName:kLoginSuccessful object:nil];
//                
//                if (user.user.osNotify) {
//                    if (![FYAppManager systemNotificationStatus]) {
//                        [FYNormalModel model_POST:@"/api/user/update_os_notify" paramtter:@{@"osNotify":@(0)} result:^(id  _Nonnull model, NSString * _Nonnull error) {
//                                                
//                        }];
//                    }
//                }
//                else {
//                    if ([FYAppManager systemNotificationStatus]) {
//                        [FYNormalModel model_POST:@"/api/user/update_os_notify" paramtter:@{@"osNotify":@(1)} result:^(id  _Nonnull model, NSString * _Nonnull error) {
//                                                
//                        }];
//                    }
//                }
//            });
//            
//        } error:^(RCConnectErrorCode errorCode) {
//            [SVProgressHUD dismiss];
//            kToast(@"登录失败")
//        }];
//}


+ (BOOL)systemNotificationStatus {
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {

        return NO;
    }else{
        return YES;

    }
}

- (void)uploadLongitude:(NSString *)longitude latitude:(NSString *)latitude {
    self.longitude = longitude;
    self.latitude = latitude;
    
    [NSUserDefaults.standardUserDefaults setObject:longitude forKey:kLongitude];
    [NSUserDefaults.standardUserDefaults setObject:latitude forKey:kLatitude];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)uploadCityName:(NSString *)name {
    self.cityName = name;
    
    [NSUserDefaults.standardUserDefaults setObject:name forKey:kCityName];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)removeLocationInfo {
    self.longitude = @"";
    self.latitude = @"";
    
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kLongitude];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kLatitude];
}

- (void)uploadOnLineState:(BOOL)state {
    self.isOneLineStatus = state;
    
    [NSUserDefaults.standardUserDefaults setBool:state forKey:kOnlineState];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)initOnlineState
{
    _isOneLineStatus = [NSUserDefaults.standardUserDefaults boolForKey:kOnlineState];
}
- (void)updateImageLoadRequest {
    
//    if (self.isLogin) {
//        if (self.uploaadSignData) {
//            NSDate *date = [NSDate date];
//            NSString *timesp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]] ;
//            NSInteger count = [self.uploaadSignData.expire integerValue] - [timesp integerValue];
//            if (count < 300) {
//                [self uploadSignRequestSuccess:nil];
//            }
//        }
//        else {
//            [self uploadSignRequestSuccess:nil];
//        }
//    }
}

- (void)uploadSignRequestSuccess:(void(^)(void))success {
    
//    [FYUploadSignModel model_GET:@"/api/common/upload_signature" paramtter:nil result:^(FYUploadSignModel *model, NSString * _Nonnull error) {
//        if (model.code==200) {
//            if (!model.data) return;
//            NSError *error = nil;
//            NSData *userParam = [NSKeyedArchiver archivedDataWithRootObject:model.data requiringSecureCoding:NO error:&error];
//            if (!error) {
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:userParam forKey:kUploadSign];
//                if (success) {
//                    success();
//                }
//            }
//        }
//    }];
}


////保存美肤参数
//+(void)saveBeautySkinArrays:(NSArray *)items
//{
//    [NSKeyedArchiver archiveRootObject:items toFile:LocalSaveBeatulySkinParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//}
////从本地获取美肤参数
//+(NSArray *)getBeautySkinArrays
//{
//    NSArray *skinArray = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulySkinParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//    return  skinArray;
//}
//
////保存美形参数
//+(void)saveBeautyShapeArrays:(NSArray *)items
//{
//    [NSKeyedArchiver archiveRootObject:items toFile:LocalSaveBeatulyShapeParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//}
////从本地获取美行参数
//+(NSArray *)getBeautyShapeArrays
//{
//    NSArray *shapeArray = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulyShapeParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//    return  shapeArray;
//}
//
////保存滤镜参数
//+(void)saveBeautyFilters:(FUBeautyParam *)param
//{
//    [NSKeyedArchiver archiveRootObject:param toFile:LocalSaveBeatulyFilterParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//}
////从本地获取滤镜参数
//+(FUBeautyParam *)getBeautyFilterParam
//{
//    
//    FUBeautyParam *parameter = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulyFilterParameter([UserLocalDataTool getLoginUserMessage].user.ID)];
//    return  parameter;
//}

- (void)fy_funcGetCongfig {
    
    
//    @weakify(self);
//    [FYConfigModel model_GET:@"/api/common/config" paramtter:nil result:^(FYConfigModel *model, NSString * _Nonnull error) {
//        if (model.code == 200) {
//            weak_self.configData = model.data;
//        }
//    }];
}

//- (BOOL)isGay:(NSInteger)otherSex {
//    return FYAppManager.shareInstanse.user.user.sex == otherSex;
//}

#pragma mark - 举报和拉黑
- (void)fy_jubaoUser:(NSString *)uid name:(NSString *)name {
//    NSArray <NSString *>*titles = @[@"资料造假",@"恶意骚扰",@"垃圾广告",@"色情低俗",@"诱导欺骗"];
//    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    for (int i = 0; i < titles.count; i++) {
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            FYReportController *reporet = [[FYReportController alloc] init];
//            reporet.reportType = titles[i];
//            reporet.reportUserid = uid;
//            reporet.reportUserName = name;
//            [AppDelegate.sharedInstance pushViewController:reporet animated:YES];
//        }];
//
//        [alterController addAction:action];
//    }
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
//    [alterController addAction:cancelAction];
//    [AppDelegate.sharedInstance.window.rootViewController presentViewController:alterController animated:YES completion:nil];
}

- (void)fy_laheiUser:(NSString *)uid {
//    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:@"确定要拉黑吗？拉黑后你将不再收到对方的消息或者通话请求" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        [FYNormalModel model_POST:@"/api/black/add" paramtter:@{@"blackUserId" : nonNil(uid), @"userId" : nonNil(FYAppManager.shareInstanse.user.user.idField)} result:^(FYNormalModel *model, NSString * _Nonnull error) {
//            if (model.code == 200) {
//                kToast(@"拉黑成功")
//                [AppDelegate.sharedInstance popViewController:YES];
//
//            }
//            else {
//                kToast(@"拉黑失败")
//            }
//        }];
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    [alterController addAction:action];
//    [alterController addAction:cancel];
//    [AppDelegate.sharedInstance.window.rootViewController presentViewController:alterController animated:YES completion:nil];
}

//- (NSMutableArray<FYWallScrollItem *> *)fixList {
//    if (!_fixList) {
//        _fixList = [NSMutableArray array];
//    }
//    return _fixList;
//}
//
//-(NSMutableArray<FYWallScrollItem *> *)normalList {
//    if (!_normalList) {
//        _normalList = [NSMutableArray array];
//    }
//    return _normalList;
//}

- (void)fy_joinChatRoom {
    
//    [RCIMClient.sharedRCIMClient joinExistChatRoom:fy_chat_roomid messageCount:-1 success:^{
//
//        } error:^(RCErrorCode status) {
//
//        }];
}


/// 退出登录
/// @param success 退出登录后成功的回掉
- (void)fy_exitLoginSuccess:(void(^)(BOOL isSuccess))success {
    
//    @weakify(self);
//    [RCIMClient.sharedRCIMClient quitChatRoom:fy_chat_roomid success:^{
//        [weak_self zhuxiaoAccount];
//        [RCIMClient.sharedRCIMClient logout];
//        success(YES);
//    } error:^(RCErrorCode status) {
//        success(NO);
//    }];
}


//保存美肤参数
- (void)fy_saveBeautySkinArrays:(NSArray *)items
{
    [NSKeyedArchiver archiveRootObject:items toFile:LocalSaveBeatulySkinParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
}
//从本地获取美肤参数
- (NSArray *)fy_getBeautySkinArrays
{
    NSArray *skinArray = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulySkinParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
    return  skinArray;
}

//保存美形参数
- (void)fy_saveBeautyShapeArrays:(NSArray *)items
{
    [NSKeyedArchiver archiveRootObject:items toFile:LocalSaveBeatulyShapeParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
}
//从本地获取美行参数
- (NSArray *)fy_getBeautyShapeArrays
{
    NSArray *shapeArray = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulyShapeParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
    return  shapeArray;
}

//保存滤镜参数
- (void)fy_saveBeautyFilters:(FUBeautyParam *)param
{
    [NSKeyedArchiver archiveRootObject:param toFile:LocalSaveBeatulyFilterParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
}
//从本地获取滤镜参数
- (FUBeautyParam *)fy_getBeautyFilterParam
{
    
    FUBeautyParam *parameter = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalSaveBeatulyFilterParameter([ML_AppUserInfoManager sharedManager].currentLoginUserData.userId)];
    return  parameter;
}

//- (NSArray<FYMessageModel *> *)fy_getHistoryMessages:(FYMessageModel *)model
//                                                   count:(NSInteger)count
//                                                   times:(int)times {
//    NSArray<FYMessageModel *> *imageArrayForward =
//        [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE
//                                                 targetId:model.targetId
//                                               objectName:[RCImageMessage getObjectName]
//                                            baseMessageId:model.messageId
//                                                isForward:true
//                                                    count:(int)count];
//    NSArray *messages = [self filterDestructImageMessage:imageArrayForward];
//    if (times < 2 && imageArrayForward.count == count && messages.count == 0) {
//        messages = [self fy_getHistoryMessages:imageArrayForward.lastObject count:count times:times + 1];
//    }
//    return messages;
//}
//
//- (NSArray<FYMessageModel *> *)fy_getLaterMessagesThanModel:(FYMessageModel *)model
//                                                   count:(NSInteger)count
//                                                   times:(int)times {
//    NSArray<FYMessageModel *> *imageArrayBackward =
//        [[RCIMClient sharedRCIMClient] getHistoryMessages:model.conversationType
//                                                 targetId:model.targetId
//                                               objectName:[RCImageMessage getObjectName]
//                                            baseMessageId:model.messageId
//                                                isForward:false
//                                                    count:(int)count];
//    NSArray *messages = [self filterDestructImageMessage:imageArrayBackward];
//    if (times < 2 && messages.count == 0 && imageArrayBackward.count == count) {
//        messages = [self fy_getLaterMessagesThanModel:imageArrayBackward.lastObject count:count times:times + 1];
//    }
//    return messages;
//}



//过滤阅后即焚图片消息
- (NSArray *)filterDestructImageMessage:(NSArray *)array {
    NSMutableArray *backwardMessages = [NSMutableArray array];
//    for (FYMessageModel *model in array) {
//        if (!(model.content.destructDuration > 0)) {
//            [backwardMessages addObject:model];
//        }
//    }
    return backwardMessages.copy;
}

// 打开相机
- (void)fy_openCamerePage:(UIViewController *)page complte:(void(^)(BOOL isSuccess))success {
//    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
//        [FYXuanAlbumView popItemsWithView:page.view items:[FYPopItemModel toAlumQuanXian] action:^(NSInteger index) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
//    }
//    else {
//        success(YES);
//    }
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
        [self requestCameraAccess:^(BOOL granted) {
            if (granted) {
                success(YES);
            } else {
                [self checkAndAlertCameraAccessRight:page];
            }
        }];
    } else {
        if ([self checkAndAlertCameraAccessRight:page]) {
            success(YES);
        }
    }
}

- (void)requestCameraAccess:(void (^)(BOOL granted))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                handler(YES);
            } else {
                handler(NO);
            }
        });
    }];
}

- (BOOL)checkAndAlertCameraAccessRight:(UIViewController *)page {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:RCLocalizedString(@"AccessRightTitle") message:RCLocalizedString(@"cameraAccessRight") preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"确定", nil) style:UIAlertActionStyleCancel handler:nil];
            
            [alterController addAction:cancelAction];
            [page presentViewController:alterController animated:YES completion:nil];
        });
        return NO;
    }
    return YES;
}

@end
