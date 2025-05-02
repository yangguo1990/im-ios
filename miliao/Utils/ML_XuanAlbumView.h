
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopItemModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSString *selImgName;
@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic) BOOL isTitle;

+ (PopItemModel *)cancelModel;
+ (NSArray <PopItemModel *>*)toCao;
+ (NSArray <PopItemModel *>*)ToFYInputInfoController;
+ (NSArray <PopItemModel *>*)toFYSearchInfoController;
+ (NSArray <PopItemModel *>*)ToFYProfileControllerWithIsla:(BOOL)isLahei;
+ (NSArray <PopItemModel *>*)TwoToFYProfileControllerWithIsla:(BOOL)isLahei;

+ (NSArray <PopItemModel *>*)toFYChatController;
+ (NSArray <PopItemModel *>*)toInfoController;
+ (NSArray <PopItemModel *>*)toFYShenFenZhengController;

+ (NSArray <PopItemModel *>*)ToFYEditInfoController;

+ (NSArray <PopItemModel *>*)toFYChatController3;
+ (NSArray <PopItemModel *>*)toFYChatController4;

+ (NSArray <PopItemModel *>*)popAudioMoreSetting;
+ (NSArray <PopItemModel *>*)popVideoMoreSetting;

+ (NSArray <PopItemModel *>*)toFYTabBarControllerNvshengRenzheng;
+ (NSArray <PopItemModel *>*)ToYueBuzu;
+ (NSArray <PopItemModel *>*)toAlumQuanXian;

+ (NSArray <PopItemModel *>*)popShareItem;

+ (NSArray <PopItemModel *>*)toWorkplaceApppFabuDTController;

- (instancetype)initTitle:(NSString *)title color:(UIColor *)color imgName:(NSString *)imgName font:(UIFont *)font;

@end

@interface ML_XuanAlbumView : UIView

//+ (void)popXuanAlbumView:(void(^)(NSInteger index))acitonIndex;
+ (void)popItems:(NSArray <PopItemModel *>*)items action:(void(^)(NSInteger index))acitonIndex;

+ (void)popItemsWithView:(UIView *)view items:(NSArray <PopItemModel *>*)items action:(void(^)(NSInteger index))acitonIndex;



@end

NS_ASSUME_NONNULL_END
