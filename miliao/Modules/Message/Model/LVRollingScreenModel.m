//
//  LVRollingScreenModel.m
//  LiveSendGift
//
//  Created by 史贵岭 on 2018/2/1.
//  Copyright © 2018年 com.wujh. All rights reserved.
//

#import "LVRollingScreenModel.h"

@implementation LVRollingScreenModel

-(NSAttributedString *) showAttStr
{
    if(!_showAttStr){
        
        NSString * str1 = [NSString stringWithFormat:@"为%@送出%@个",self.receiverName,self.giftCount];
        NSString * str2 = [NSString stringWithFormat:@"[%@]",self.giftName];
        NSMutableAttributedString * fullAtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
        [fullAtStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],
                                   NSForegroundColorAttributeName:[UIColor whiteColor],
                                   } range:NSMakeRange(0, str1.length+str2.length)];
        [fullAtStr addAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:130/255 green:193.0/255 blue:109.0/255 alpha:1.0],} range:NSMakeRange(str1.length+1, self.giftName.length)];
        _showAttStr = fullAtStr;
        
    }
    
    return _showAttStr;
}
@end

@implementation LVRollingScreenNormalModel
@end
