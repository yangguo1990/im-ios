//
//  LVSkinQiPaoManager.h
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/23.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESSkinQiPaoManager : NSObject

+(instancetype) sharedQiPaoManager;

-(BOOL) skinQiPaoExist:(NSString *) url;
-(UIImage *) skinQiPaoImg:(NSString *) url;
-(void) saveSkinQiPao:(UIImage *) img forUrl:(NSString *) url;
-(void) lvDownloadImg:(NSString *) url block:(void (^)(UIImage * img ,NSError * error))finishedBlock;
@end
