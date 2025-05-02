
#import "ML_BaseVC.h"
#import "ICMusicPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICMusicPlayListVC : ML_BaseVC

@property(nonatomic, strong) NSArray *allListModelArray;

@property(nonatomic, strong) ICMusicPlayModel *currentModel;

@property(nonatomic, assign) BOOL isPlaying;

@property(nonatomic, copy) void(^readPlayMusic)(NSInteger currentSelectTimeListIndex,ICMusicPlayModel *model);
@end

NS_ASSUME_NONNULL_END
