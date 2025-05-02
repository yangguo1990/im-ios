//
//  LVSkinQiPaoManager.m
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/23.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "NTESSkinQiPaoManager.h"
#import "NTESFileLocationHelper.h"
#import "SDWebImageDownloader.h"
#import "NSString+NTES.h"

@implementation NTESSkinQiPaoManager

+(instancetype) sharedQiPaoManager
{
    static NTESSkinQiPaoManager * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(BOOL) skinQiPaoExist:(NSString *) url
{
    if(![url isKindOfClass:[NSString class]] || !url.length){
        return NO;
    }
    NSString * md5Path = [self diskMd5PathForUrl:url];
    if([[NSFileManager defaultManager] fileExistsAtPath:md5Path]){
        return YES;
    }
    return NO;
}
-(UIImage *) skinQiPaoImg:(NSString *) url
{
    NSString * path = [self diskMd5PathForUrl:url];
    if(!path.length){
        return nil;
    }
    UIImage * img = [UIImage imageWithContentsOfFile:path];
    return img;
}
-(void) saveSkinQiPao:(UIImage *) img forUrl:(NSString *) url
{
    if(img && url){
        NSString * path = [self diskMd5PathForUrl:url];
        NSData * data = UIImagePNGRepresentation(img);
        [data writeToFile:path atomically:YES];
    }
}

-(void) lvDownloadImg:(NSString *) url block:(void (^)(UIImage * img ,NSError * error))finishedBlock
{
//    [SDWebImageDownloader sharedDownloader].downloadTimeout = 60;
    NSURL * downUrl = [NSURL URLWithString:url?:@""];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:downUrl options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if(!error && image){
            [self saveSkinQiPao:image forUrl:url];
            if(finishedBlock){
                finishedBlock(image,error);
            }
        }
    }];
    
}

-(NSString *) diskMd5PathForUrl:(NSString *) url;
{
    NSString * md5Str = [url MD5String];
    NSString * theMd5Path = [NSString stringWithFormat:@"%@/%@@2x.png",[self diskCachePath],md5Str];
    return theMd5Path;
}
-(NSString *) diskCachePath
{
    NSString * basePath = [NTESFileLocationHelper getAppDocumentPath];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * tempPath = [basePath stringByAppendingPathComponent:@".LVSkinQiPao"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return  [basePath stringByAppendingPathComponent:@".LVSkinQiPao"];
}
@end
