//
//  ML_AppPopupExtension.m
//  WorkplaceApppPopupDemo
//
//  Created by Time on 2019/3/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "ML_AppPopupExtension.h"
#import "UIView+TFPopup.h"
@implementation ML_AppPopupExtension

-(NSMutableArray *)backgroundViewArray{
    if (_backgroundViewArray == nil) {
        _backgroundViewArray = [[NSMutableArray alloc]init];
    }
    return _backgroundViewArray;
}
-(NSMutableArray *)backgroundViewFrameArray{
    if (_backgroundViewFrameArray == nil) {
        _backgroundViewFrameArray = [[NSMutableArray alloc]init];
    }
    return _backgroundViewFrameArray;
}


@end


@implementation WorkplaceApppPopupPool

static WorkplaceApppPopupPool *_popupPool = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popupPool = [[WorkplaceApppPopupPool alloc]init];
    });
    return _popupPool;
}

+(void)refreshPool{
    [[WorkplaceApppPopupPool shareInstance]refreshPool];
}

-(void)refreshPool{
    NSMutableArray *newPool = [[NSMutableArray alloc]init];
    for (WorkplaceApppPopupPoolBridge *bridge in self.pool) {
        if (bridge.popupView != nil) {
            [newPool addObject:bridge];
        }
    }
    [self.pool removeAllObjects];
    [self.pool addObjectsFromArray:newPool];
}
+(void)addToPool:(UIView *)popupView{
    [[WorkplaceApppPopupPool shareInstance]addToPool:popupView];
}
-(void)addToPool:(UIView *)popupView{
    WorkplaceApppPopupPoolBridge *bridge = [[WorkplaceApppPopupPoolBridge alloc]init];
    bridge.popupView = popupView;
    [self.pool addObject:bridge];
}

+(UIView *)findPopup:(NSString *)identifier{
    return [[WorkplaceApppPopupPool shareInstance]findPopup:identifier];
}

-(UIView *)findPopup:(NSString *)identifier{
    for (WorkplaceApppPopupPoolBridge *bridge in self.pool) {
        if ([bridge.popupView.identifier isEqualToString:identifier]) {
            return bridge.popupView;
        }
    }
    return nil;
}
+(NSArray <UIView *>*)allPopup{
    return [[WorkplaceApppPopupPool shareInstance]allPopup];
}
-(NSArray <UIView *>*)allPopup{
    NSMutableArray *newPool = [[NSMutableArray alloc]init];
    for (WorkplaceApppPopupPoolBridge *bridge in self.pool) {
        if (bridge.popupView.superview != nil) {
            [newPool addObject:bridge.popupView];
        }
    }
    return newPool;
}
-(NSMutableArray *)pool{
    if (!_pool) {
        _pool = [[NSMutableArray alloc]init];
    }
    return _pool;
}

@end

@implementation WorkplaceApppPopupPoolBridge

@end
