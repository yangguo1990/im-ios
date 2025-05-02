
#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, ML_TanchuangViewType) {
    ML_TanchuangViewType_Close = 0,
    ML_TanchuangViewType_MsgListVCMore,
    ML_TanchuangViewType_TishiImg,
    ML_TanchuangViewType_chongzhi,
    ML_TanchuangViewType_lahei,
    ML_TanchuangViewType_pingjia,
    ML_TanchuangViewType_Duihuan,
    ML_TanchuangViewType_DongBao,
    
    ML_TanchuangViewType_jietingXunwen,
    ML_TanchuangViewType_jianli,
    ML_TanchuangViewType_jianliDone,
    ML_TanchuangViewType_lvSheng,
    ML_TanchuangViewType_gxWin,
    ML_TanchuangViewType_gzsm,
    ML_TanchuangViewType_biaobaixin,
    ML_TanchuangViewType_boXunwen,
    ML_TanchuangViewType_jieXunwen,
    ML_TanchuangViewType_gonghuiYaoqing,   //公会邀请
    ML_TanchuangViewType_SignIn,   //签到
    ML_TanchuangViewType_Chong6_98,
    ML_TanchuangViewType_zadan,
};

@interface ML_TanchuangView : UIView
@property(nonatomic,copy) void(^ML_TanchuangClickBlock)(NSInteger tag);
@property (nonatomic, strong) NSMutableArray *notCenterDicArr;
@property (nonatomic, assign)BOOL isBgHideView;
@property (nonatomic, strong) NSDictionary *dic; // 有效key： chuanView.dic = @{@"type" : @(TTYTanchuanViewType_liaoMei), @"imgStr" : @"http://39.108.249.154:8001/pic/fireone.png"};
+ (instancetype)shareInstance;
+ (void)showWithTitle:(NSString *)str;
+ (void)showWithTitle:(NSString *)str time:(int)miao;
+ (void)conterVHidden;
- (void)showFromNotCenterDicArr;
- (void)hideView;
@end


