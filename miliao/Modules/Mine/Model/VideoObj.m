//
//  VideoObj.m
//  demo38vedioToGif
//
//  Created by bing on 16/2/26.
//  Copyright © 2016年 bing. All rights reserved.
//

#import "VideoObj.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVTime.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define timeIntervalometer 0.2

@interface VideoObj ()

@property (nonatomic,strong)NSDictionary *stsDic;

@end


@implementation VideoObj


// 获取视频路径
// 获取帧
- (void)getPicGit:(NSURL *)url sts:(NSDictionary *)stsDic{
    /*!
     CMTimeMake(a,b)                a当前第几帧,b每秒钟多少帧.当前播放时间a/b
     CMTimeMakeWithSeconds(a,b)     a当前时间,b每秒钟多少帧.
     */
    self.stsDic = stsDic;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    CMTime time = [(AVURLAsset *)asset duration];
    
    // 时间
    CGFloat second = time.value * 1.0 / time.timescale;
    NSMutableArray *array = [NSMutableArray array];
    
    // 取秒(每隔0.25取一张图片)
    for (CGFloat i = 0; i < second; i+=timeIntervalometer) {
        CMTime slice1 = CMTimeMakeWithSeconds(i, time.timescale);
        [array addObject:[NSValue valueWithCMTime:slice1]];
        if (i >= 5) {
            break;
        }
    }
    
    __block NSInteger index = 1;
    NSMutableArray *images = [NSMutableArray array];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CMTime tol = CMTimeMakeWithSeconds([@(0.01) floatValue], [@(600) intValue]);
    generator.requestedTimeToleranceBefore = tol;
    generator.requestedTimeToleranceAfter = tol;
    [generator generateCGImagesAsynchronouslyForTimes:array
                                    completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable imageref,
                                                        CMTime actualTime, AVAssetImageGeneratorResult result,
                                                        NSError * _Nullable error)
     {
         if (imageref) {
             @autoreleasepool {
                 UIImage *image = [UIImage imageWithCGImage:imageref];
                 NSData *data   = [self imageWithImage:image scaledToSize:CGSizeMake(216, 384)];
                 [data writeToFile:[self filePath:index] atomically:YES];
                 [images addObject:[UIImage imageWithData:data]];
             }
         }
         
         // 取完后处理照片
         if (index == array.count) {
             [self makeGIF:images];
         }
         index++;
     }];
}

// 文件路径
- (NSString *)filePath:(NSInteger)index {
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDirectory stringByAppendingFormat:@"/test%03ld.gif", (long)index];
    return path;
}

// 压缩图片
- (NSData *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 1);
}


// gif的制作
- (void)makeGIF:(NSMutableArray *)imgs {
    NSLog(@"thread:%@",[NSThread currentThread]);
    
    NSString *path = [self filePath:99999];
    
    
    //创建CFURL对象
    CFURLRef url = CFURLCreateWithFileSystemPath (kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    
    //通过一个url返回图像目标
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:@{(NSString *)kCGImagePropertyGIFDelayTime:@(timeIntervalometer)}
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    // 无限循环播放
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:@{(NSString *)kCGImagePropertyGIFLoopCount:@(0)}
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage *img in imgs) {
        @autoreleasepool {
            CGImageDestinationAddImage(destination, img.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    [imgs removeAllObjects];
    imgs = nil;
    
    
    UIImage *savedImage = [UIImage imageWithContentsOfFile:path];
    UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil);
    
    NSLog(@"path===== %@=== %@",path, [NSData dataWithContentsOfFile:path]);
    
    [ML_CommonApi  uploadImages:@[[NSData dataWithContentsOfFile:path]] dic:self.stsDic block:^(NSString * _Nonnull url) {
  
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reGif" object:url];
    }];
    
}


// 制作GIF图片
- (void)exportAnimatedGifWithImages:(NSArray *)images
{
    // 设置文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], kUTTypeGIF, images.count, NULL);
    
    // 播放时间长度
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:@{(NSString *)kCGImagePropertyGIFDelayTime:@(images.count * 0.1)}
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    // 循环次数
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:@{(NSString *)kCGImagePropertyGIFLoopCount:@(0)}
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    for (UIImage *image in images) {
        CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)frameProperties);
    }
    
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    
    NSLog(@"animated GIF file created at %@", path);
    UIImage *savedImage = [UIImage imageWithContentsOfFile:path];
    UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil);
    NSLog(@"ok");
}
@end
