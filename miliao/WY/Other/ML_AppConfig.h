
#import <Foundation/Foundation.h>

@interface ML_AppConfig : NSObject
+ (instancetype)sharedManager;

@property (nonatomic,strong)    NSDictionary   * configDic;
@property (nonatomic,strong)    NSArray   *giftArr;
@end

