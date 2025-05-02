

#import <Foundation/Foundation.h>

@interface ML_SDCacheManager : NSObject
//存储通用配置
+(instancetype) sharedInstance;
//存储指定用户的缓存
+(instancetype) sharedInstanceWithUserId:(NSString *) userId;

- (void)setObject:( id<NSCoding>)object forKey:(NSString *)key;
- ( id)objectForKey:(NSString *)key;
@end
