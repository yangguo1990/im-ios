//
//  SkyEyeFucatorUtil.m
//
//  Created by 林必义 on 16/8/9.
//  Copyright © 2016年 林必义. All rights reserved.
//

#import "SkyEyeFucatorUtil.h"
#import "NSString+NTES.h"

#import <CommonCrypto/CommonDigest.h>

//Original: "mimilive.2017_xx"
#define xorkeyEncode @"5E5D0C5D555141561C51090855391C4C"

//orginal为ca.cer转为16进制数据
//Original: "308203CD308202B5A003020102020900958F1B11ED3E7785300D06092A864886F70D01010B0500307D310B300906035504061302636E310B300906035504080C026764310E300C06035504070C05777568616E31153013060355040A0C0C647265616D696D69206C74643117301506035504030C0E2A2E647265616D696D692E6E65743121301F06092A864886F70D010901161261646D696E40647265616D696D692E6E6574301E170D3137303931353037303334355A170D3237303931333037303334355A307D310B300906035504061302636E310B300906035504080C026764310E300C06035504070C05777568616E31153013060355040A0C0C647265616D696D69206C74643117301506035504030C0E2A2E647265616D696D692E6E65743121301F06092A864886F70D010901161261646D696E40647265616D696D692E6E657430820122300D06092A864886F70D01010105000382010F003082010A0282010100B54226138DE935F62BD0613D7D7DE40DEBAB2F24DD05B4808E39E60CE70BF8816C2F3383423E7EBBA46E0841FF22406D41BA4BD5333B985C33AEA82FD0F4FFC8928EB5DB05A68C7FD5FF68A45EFBC97F182C6098378B53210A2F18C63BA9C55BF722BE33990AB936902F8FB2870A29CCED5E8CE01EA365F84EEF425D1D3CA6D873663CCC439628A9484C982092345C39FE707C5A27518E8A1D77E4C6E87D204A68D8EF2161C5BF535BF032CBA379C239A942074BE7620ECBCBF196DE45C438D272C13668AA98E8FE54A3A26A93DDF1BCEA650DCFB58D2069C5F9437DCC4D8EDC5A0410E9A665A748766916D04649E234BF6837EA0D62051070A78519896DA9850203010001A350304E301D0603551D0E041604146526843C31A12109434DBD80F2E0633E1F601E6B301F0603551D230418301680146526843C31A12109434DBD80F2E0633E1F601E6B300C0603551D13040530030101FF300D06092A864886F70D01010B050003820101005CC067DD53C06473D7B0650B028A409483E3060AD1C7A189FD44368726EC42B973FC6153C2984257F9791D89C3407C452EFBC62134BD73933C1E0E4292DEF48A356AC85CB167BF92AA32D47DD66EE32CC9EE459F1B93E46C9E05420897D533616A22CDBFCBF317416446D5B3EBD0CCCDEC07CF1CFA16801012E969CF9513C6B16BF7936F1D10DF9000B07A133B2C3F9BC9393DEDC20A6577D0FFFF545F2F36FAC3504E5D916275B73B3EE5538EDBEB488B7C6BE1C81B34D46AB5D0DCACB1CD94AE0F86BD12A98BAA37F5CDA2916C77A3A464003FC5C05028440FB4B2D098F73348FF161D83579E202DD8F45541ABBE2139ABED39EBE8A06109498A58C10C0837"
#define CACerData @"00045906090B74770153010B52542601735202520801540803015303530D56025B54592504200155767052710E0F0F060153097D5250540D00230A570C0B5C0F7504537553055603522351560552035404705205097A0403025A090F52555101025602570900540B05005574500556705151515A05540057060151000900077002510F0E54525705022701510870540F03005604530056055222515602550751050C57050F7D040203560A095355540202510754080754780370537255005100545457520326065D0570570D0B08017005570F0D51575503015203540805540A06065305530756715224532207270650040657010F090177045A0F7D545F5671042704540F0757080102500152725604525853220D54045C0B022703097C0702025A090853505506045304550E7752000576570155005100545457520326065D0570570D0B7D017604560E0D51565571035502250B02570E00035008500555075151525406520357000052010C79060402270A0B51515704015B01500B00570900045001500755065154542206520720000551760A08070A0255090A57535400025403520801520A057650005376550252585155055105510300510C097B070104540F0D51575471015202220805540A0606530553035671525456540257065C050557710A0906060153080A52505407075702550872547A037055055406500754505727035B0620050D53040F7B000704570A0853515704035702570800510C03075302537756775020532603560756050157050F7C010A04270F0050235271045705550B025608000352775302560B50205955015A0852750351700909070A0252080F53545205045604250E0A527C070355055406500754505727035B0620050D53710F7D010605570A095A545405005001510877540F030A51705B02520A5A5727540526005503055105090D07030250010B525754720252015100015408037253035B065603525051537757045601025007017C720A01567F0F50242004045301250F77537D7607537526762770502753577126005171005904017D040A7755097A27515476745A0A500E70567F00005B02570655775524232174560621030C55057F7E050106530F7D56572675062076540B00577B0A0B56725007277723595325715276507572220C000A0F7670567D7B525325020A2105277C06227F050B22055671207021585625045A02270504580C0A0F0F7107500B0852275672035A71570B7125007006567325035400202452500C5B0025710D5202000805750A257B0B5A515475005B71227D77517C0B702601527127015454275B0127752207065470087C047073557D0155555202012171220C005D0F010B2208570C52715B5953530C5003500677520D7F7D000305200C78505151050A270A200977530E76072007260C517650515522035A745C767253050F09740670250C0A57242204015071237900530070015008220D52005256552170550656037122767A7A71020B557D7C56532700015A76530F0127080005550922755F0A275927260056715772065775000B737774527B7A27275201022671277A065C7D010355082001200B56525627762104200B7125770C79070703537C0023505201735506590F055200020527015702520B275352577724065C00032475097C010102560809555625030A570358000A527D720A5B04530656015250515305537157060452040D7D04030327090F52555101032602240807550F03075205550154045A555220065371550105510D0D0B037770270109245421040451012409755209027655735004577452575150005701200107510008000403035501095352520100540A550B70570872025100530D5201562523270D527656760457070A7D06750453087C54245704022102570800510C0277520253005607515151500553005575725204097C0705025A0B785A50500C0A5474560877540803025373530156025252595105530055030454777A08010476270C0A21565200055176567A03520C037153035B7552025B55595070510052037525057A0F76020A5A7F7D565257020A5500577D70500B710A540225775003575222510C5A04560603270D0E0106770A5A7A0A56565377065700247E71270F01025005217051015B52522004270021070658067D7D71070A220A0C5427270C072170500E04267F0A0122705006220655252555032775570177220D7C7D03060B25087B5B55210004210B240806500B030B5A06270155015450572207507320717222767F0B060406520F0D56502001705177237C03277A70772672530325745322272204540854020450067C01010A7125000C53552702705304237E045D0A05755275520422745B51515377520725020752760B7B04750B217A00515F5770772671530872520C04042701257220745755542507240352757522070C0803760727000854545301705501230B76210C06005B742776237056595921022106267605220C087A040776570F7820532004762173227A02277D0A07227453725E0420255051745B0826727552037F0D74777351000854255303735173550E07540900752004200453025059555705247250710625040000710401500D012420550203260A520D045D7C01035175270C200657545552742072210105520D787A7277015A7C7B275E2504045302580C0A5C78060B20005377560A5156"



