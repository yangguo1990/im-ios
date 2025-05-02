//
//  NTESSkinManager.m
//  SiMiZhiBo
//
//  Created by 史贵岭 on 2017/12/19.
//  Copyright © 2017年 史贵岭. All rights reserved.
//

#import "NTESSkinManager.h"
#import "NTESSkinQiPaoManager.h"
#import <objc/runtime.h>

@implementation NIMMessageModel(minWidth)
+(void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = @selector(contentSize:);
        SEL swizzledSelector = @selector(LVContentSize:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

-(CGSize) LVContentSize:(CGFloat) width
{
    CGSize size = [self LVContentSize:width];
    if(self.message.messageType == NIMMessageTypeText || self.message.messageType == NIMMessageTypeCustom){
        NSInteger minWidth = [[NTESSkinManager sharedManager].useingChatTextDic[@"text_min_width"] integerValue];
        if(size.width < minWidth){
            size.width = minWidth;
        }
    }
    return size;
}
@end


@interface NTESSkinManager()
@property(atomic,assign) BOOL canUseNewChatText;
@property(atomic,strong) NIMKitConfig * usingLVConfig;
@end
@implementation NTESSkinManager
+(instancetype) sharedManager
{
    static NTESSkinManager  * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(void) tryAppNewChatTextDic:(NSDictionary *) theNewChatTextDic
{
    if(![theNewChatTextDic isKindOfClass:[NSDictionary class]] || !theNewChatTextDic.count){
        _canUseNewChatText = NO;
        self.usingLVConfig = nil;
        self.useingChatTextDic = @{};
    }else{
        @try{
            NSDictionary * olderCellFromDic = self.useingChatTextDic[@"cell_from"];
            NSDictionary * olderCelToDic = self.useingChatTextDic[@"cell_to"];
            NSDictionary * theNewCellFromDic = theNewChatTextDic[@"cell_from"];
            NSDictionary * theNewCelToDic = theNewChatTextDic[@"cell_to"];
            if((theNewCellFromDic[@"background"] && ![theNewCellFromDic[@"background"] isEqualToString:olderCellFromDic[@"background"]])||
               (theNewCelToDic[@"background"] && ![theNewCelToDic[@"background"] isEqualToString:olderCelToDic[@"background"]])){
                _canUseNewChatText = NO;
                //如果资源都存在，并且完成了初始化
                NSString * normalImgSelfStr = theNewCellFromDic[@"background"]?:@"";
                NSString * downImgSelfStr = theNewCellFromDic[@"background_active"]?:@"";
                NSString * normalOtherStr = theNewCelToDic[@"background"]?:@"";
                NSString * downOtherStr = theNewCelToDic[@"background_active"]?:@"";
                
                NIMKitConfig * tempConfig = nil;
                if(normalImgSelfStr && downImgSelfStr){
                    NSString *key1 = normalImgSelfStr;
                    UIImage *imgValue1 = [[NTESSkinQiPaoManager sharedQiPaoManager] skinQiPaoImg:key1];
                    NSString *key2 = downImgSelfStr;
                    UIImage *imgValue2 =  [[NTESSkinQiPaoManager sharedQiPaoManager] skinQiPaoImg:key2];
                    if(imgValue1 && imgValue2){
                        tempConfig = [[NIMKitConfig alloc] init];
                        int top = [theNewCellFromDic[@"split_top"] intValue];
                        int left = [theNewCellFromDic[@"split_left"] intValue];
                        int bottom = [theNewCellFromDic[@"split_bottom"] intValue];
                        int right = [theNewCellFromDic[@"split_right"] intValue];
                        int iTop = [theNewCellFromDic[@"padding_top"] intValue]; ;
                        int iLeft = [theNewCellFromDic[@"padding_left"] intValue];;
                        int iBottom = [theNewCellFromDic[@"padding_bottom"] intValue];;
                        int iRight = [theNewCellFromDic[@"padding_right"] intValue];
                        NSString * colorStr = theNewCellFromDic[@"color"];
                        UIColor * textColor = [UIColor colorWithHexString:colorStr];
                        
                         imgValue1  =  [imgValue1 resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
                         imgValue2  =  [imgValue2 resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
                        
                        tempConfig.rightBubbleSettings.textSetting.normalBackgroundImage = imgValue1;
                        tempConfig.rightBubbleSettings.textSetting.highLightBackgroundImage = imgValue2;
                        tempConfig.rightBubbleSettings.textSetting.contentInsets = UIEdgeInsetsMake(iTop, iLeft, iBottom, iRight);
                        tempConfig.rightBubbleSettings.textSetting.textColor = textColor?:tempConfig.rightBubbleSettings.textSetting.textColor;

                        tempConfig.rightBubbleSettings.unsupportSetting.normalBackgroundImage = imgValue1;
                        tempConfig.rightBubbleSettings.unsupportSetting.highLightBackgroundImage = imgValue2;
                        tempConfig.rightBubbleSettings.unsupportSetting.contentInsets = UIEdgeInsetsMake(iTop, iLeft, iBottom, iRight);
                        tempConfig.rightBubbleSettings.unsupportSetting.textColor = textColor?:tempConfig.rightBubbleSettings.unsupportSetting.textColor;
                    }
                }
                
                if(normalOtherStr && downOtherStr){
                    NSString *key3 = normalOtherStr;
                    UIImage *imgValue3 =  [[NTESSkinQiPaoManager sharedQiPaoManager] skinQiPaoImg:key3];;
                    NSString *key4 = downOtherStr;
                    UIImage *imgValue4 =  [[NTESSkinQiPaoManager sharedQiPaoManager] skinQiPaoImg:key4];;
                    if(imgValue3 && imgValue4){
                        if(!tempConfig){
                           tempConfig = [[NIMKitConfig alloc] init];
                        }
                        int top = [theNewCelToDic[@"split_top"] intValue];
                        int left = [theNewCelToDic[@"split_left"] intValue];
                        int bottom = [theNewCelToDic[@"split_bottom"] intValue];
                        int right = [theNewCelToDic[@"split_right"] intValue];
                        int iTop = [theNewCelToDic[@"padding_top"] intValue]; ;
                        int iLeft = [theNewCelToDic[@"padding_left"] intValue];;
                        int iBottom = [theNewCelToDic[@"padding_bottom"] intValue];;
                        int iRight = [theNewCelToDic[@"padding_right"] intValue];
                        imgValue3  =  [imgValue3 resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
                        imgValue4  =  [imgValue4 resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
                        NSString * colorStr = theNewCellFromDic[@"color"];
                        UIColor * textColor = [UIColor colorWithHexString:colorStr];
                        
                        tempConfig.leftBubbleSettings.textSetting.normalBackgroundImage = imgValue3;
                        tempConfig.leftBubbleSettings.textSetting.highLightBackgroundImage = imgValue4;
                        tempConfig.leftBubbleSettings.textSetting.contentInsets = UIEdgeInsetsMake(iTop, iLeft, iBottom, iRight);
                        tempConfig.leftBubbleSettings.textSetting.textColor = textColor?:tempConfig.leftBubbleSettings.textSetting.textColor;
                        
                        tempConfig.leftBubbleSettings.unsupportSetting.normalBackgroundImage = imgValue3;
                        tempConfig.leftBubbleSettings.unsupportSetting.highLightBackgroundImage = imgValue4;
                        tempConfig.leftBubbleSettings.unsupportSetting.contentInsets = UIEdgeInsetsMake(iTop, iLeft, iBottom, iRight);
                        tempConfig.leftBubbleSettings.unsupportSetting.textColor = textColor?:tempConfig.leftBubbleSettings.unsupportSetting.textColor;
                    }
                }
                self.usingLVConfig = tempConfig;
                if(tempConfig){
                    _canUseNewChatText = YES;
                    self.useingChatTextDic = theNewChatTextDic;
                }
                
            }
            
            
        }@catch(...){
            _canUseNewChatText = NO;
            self.usingLVConfig = nil;
            self.useingChatTextDic = @{};
        }
        
    }

}

-(NIMKitConfig *) showChatConfig
{
    if(_canUseNewChatText){
        return _usingLVConfig;
    }
    return nil;
}
@end
