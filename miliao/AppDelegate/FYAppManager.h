//
//  FYAppManager.h
//  FanyouApp
//
//  Created by Wei942 on 2021/4/6.
//

#import <Foundation/Foundation.h>

//#import "FYUserModel.h"
//#import "FYUploadSignModel.h"
//#import "FYConfigModel.h"
//#import "FYWallScrollModel.h"
//#import "FYCheckVersionModel.h"
#import "FUBeautyParam.h"

#define LocalSaveBeatulySkinParameter(userid) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_LocalSaveBeatulySkinParameter.archive",userid]]

#define LocalSaveBeatulyShapeParameter(userid) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_LocalSaveBeatulyShapeParameter.archive",userid]]

#define LocalSaveBeatulyFilterParameter(userid) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_LocalSaveBeatulyFilterParameter.archive",userid]]


NS_ASSUME_NONNULL_BEGIN

@interface FYAppManager : NSObject

@property (assign, nonatomic, readonly) BOOL isUserYijianLogin;

@property (strong, nonatomic, readonly) NSString* longitude;
@property (strong, nonatomic, readonly) NSString* latitude;

@property (assign, nonatomic, readonly) BOOL isOneLineStatus;


@property (strong, nonatomic, readonly) NSString* cityName;

/**App 配置信息*/
//@property (strong, nonatomic) FYConfigData* configData;
//
//@property (strong, nonatomic) FYCheckVersionData2* checkData2;
//
//
//@property (strong, nonatomic) NSMutableArray <FYWallScrollItem *>* fixList;
//@property (strong, nonatomic) NSMutableArray <FYWallScrollItem *>* normalList;

+ (instancetype)shareInstanse;

- (void)yijianLoginRight:(BOOL)isRight;

//- (FYUserData *)user;
//- (void)saveUserInfo:(FYUserData *)user;

//- (void)ry_loginWithUser:(FYUserData *)user success:(void (^)(NSString *userId))successBlock;

- (BOOL)isLogin;
- (BOOL)isCanAutoLogin;
- (void)zhuxiaoAccount;


/// 启动初始化设置
- (void)appManagerConfig;

/// 更新经纬度
/// @param longitude 经度
/// @param latitude 纬度
- (void)uploadLongitude:(NSString *)longitude latitude:(NSString *)latitude;

/// 移除定位的Key
- (void)removeLocationInfo;


/// 保存城市定位
/// @param name 定位城市名称
- (void)uploadCityName:(NSString *)name;

- (void)uploadOnLineState:(BOOL)state;
//初始化值
- (void)initOnlineState;

/// 获取上传图片签名
- (void)updateImageLoadRequest;
- (void)uploadSignRequestSuccess:(void(^)(void))success;
//- (FYUploadSignData *)uploaadSignData;


/// 服务器请求app中一些功能数据和参数配置
- (void)fy_funcGetCongfig;

/// 举报用户：FYDChatViewController    FYProfileController
/// @param uid 被举报用户的ID
/// @param name 被举报用户昵称
- (void)fy_jubaoUser:(NSString *)uid name:(NSString *)name;


/// 拉黑用户：FYDChatViewController    FYProfileController
/// @param uid 被拉黑用户的ID
- (void)fy_laheiUser:(NSString *)uid;


/// 判断是否同性
/// @param otherSex 对方性别参数
- (BOOL)isGay:(NSInteger)otherSex;


///  飘屏功能
- (void)fy_joinChatRoom;


/// 退出登录
/// @param success 退出登录后成功的回掉
- (void)fy_exitLoginSuccess:(void(^)(BOOL isSuccess))success;


//保存美肤参数
- (void)fy_saveBeautySkinArrays:(NSArray *)items;
//从本地获取美肤参数
- (NSArray *)fy_getBeautySkinArrays;

//保存美形参数
- (void)fy_saveBeautyShapeArrays:(NSArray *)items;
//从本地获取美行参数
- (NSArray *)fy_getBeautyShapeArrays;

//保存滤镜参数
- (void)fy_saveBeautyFilters:(FUBeautyParam *)param;
//从本地获取滤镜参数
- (FUBeautyParam *)fy_getBeautyFilterParam;

/*!
 获取会话中，指定消息、指定数量、指定消息类型、向前或向后查找的消息实体列表
 @param count               需要获取的消息数量
 @return                    消息实体 RCMessage 对象列表

 @discussion
 此方法会获取该会话中，baseMessageId
 之前或之后的、指定数量、消息类型和查询方向的最新消息实体，返回的消息实体按照时间从新到旧排列。
 返回的消息中不包含 baseMessageId 对应的那条消息，如果会话中的消息数量小于参数 count 的值，会将该会话中的所有消息返回。

 @remarks 消息操作
 */
//- (NSArray<FYMessageModel *> *)fy_getHistoryMessages:(FYMessageModel *)model
//                                                   count:(NSInteger)count
//                                               times:(int)times;
//
//- (NSArray<FYMessageModel *> *)fy_getLaterMessagesThanModel:(FYMessageModel *)model
//                                                   count:(NSInteger)count
//                                                      times:(int)times;


/// 使用相机之前的权限判断
/// @param success 成功返回
- (void)fy_openCamerePage:(UIViewController *)page complte:(void(^)(BOOL isSuccess))success;

@end

NS_ASSUME_NONNULL_END
