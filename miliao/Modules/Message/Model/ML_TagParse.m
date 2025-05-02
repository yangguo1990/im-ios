//
//  ML_TagParse.m
//
//  Created by 林必义 on 2017/6/20.
//  Copyright © 2017年 Polidea. All rights reserved.
//

#import "ML_TagParse.h"

 NSString * LVTagMatchString = @"LVTagMatchString";
 NSString * LVTagLinkText = @"LVTagLinkText";
 NSString * LVTagLinkUrl = @"LVTagLinkUrl";
NSString * LVTagRange = @"LVTagRange";

@implementation ML_TagParse

+(NSArray<NSDictionary *> *) parseNTESTagText:(NSString *) tagText
{
    NSMutableArray *tmpInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *regex_label = @"<tag\\s+url=\\\"(.*?)\\\".*?>(.*?)(<\\/tag>)";
    
    NSError *error =nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regex_label
                                  
                                                                           options:NSRegularExpressionCaseInsensitive
                                  
                                                                             error:&error];
    
    NSArray *array_label = [regex matchesInString:tagText
                            
                                          options:0
                            
                                            range:NSMakeRange(0, [tagText length])];
    if (![array_label count]) {
        return tmpInfoArray;
    }
    
    
    for (NSTextCheckingResult *match in array_label) {
        
        NSMutableDictionary *linkInfo = [NSMutableDictionary dictionary];
        
        NSRange matchRange = [match range];
        
        NSString *tagString = [tagText substringWithRange:matchRange];
        
        NSRange r1 = [match rangeAtIndex:1];
        
        NSString *tagName = @"";
        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {
            tagName = [tagText substringWithRange:r1];
            
        }
        
        NSString *tagValue = [tagText substringWithRange:[match rangeAtIndex:2]];
        
        [linkInfo setObject:tagString forKey:LVTagMatchString];
        [linkInfo setObject:tagValue forKey:LVTagLinkText];
        [linkInfo setObject:tagName forKey:LVTagLinkUrl];
        [linkInfo setObject:NSStringFromRange(matchRange) forKey:LVTagRange];
        [tmpInfoArray addObject:linkInfo];
        
    }
    
    return tmpInfoArray;

}
@end
