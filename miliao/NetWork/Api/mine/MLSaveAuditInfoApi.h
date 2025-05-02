//
//  MLSaveAuditInfoApi.h
//  miliao
//
//  Created by apple on 2022/9/17.
//

#import "MLNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLSaveAuditInfoApi : MLNetwork

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
               wxNo:(NSString *)wxNo;


@end

NS_ASSUME_NONNULL_END
