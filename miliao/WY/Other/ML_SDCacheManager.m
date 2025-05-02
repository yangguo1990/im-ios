

#import "ML_SDCacheManager.h"
#import "NTESFileLocationHelper.h"
#import "YYDiskCache.h"


@interface ML_SDCacheManager()
@property(nonatomic,copy) NSString * cacheOnePath;
@property(nonatomic,strong) YYDiskCache * diskCache;
@end

static NSMutableDictionary *instances;
static NSObject * safeLockObjec ;

@implementation ML_SDCacheManager
//存储通用配置
+(instancetype) sharedInstance
{
    static ML_SDCacheManager * _instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.cacheOnePath = @"";
        _instance.diskCache = [[YYDiskCache alloc] initWithPath:[_instance diskCachePath] inlineThreshold:NSUIntegerMax];
    });
    return _instance;
}
//存储指定用户的缓存
+(instancetype) sharedInstanceWithUserId:(NSString *) userId{
    if(!userId.length){
        return [self sharedInstance];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [NSMutableDictionary dictionary];
        safeLockObjec = [NSObject new];
    });
    ML_SDCacheManager * _instance = nil;
    @synchronized (safeLockObjec) {
        _instance = instances[userId];
        if(!_instance){
            _instance = [[self alloc] init];
            _instance.cacheOnePath = userId;
            _instance.diskCache = [[YYDiskCache alloc] initWithPath:[_instance diskCachePath] inlineThreshold:NSUIntegerMax];
            instances[userId] = _instance;
        }
        
    }
    return _instance;
}

-(NSString *) diskCachePath
{
    NSString * basePath = [NTESFileLocationHelper getAppDocumentPath];
    if([_cacheOnePath isKindOfClass:[NSString class]] &&  _cacheOnePath.length){
        basePath = [basePath stringByAppendingPathComponent:_cacheOnePath];
    }
    return  [basePath stringByAppendingPathComponent:@"LVkvFile"];
}

- (void)setObject:( id<NSCoding>)object forKey:(NSString *)key
{
    NSData *data = [NSData data];
    if (object)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:object];
        if(data.length){
            data = SkyEyeUtil->deodeDataWithXor(data);
        }
    }
    
    
    [_diskCache setObject:data forKey:key];

}

- ( id)objectForKey:(NSString *)key{
    id data = [_diskCache objectForKey:key];
    if(data){
        data = SkyEyeUtil->deodeDataWithXor(data);
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return object;
    }

    return nil;
}


@end
