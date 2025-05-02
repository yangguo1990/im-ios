//
//  ML_TagParse.h
//
//  Created by 林必义 on 2017/6/20.
//  Copyright © 2017年 Polidea. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ML_TagParse : NSObject
+(NSArray<NSDictionary *> *) parseNTESTagText:(NSString *) tagText;
@end