@implementation SkyEyeFucatorUtil

static FucatorUtilStruct * util = NULL;


+(FucatorUtilStruct *)sharedUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = (malloc(sizeof(FucatorUtilStruct)));
        util->fucatorForKey = __SkyEye__BB_DD_EE__;
        util->deodeDataWithXor =__00000_IMP;
        util->encode2Base64Str = __11111_IMP;
        util->valideParamWithDic = __22222_IMP;
        util->cerData = __33333_IMP;
    });
    return util;
}


static  inline NSData * __33333_IMP(void)
{
    NSString * b = SkyEyeUtil->fucatorForKey(CACerData);
    return dataWithHexString(b);
};

static  inline NSString * __22222_IMP(NSArray * paramArray)
{
    NSString * key = SkyEyeUtil->fucatorForKey(xorkeyEncode);
    NSString * resultStr = @"";
    for(id obj in paramArray){
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"%@",obj]];
    }
    NSString * md5Str  =[resultStr MD5String];
    md5Str = [NSString stringWithFormat:@"%@%@",md5Str,key];
    md5Str = [md5Str MD5String].copy;
    return md5Str;
};


static  inline NSString * __11111_IMP(NSString * content)
{
    NSString * key = SkyEyeUtil->fucatorForKey(xorkeyEncode);
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData * encodeData = xorData(data,key);
    return [encodeData base64EncodedStringWithOptions:0];
}

static  inline NSData * __00000_IMP(NSData * encodeData)
{
    NSString * key = SkyEyeUtil->fucatorForKey(xorkeyEncode);
    return  xorData(encodeData,key);
}

//相当混淆函数名字作用
static  inline NSString * __SkyEye__BB_DD_EE__(NSString * key){
    static dispatch_semaphore_t limitSemaphore; //控制并发的信号量
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);//加锁
    
    NSString * returnValue = key.copy;
    @try {
        
        static NSString * innerString = nil;
        if(![innerString length]){
            innerString = hashSaltStringUsingSHA1(makeSaltSeed());
        }
        
        //将字符串还原成二进制
        NSData * decodeData = dataWithHexString(key);
        NSData * xorDecodeData =  xorData(decodeData, innerString);//用用一个key异或
        NSString * decodeString = [[NSString alloc] initWithData:xorDecodeData encoding:NSUTF8StringEncoding];
        returnValue = decodeString.copy;
        //执行完任务，务必释放信号量，否则会死锁
        dispatch_semaphore_signal(limitSemaphore);
    } @catch (NSException *exception) {
        
    }
    
    return returnValue;
    
}


