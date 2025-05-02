//
//  LDSGiftModel.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDSGiftModel : NSObject
@property(nonatomic, strong) NSString *special_zip_md5;

@property(nonatomic, strong) NSString *userIcon;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *giftName;
@property(nonatomic, strong) NSString *giftImage;
@property(nonatomic, strong) NSString *giftGifImage;
@property(nonatomic, strong) NSString *giftId; //礼物ID
@property(nonatomic, assign) NSInteger sendCount; //发送的数

@property(nonatomic, assign) NSInteger defaultCount; //0 count

/** 礼物操作的唯一Key */
@property(nonatomic, strong) NSString *giftKey; // giftName + giftId

@end

NS_ASSUME_NONNULL_END
