//
//  ML_AppPopupLoading.m
//  WorkplaceApppPopupDemo
//
//  Created by zhutaofeng on 2019/5/13.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "ML_AppPopupLoading.h"
#import "UIView+TFPopup.h"

@interface ML_AppPopupLoading ()<WorkplaceApppPopupDelegate>

@property(nonatomic,assign)CGRect inViewFrame;
@property(nonatomic,  copy)NSString *msg;
@property(nonatomic,  copy)ML_AppPopupLoadingBlock cusBlock;

@end
@implementation ML_AppPopupLoading

-(void)dealloc{
#if DEBUG
    NSLog(@"****** ML_AppPopupLoading(已释放) msg:%@ ******",self.msg);
#endif
}

+(void)tf_show:(UIView *)inView animationType:(TFAnimationType)animationType{
    [ML_AppPopupLoading tf_show:inView msg:@"正在加载..." animationType:animationType];
}

+(void)tf_show:(UIView *)inView msg:(NSString *)msg animationType:(TFAnimationType)animationType{
    [ML_AppPopupLoading tf_show:inView
                        msg:msg
                     offset:CGPointZero
              animationType:animationType
                customBlock:nil];
}

+(void)tf_show:(UIView *)inView
           msg:(NSString *)msg
        offset:(CGPoint)offset
 animationType:(TFAnimationType)animationType
   customBlock:(ML_AppPopupLoadingBlock)customBlock{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    if (msg == nil) {NSLog(@"****** %@ %@ ******",[self class],@"msg 不能为空！");return;}
    
    ML_AppPopupParam *param = [ML_AppPopupParam new];
    param.backgroundColorClear = YES;
    param.offset = offset;
    param.popupSize = CGSizeMake(90, 90);
    param.disuseBackgroundTouchHide = YES;
    
    ML_AppPopupLoading *loading = [[ML_AppPopupLoading alloc]initWithFrame:CGRectZero];
    loading.inViewFrame = inView.bounds;
    loading.msg = msg;
    loading.cusBlock = customBlock;
    
    switch (animationType) {
        case TFAnimationTypeFade:
            [loading tf_showNormal:inView popupParam:param];
            break;
        case TFAnimationTypeScale:
            [loading tf_showScale:inView offset:CGPointZero popupParam:param];
            break;
        default:
            break;
    }
}

+(void)tf_hide:(UIView *)inView{
    for (UIView *loading in inView.subviews) {
        if ([loading isKindOfClass:[ML_AppPopupLoading class]]) {
            [loading tf_hide];
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        self.userInteractionEnabled = NO;
        
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
        
        [self addSubview:self.msgLabel];
    }
    return self;
}

-(void)setMsg:(NSString *)msg{
    _msg = [msg copy];
    self.msgLabel.text = msg;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect sf = self.bounds;
    if (self.msg == nil || self.msg.length == 0) {
        self.indicatorView.center = CGPointMake(sf.size.width * 0.5, sf.size.height * 0.5);
        self.msgLabel.frame = CGRectMake(10, sf.size.height * 0.5 + 10, sf.size.width - 20, 0);
    }else{
        self.indicatorView.center = CGPointMake(sf.size.width * 0.5, 35);
        self.msgLabel.frame = CGRectMake(10, sf.size.height * 0.5 + 10, sf.size.width - 20, 20);
    }
}

-(UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

-(UILabel *)msgLabel{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.font = [UIFont systemFontOfSize:13];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.numberOfLines = 0;
        _msgLabel.lineBreakMode = NSLineBreakByClipping;
        _msgLabel.clipsToBounds = YES;
    }
    return _msgLabel;
}




@end
