

#import "UIView+ML.h"


 NSString *LTPu_Delete = @"deleteFile";

@implementation UIView (ML)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setMaxX:(CGFloat)maxX {
    
}

- (CGFloat)maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxY:(CGFloat)maxY {
    
}

- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (UIViewController *)getParentviewController{
    for (UIView *next = [self superview];next;next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
            
        }
    }
    return nil;
}


- (void)addTagSupView:(UIView *)tagSupView arr:(NSArray *)arr
{
    for (UIView *tagV in tagSupView.subviews) {
        [tagV removeFromSuperview];
    }
    
    for (int i = 0; i < arr.count; i++) {
        
       __block UIImageView *imageView = [[UIImageView alloc] init];
       NSString *imgStr = arr[i];
        [tagSupView addSubview:imageView];
        
        [imageView sd_setImageWithURL:kGetUrlPath(imgStr) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            CGFloat iVX = 0;
            if (i == 1) {
                iVX = 21 + 5;
            }
            else if (i > 1) {
                iVX += 70;
            }
            
            imageView.frame = CGRectMake(iVX, 0, image.size.width / 2, tagSupView.height);
        
        }];
          
    }
}


- (void)addOnLineViewWithState:(NSString *)state
{
    for (UIView *tagV in self.superview.subviews) {
        if (tagV.tag == 10870) {
            
            [tagV removeFromSuperview];
            break;
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 12, CGRectGetMaxY(self.frame) - 12, 12, 12)];
    imageView.tag = 10870;
    [self.superview addSubview:imageView];
    
    if ([state intValue] == 0) {
        
//        imageView.image = kGetImage(@"icon_gouxuan_16_sel");
        
    } else if ([state intValue] == 1) {
        
//        imageView.image = kGetImage(@"manglu");
        
    } else if ([state intValue] == 2) {
        
        imageView.image = kGetImage(@"manglu");
        
    } else if ([state intValue] == 3) {
        
        imageView.image = kGetImage(@"zxian");
    }
    
}

- (void)setNameFrameWithOrigin:(CGPoint)point height:(CGFloat)height
{
    UILabel *naveV = (UILabel *)self;
    CGSize nameSize = [naveV.text sizeWithLabelWidth:200 font:naveV.font];
    naveV.frame = CGRectMake(point.x, point.y, nameSize.width, height);
}

- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor {
    [self rounded:8 width:borderWidth color:borderColor];
}
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}
@end
