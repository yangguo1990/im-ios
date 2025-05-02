

#import <UIKit/UIKit.h>

@interface UIImage (ML)

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)stringToImage:(NSString *)str; // 将base64字符串转为图片
/**
 根据颜色生成图片

 @param color 颜色
 @return t图片生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

#pragma mark - 拉伸图片
+ (UIImage *)resizeImageWithImageName:(NSString *)imageName  ImageWidth:(CGFloat)imageWidth;


/**
  Carroll
 *  @brief  图片大于多少KB会进行压缩
 *
 */
+(UIImage*)compressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image;
// 获取视频第一帧
+ (UIImage *)getVideoPreViewImage:(NSURL *)path;

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
                       text:(NSString *)text
             textAttributes:(NSDictionary *)textAttributes
                     corner:(CGFloat)corner;
@end
