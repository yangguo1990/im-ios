

#import "UIAlertController+MLBlock.h"
#import <objc/runtime.h>


@implementation UIAlertController (MLBlock)
- (UIAlertController *)addAction:(NSString *)title
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
    return self;
}

- (void)show
{
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:self animated:YES completion:nil];
}
@end

