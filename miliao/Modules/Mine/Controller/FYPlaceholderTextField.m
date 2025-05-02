//
//  FYPlaceholderTextField.m
//  FanyouApp
//
//  Created by Wei942 on 2021/4/22.
//

#import "FYPlaceholderTextField.h"

#import <objc/runtime.h>

@implementation FYPlaceholderTextField

-(void)changePlaceholder{
    Ivar ivar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self, ivar);
    placeholderLabel.textColor = _placeholderColor;
    placeholderLabel.font = _placeholderFont;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self changePlaceholder];
}
-(void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    [self changePlaceholder];
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    [self changePlaceholder];
}

@end
