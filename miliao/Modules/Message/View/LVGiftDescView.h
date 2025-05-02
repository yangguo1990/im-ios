//
//  LVGiftDescView.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/8/1.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVGiftDescView : UIView
-(void) setGiftTitle:(NSString *) giftTitle count:(NSString *) count outGoing:(BOOL) outGoing;

-(void) descViewFitSize;
@end
