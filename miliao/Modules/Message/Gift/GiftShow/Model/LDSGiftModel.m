//
//  LDSGiftModel.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftModel.h"

@implementation LDSGiftModel

- (NSString *)giftKey {
    return [NSString stringWithFormat:@"%@%@", self.giftName, self.giftId];
}

- (NSString *)special_zip_md5
{
    if (_giftGifImage) {
        
        return [_giftGifImage md5];
    }
    return nil;
}

@end
