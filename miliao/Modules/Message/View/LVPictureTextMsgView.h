//
//  LVPictureTextMsgView.h
//  LiveVideo
//
//  Created by 史贵岭 on 2017/11/11.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class M80AttributedLabel;
@interface LVPictureTextMsgView : UIView
@property(nonatomic, nonnull,strong) M80AttributedLabel * label;
-(void) setTextMsgContent:(NSString *) textContent;

-(void) pictureViewWithMaxWidth:(NSInteger) maxWidth;
@end
