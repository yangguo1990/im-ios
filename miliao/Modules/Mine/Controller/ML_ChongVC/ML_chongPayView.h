//
//  ML_chongPayView.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import <UIKit/UIKit.h>
#import "ZMAliInfos.h"
NS_ASSUME_NONNULL_BEGIN

@interface ML_chongPayView : UIView
@property(nonatomic,copy)void (^payCallBack)(NSInteger payWay);
@property(nonatomic,strong)NSArray *paylist;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZMAliInfos *aliInfo;
+ (void)showWithPaylist:(NSArray*)payList payCallBack:(void(^)(NSInteger payWay))callback type:(NSInteger)type zmaliinfo:(ZMAliInfos*)aliinfo;

@end

NS_ASSUME_NONNULL_END
