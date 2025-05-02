//
//  MLSaveAuditInfoApi.m
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLSaveAuditInfoApi.h"

@interface  MLSaveAuditInfoApi()

@property (nonatomic,copy)NSString *persionGif;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *potos;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *height;
@property (nonatomic,copy)NSString *weight;
@property (nonatomic,copy)NSString *ussId;


@property (nonatomic,copy)NSString *cityCode;
@property (nonatomic,copy)NSString *lables;
@property (nonatomic,copy)NSString *persionSign;
@property (nonatomic,copy)NSString *idCardFront;
@property (nonatomic,copy)NSString *idCardReverse;
@property (nonatomic,copy)NSString *handIdCard;

@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *birthday;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *proId;
@property (nonatomic,copy)NSString *emId;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *persionVideo;
@property (nonatomic,copy)NSString *wxNo;
@property (nonatomic,copy)NSString *extra;

@end
@implementation MLSaveAuditInfoApi

- (id)initWithPersionGif:(NSString *)persionGif
            extra:(NSString *)extra
               type:(NSString *)type
              video:(NSString *)video
              potos:(NSString *)potos
               name:(NSString *)name
              phone:(NSString *)phone
             height:(NSString *)height
             weight:(NSString *)weight
              ussId:(NSString *)ussId
           cityCode:(NSString *)cityCode
             lables:(NSString *)lables
        persionSign:(NSString *)persionSign
        idCardFront:(NSString *)idCardFront

      idCardReverse:(NSString *)idCardReverse
         handIdCard:(NSString *)handIdCard
               icon:(NSString *)icon
           birthday:(NSString *)birthday
             gender:(NSString *)gender
              proId:(NSString *)proId

               emId:(NSString *)emId
               code:(NSString *)code
       persionVideo:(NSString *)persionVideo
               wxNo:(NSString *)wxNo
{

    if (self = [super init]) {
        self.persionGif = persionGif;
        self.extra = extra;
        self.type = type;
        self.video = video;
        self.potos = potos;
        self.name = name;
        self.phone = phone;
        self.height = height;
        self.weight = weight;
        self.ussId = ussId;

        self.cityCode = cityCode;
        self.lables = lables;
        self.persionSign = persionSign;
        self.idCardFront = idCardFront;
        self.idCardReverse = idCardReverse;

        self.handIdCard = handIdCard;
        self.icon = icon;
        self.birthday = birthday;
        self.gender = gender;
        self.proId = proId;

        self.emId = emId;
        self.code = code;
        self.persionVideo = persionVideo;
        self.wxNo = wxNo;
        
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user/saveAuditInfo";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"token":[ML_AppUserInfoManager sharedManager].currentLoginUserData.token,
        @"persionGif" : self.persionGif,
        @"extra":self.extra,
        @"type":self.type,
//        @"video":self.video,
        @"potos":self.potos,
        @"name":self.name,
        @"phone":self.phone,
        @"height":self.height,
    
        @"weight":self.weight,
//        @"ussId":self.ussId,
        @"cityCode":self.cityCode,
        @"lables":self.lables,
        @"persionSign":self.persionSign,
        @"idCardFront":self.idCardFront,
        
        @"idCardReverse":self.idCardReverse,
        @"handIdCard":self.handIdCard,
        @"icon":self.icon,
        @"birthday":self.birthday,
        @"gender":self.gender,
//        @"proId":self.proId,

//        @"emId":self.emId,
        @"code":self.code,
        @"persionVideo":self.persionVideo,
        @"wxNo":self.wxNo
    }];
    // // emId proId ussId
    
    if ([self.emId length]) {
        [muDic setObject:self.emId forKey:@"emId"];
    }
    if ([self.proId length]) {
        [muDic setObject:self.proId forKey:@"proId"];
    }
    if ([self.ussId length]) {
        [muDic setObject:self.ussId forKey:@"ussId"];
    }
    
    
    if (self.video) {
        [muDic setValue:self.video forKey:@"video"];
    }
    return muDic;
}

@end
