//
//  ML_UnlockWxAlertView.h
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ML_UnlockWxAlertView : UIView
@property(nonatomic,strong)NSDictionary *dic;

+ (ML_UnlockWxAlertView*)showWithUnlock:(BOOL)isUnlock dic:(NSDictionary*)dic userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
