//
//  ML_CommonApi2.m
//  miliao
//
//  Created by apple on 2022/8/25.
//

#import "ML_CommonApi2.h"
#import "MLNameCheckApi.h"
#import<CommonCrypto/CommonDigest.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import<CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
//#import "MLAESUtil.h"

@interface  ML_CommonApi2()

@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSNumber *nonce;
@property (nonatomic,copy)NSString *currTime;
@property (nonatomic,copy)NSString *checkSum;
@property (nonatomic,copy)NSString *extra;

@property (nonatomic,copy)NSDictionary *pDic;
@end

@implementation ML_CommonApi2



- (id)initWithPDic:(NSDictionary *)pDic urlStr:(NSString *)urlStr
{
    if (self = [super init]) {
        
        
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        
        self.token = currentData?currentData.token:@"";
        self.nonce = (NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)];
        self.currTime = [self giveformatter];
        self.checkSum = [self shaData];
        self.extra = [self jsonStringForDictionary];
        self.urlStr = urlStr;
        
        self.pDic = pDic;
    }
    return self;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl
{
    return self.urlStr;
}

- (id)requestArgument {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"token":self.token,
        @"nonce":self.nonce,
        @"currTime":self.currTime,
        @"checkSum":self.checkSum,
        @"extra":self.extra}];
    
    NSArray *arr = [self.pDic allKeys];
    
    for (NSString *key in arr) {
        [muDic setObject:self.pDic[key] forKey:key];
    }
    
    return muDic;
}

+ (void)uploadImages:(NSArray *)images dic:(NSDictionary *)dic block:(nonnull uploadCallblock)result
{
    BOOL isGIF = [dic[@"gif"] boolValue];
    if (isGIF) {
        
        dic = dic[@"sts"];
    }
    
    for (int i = 0; i < images.count; i++) {
        UIImage *img = images[i];
        
        
        NSString *accessKeyId = dic[@"accessKeyId"];
        NSString *accessKeySecret = dic[@"accessKeySecret"];
//        NSString *endpoint = dic[@"endpoint"];
        NSString *endpoint = dic[@"endpoint"];
//        NSString *endpoint = @"setoss.zgdouyou.com";
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accessKeyId secretKeyId:accessKeySecret securityToken:dic[@"securityToken"]];
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];

            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
        put.bucketName = dic[@"bucketName"];
   
          
        
        // 获取代表公历的NSCalendar对象
          NSCalendar *gregorian = [[NSCalendar alloc]
           initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
          // 获取当前日期
          NSDate* dt = [NSDate date];
          // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
          unsigned unitFlags = NSCalendarUnitYear |
           NSCalendarUnitMonth |  NSCalendarUnitDay |
           NSCalendarUnitHour |  NSCalendarUnitMinute |
           NSCalendarUnitSecond | NSCalendarUnitWeekday;
          // 获取不同时间字段的信息
          NSDateComponents* comp = [gregorian components: unitFlags
           fromDate:dt];
          // 获取各时间字段的数值
          NSLog(@"现在是%ld年" , comp.year);
          NSLog(@"现在是%ld月 " , comp.month);
          NSLog(@"现在是%ld日" , comp.day);
        
            __block NSString *objectKey = [NSString stringWithFormat:@"%ld/%ld/%ld/%ld%ld%ld/%@.png", comp.year, comp.month, comp.day,comp.hour, comp.minute, comp.second, [self ML_GetUniqueDeviceIdentifierAsString]];
            put.objectKey = objectKey;
    if (![img isKindOfClass:[UIImage class]]) {
        
        
        if (isGIF) {
            
            objectKey = [NSString stringWithFormat:@"%ld/%ld/%ld/%ld%ld%ld/%@.gif", comp.year, comp.month, comp.day,comp.hour, comp.minute, comp.second, [self ML_GetUniqueDeviceIdentifierAsString]];
            
        } else {
            
            objectKey = [NSString stringWithFormat:@"%ld/%ld/%ld/%ld%ld%ld/%@.mp4", comp.year, comp.month, comp.day,comp.hour, comp.minute, comp.second, [self ML_GetUniqueDeviceIdentifierAsString]];
            
        }
        
        put.objectKey = objectKey;
        put.uploadingData = (NSDate *)img;
    } else {
        
         put.uploadingData = UIImageJPEGRepresentation(img, 0.5);
    }
    
    NSLog(@"objectKey===%@===img=%@", kGetUrlPath(objectKey), img);
    
           // 直接上传NSData。
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
                NSLog(@"%lld, %lld, %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
            };

        dispatch_queue_t subQueue = dispatch_queue_create("uploadvoice", DISPATCH_QUEUE_CONCURRENT); 
   
            dispatch_async(subQueue, ^{
                OSSTask * putTask = [client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        NSLog(@"upload object success!");
                        
                        result(objectKey);
                        
                    } else {
                        kplaceToast(@"上传失败");
                        NSLog(@"upload object failed, error: %@" , task.error);
                    }
                    return nil;
                }];
                [putTask waitUntilFinished];
                [put cancel];
            });
    }
}

-(void)commitPictureToAliyunOSSimg:(UIImage *)img dic:(NSDictionary *)dic DZHNetworkSuccess:(MLNetworkResponse *)block
{

    
}



@end
