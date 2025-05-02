
#import "UIImage+ML.h"
#import <AVFoundation/AVFoundation.h>
#import<QuartzCore/QuartzCore.h>
#import<Accelerate/Accelerate.h>

@implementation UIImage (ML)

+ (UIImage *)stringToImage:(NSString *)str {

NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];

UIImage *photo = [UIImage imageWithData:imageData ];

return photo;

}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//+ (UIImage *)imageWithColor:(UIColor *)color {
//    return [self imageWithColor:color size:CGSizeMake(1, 1)];
//}

-(UIImage*)rotateImageWithDegree:(CGFloat)degree{

    //将image转化成context

    //获取图片像素的宽和高
    size_t width =self.size.width*self.scale;
    size_t height =self.size.height*self.scale;

    //颜色通道为8因为0-255经过了8个颜色通道的变化
    //每一行图片的字节数因为我们采用的是ARGB/RGBA所以字节数为width * 4
    size_t bytesPerRow =width *4;

    //图片的透明度通道
    CGImageAlphaInfo info =kCGImageAlphaPremultipliedFirst;
    //配置context的参数:
    CGContextRef context =CGBitmapContextCreate(nil, width, height,8, bytesPerRow,CGColorSpaceCreateDeviceRGB(),kCGBitmapByteOrderDefault|info);

    if(!context) {
    return nil;
    }

    //将图片渲染到图形上下文中
    CGContextDrawImage(context,CGRectMake(0,0, width, height),self.CGImage);

    uint8_t* data = (uint8_t*)CGBitmapContextGetData(context);

    //旋转欠的数据

    vImage_Buffer src = { data,height,width,bytesPerRow};

    //旋转后的数据

    vImage_Buffer dest= { data,height,width,bytesPerRow};

    //背景颜色
    Pixel_8888 backColor = {0,0,0,0};

    //填充颜色
    vImage_Flags flags = kvImageBackgroundColorFill;

    //旋转context
    vImageRotate_ARGB8888(&src, &dest,nil, degree *M_PI/180.f, backColor, flags);

    //将conetxt转换成image

    CGImageRef imageRef =CGBitmapContextCreateImage(context);
    
    UIImage* rotateImage =[UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];

    return rotateImage;

}


+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

// 压缩图片
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - 拉伸图片
+ (UIImage *)resizeImageWithImageName:(NSString *)imageName ImageWidth:(CGFloat)imageWidth
{
    UIImage *image = [UIImage imageNamed:imageName];
   
    CGFloat top = imageWidth;    //顶端盖的高度
    CGFloat left = imageWidth;   //左端盖的高度
    CGFloat bottom = imageWidth; //底端盖的高度
    CGFloat right = imageWidth;  //右端盖的高度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    //指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage*)compressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image
{
    //大于多少kb的图片需要压缩
    long imagePixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    long imageKB = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);
    if (imageKB > kb){
        float compressedParam = kb / imageKB;
        return [UIImage imageWithData:UIImageJPEGRepresentation(image, compressedParam)];
    }
    //返回原图
    else{
        return image;
    }
}

// 获取视频第一帧
+ (UIImage *)getVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
                       text:(NSString *)text
             textAttributes:(NSDictionary *)textAttributes
                     corner:(CGFloat)corner
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (corner > 0) {
        CGPathRef path = CGPathCreateWithRoundedRect(rect, corner, corner, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