#pragma mark 产生输出格式
static  inline NSString * printHexWithData(NSData * data){
    
    /*  @autoreleasepool {
     
     NSMutableString *temp = [[NSMutableString alloc] initWithString:@""];
     
     const unsigned char *buf = data.bytes;
     
     NSInteger length = data.length;
     
     for (int i = 0; i < length; i++)
     {
     [temp appendFormat:@"%02X", (int)buf[i]];
     }
     
     
     return [temp copy];
     }*/
    return  NSDataToHex(data);//更高效率
}


+ (void )makeOutFormatDataByArray:(NSArray * )array {
#ifdef DEBUG
    [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSString  * idKey = obj[@"id"];
                NSString * orginal = obj[@"string"];
                
                NSData * orginalData = [orginal dataUsingEncoding:NSUTF8StringEncoding];
                NSString * saltXorKey = hashSaltStringUsingSHA1(makeSaltSeed());
                //将字符串用盐异或下
                NSData * xorOginalData = xorData(orginalData, saltXorKey);
                //将异或字符串转为二进制
                NSString * printedString = printHexWithData(xorOginalData);
                NSLog(@"//Original: \"%@\"\n#define %@ @\"%@\"\n\n",orginal,idKey,printedString);
                
                /*
                 //将字符串还原成二进制
                 NSData * decodeData = dataWithHexString(printedString);
                 NSData * xorDecodeData =  xorData(decodeData, saltXorKey);//用用一个key异或
                 NSString * decodeString = [[NSString alloc] initWithData:xorDecodeData encoding:NSUTF8StringEncoding];
                 NSLog(@"%@",decodeString);*/
                
            }
        }
    }];
#endif
}

#pragma mark 异或加密
//异或加密
static  inline NSData * xorData(NSData * data,NSString * xorKey){
  /*  if(![xorKey length]){
        return data;
    }
    NSData *keyData = [xorKey dataUsingEncoding:NSUTF8StringEncoding];
    Byte *keyBytes = (Byte *)[keyData bytes];   //取关键字的Byte数组, keyBytes一直指向头部
    
    Byte *sourceDataPoint = (Byte *)[data bytes];  //取需要加密的数据的Byte数组
    NSInteger length = data.length;
    for (NSInteger i = 0; i < length; i++) {
        sourceDataPoint[i] = sourceDataPoint[i] ^ keyBytes[(i % [keyData length])]; //然后按位进行异或运算
    }
    
    return data.copy;*/
    
    if(![xorKey length]){//处理异常key
        return data;
    }
    
    // 获取key的长度
    NSInteger length = xorKey.length;
    
    // 将OC字符串转换为C字符串
    const char *keys = [xorKey UTF8String];
    
    unsigned char cKey[length];
    
    memcpy(cKey, keys, length);
    
    // 数据初始化，空间未分配 配合使用 appendBytes
    NSMutableData *encryptXorData = [[NSMutableData alloc] initWithCapacity:length];
    
    // 获取字节指针
    const Byte *point = data.bytes;
    NSUInteger dataLength = data.length;
    
    for (NSInteger i = 0; i < dataLength; i++) {
        NSInteger l = i % length;                     // 算出当前位置字节，要和密钥的异或运算的密钥字节
        char c = cKey[l];
        Byte b = (Byte) ((point[i]) ^ c);       // 异或运算
        [encryptXorData appendBytes:&b length:1];  // 追加字节
    }
    return encryptXorData.copy;

}

#pragma mark 产生盐

static inline NSString * makeSaltSeed(void){
    //Salt used (in this order): [NSDictionary class],[NSString class],[NSNull class],
    NSMutableString *  classes = [[NSMutableString alloc] initWithString:NSStringFromClass([NSDictionary class])];
    [classes appendString:NSStringFromClass([NSString class])];
    [classes appendString:NSStringFromClass([NSNull class])];
    return classes;
}

static inline NSString *hashSaltStringUsingSHA1(NSString * salt)
{
    NSData *d = [salt dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get the SHA1 of a class name, to form the obfuscator.
    unsigned char obfuscator[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(d.bytes, (CC_LONG)d.length, obfuscator);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", obfuscator[i]];
    }
    
    return [output copy];
}

#pragma mark 16进制和2进制互转
static inline  NSData * dataWithHexString(NSString *hex){
    char buf[3];
    buf[2] = '\0';
    
    unsigned char *bytes = malloc([hex length]/2);
    unsigned char *bp = bytes;
    for (CFIndex i = 0; i < [hex length]; i += 2) {
        buf[0] = [hex characterAtIndex:i];
        buf[1] = [hex characterAtIndex:i+1];
        char *b2 = NULL;
        *bp++ = strtol(buf, &b2, 16);
    }
    
    return [NSData dataWithBytesNoCopy:bytes length:[hex length]/2 freeWhenDone:YES];
}

static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}


static inline NSString * NSDataToHex(NSData *data) {
    NSUInteger i, len;
    unsigned char *buf, *bytes;
    
    len = data.length;
    bytes = (unsigned char*)data.bytes;
    buf = malloc(len*2);
    
    for (i=0; i<len; i++) {
        buf[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len*2
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
}
@end
