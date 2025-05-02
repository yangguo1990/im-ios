//
//  MLRecommendViewController.h
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , ML_NearbyRecommendType)
{
    ML_Recommend = 0,//推荐
    ML_Nearby,//附近
};

@interface ML_NearbyRecommendVC : UIViewController<JXCategoryListContentViewDelegate>

- (instancetype)initDataType:(ML_NearbyRecommendType)type;

@end

NS_ASSUME_NONNULL_END
