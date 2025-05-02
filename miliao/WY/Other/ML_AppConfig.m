

#import "ML_AppConfig.h"
#import "NTESFileLocationHelper.h"
#import "SkyEyeFucatorUtil.h"

@interface ML_AppConfig ()
@property (nonatomic,copy)  NSString    *filepath;
@property (nonatomic,copy)  NSString    *dmFilePath;
@end

@implementation ML_AppConfig

+ (instancetype)sharedManager
{
    static ML_AppConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filepath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:@".lv_global_config"];
        NSString *dmFilePath =  [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:@".lv_dm_config"];
        instance = [[ML_AppConfig alloc] initWithPath:filepath dmPath:dmFilePath];
    });
    return instance;
}


- (instancetype)initWithPath:(NSString *)filepath dmPath:(NSString *) dmFilePath
{
    if (self = [super init])
    {
        _filepath = filepath;
        _dmFilePath = dmFilePath;
        [self readData];
        [self readDMData];
    }
    return self;
}


- (void)setConfigDic:(NSDictionary *)configDic
{
    @synchronized (self) {
        _configDic = configDic;
        [self saveData];
    }
}

-(void) setGiftArr:(NSArray *)giftArr
{
    @synchronized (self) {
        _giftArr = giftArr;
        [self saveDMData];
    }
}

- (void)readData
{
    NSString *filepath = [self filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        @try {
            NSData * data = [NSData dataWithContentsOfFile:filepath];
            if(data.length){
                data = SkyEyeUtil->deodeDataWithXor(data);
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                _configDic = [object isKindOfClass:[NSDictionary class]] ? object : nil;
            }
            
        } @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
        
    }
}

-(void) readDMData
{
    NSString *filepath = [self dmFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        @try {
            NSData * data = [NSData dataWithContentsOfFile:filepath];
            if(data.length){
                data = SkyEyeUtil->deodeDataWithXor(data);
                id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                _giftArr = [object isKindOfClass:[NSDictionary class]] ? object : nil;
            }
            
        } @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
        
    }
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_configDic)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_configDic];
        if(data.length){
            data = SkyEyeUtil->deodeDataWithXor(data);
        }
    }
    [data writeToFile:[self filepath] atomically:YES];
}

-(void) saveDMData
{
    NSData *data = [NSData data];
    if (_giftArr)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_giftArr];
        if(data.length){
            data = SkyEyeUtil->deodeDataWithXor(data);
        }
    }
    [data writeToFile:[self dmFilePath] atomically:YES];
}

@end
