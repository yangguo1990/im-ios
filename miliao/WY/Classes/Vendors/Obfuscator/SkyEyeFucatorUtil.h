//
//  SkyEyeFucatorUtil.h
//
//  Created by 林必义 on 16/8/9.
//  Copyright © 2016年 林必义. All rights reserved.
//

#import <Foundation/Foundation.h>

#define fucatorForKey fA1000
#define xorData       xC1002
#define makeSaltSeed  mD1003
#define hashSaltStringUsingSHA1 hE1004
#define dataWithHexString dD1005
#define NSDataToHex nE1006
#define printHexWithData pF1007
#define encode2Base64Str e00000
#define deodeDataWithXor d00001
#define valideParamWithDic v00002
#define cerData            c00003


typedef struct _SkyEyeFucatorUtil{
    NSString * (*fucatorForKey)(NSString  *key);
    NSString * (*encode2Base64Str)(NSString * content);
    NSData *   (*deodeDataWithXor)(NSData * encodeData);
    NSString * (*valideParamWithDic)(NSArray * paramArray);
    NSData *   (*cerData)(void);
}FucatorUtilStruct;

#define SkyEyeUtil ([SkyEyeFucatorUtil sharedUtil])

@interface SkyEyeFucatorUtil : NSObject

+( FucatorUtilStruct* )sharedUtil;


+(void )makeOutFormatDataByArray:(NSArray * )array;

@end
