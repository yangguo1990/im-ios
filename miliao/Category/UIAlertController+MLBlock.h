

#import <UIKit/UIKit.h>
typedef void (^AlertBlock)(NSInteger);


@interface UIAlertController (MLBlock)
- (UIAlertController *)addAction:(NSString *)title
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)show;

@end

