//
//  LDSGiftShowManager.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftShowManager.h"
#import "LDSGiftShowView.h"
#import "LDSGiftModel.h"
#import "LDSGiftOperation.h"

@interface LDSGiftShowManager()

/** 队列 */
@property(nonatomic,strong) NSOperationQueue *giftQueue1;
@property(nonatomic,strong) NSOperationQueue *giftQueue2;
/** showgift */
@property(nonatomic,strong) LDSGiftShowView *giftShowView1;
@property(nonatomic,strong) LDSGiftShowView *giftShowView2;
/** 操作缓存 */
@property(nonatomic,strong) NSCache *operationCache;

/** 当前礼物的keys */
@property(nonatomic,strong) NSMutableArray *curentGiftKeys;

@end

static LDSGiftShowManager *kLDSGiftShowManager = nil;
@implementation LDSGiftShowManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kLDSGiftShowManager = [[self alloc] init];
    });
    return kLDSGiftShowManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kLDSGiftShowManager = [super allocWithZone:zone];
    });
    return kLDSGiftShowManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return kLDSGiftShowManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return kLDSGiftShowManager;
}

- (void)showGiftViewWithBackView:(UIView *)backView info:(LDSGiftModel *)giftModel completeBlock:(completeBlock)completeBlock {
    if (self.curentGiftKeys.count && [self.curentGiftKeys containsObject:giftModel.giftKey]) { //有当前的礼物信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) { //当前存在操作 连击
            LDSGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.giftShowView.giftCount = giftModel.sendCount; //赋值当前礼物数 连击效果
        } else {
            NSOperationQueue *queue;
            LDSGiftShowView *showView;
            if (self.giftQueue1.operations.count <= self.giftQueue2.operations.count) { //哪个队列的任务少就塞哪个
                queue = self.giftQueue1;
                showView = self.giftShowView1;
            } else {
                queue = self.giftQueue2;
                showView = self.giftShowView2;
            }
            
            //当前操作已结束 重新创建
            __weak typeof(self) weakSelf = self;
            LDSGiftOperation *operation = [LDSGiftOperation addOperationWithView:showView OnView:backView Info:giftModel completeBlock:^(BOOL finished, NSString *giftKey) {
                if (completeBlock) {
                    completeBlock(finished);
                }
                //移除操作
                [weakSelf.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                [weakSelf.curentGiftKeys removeObject:giftKey];
            }];
            operation.model.defaultCount += giftModel.sendCount; //从0开始
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列 会自行等待
            [queue addOperation:operation];
        }
    } else {  //没有礼物的信息
        if ([self.operationCache objectForKey:giftModel.giftKey]) { //当前存在操作
            LDSGiftOperation *op = [self.operationCache objectForKey:giftModel.giftKey];
            op.model.defaultCount += giftModel.sendCount; //赋值当前礼物数
        } else {
            NSOperationQueue *queue;
            LDSGiftShowView *showView;
            if (self.giftQueue1.operations.count <= self.giftQueue2.operations.count) {
                queue = self.giftQueue1;
                showView = self.giftShowView1;
            } else {
                queue = self.giftQueue2;
                showView = self.giftShowView2;
            }
            
            __weak typeof(self) weakSelf = self;
            LDSGiftOperation *operation = [LDSGiftOperation addOperationWithView:showView OnView:backView Info:giftModel completeBlock:^(BOOL finished, NSString *giftKey) {
                if (completeBlock) {
                    completeBlock(finished);
                }
                if ([weakSelf.giftShowView1.finishModel.giftKey isEqualToString:weakSelf.giftShowView2.finishModel.giftKey]) { //和上一个相同则不操作
                    return ;
                }
                //移除操作
                [weakSelf.operationCache removeObjectForKey:giftKey];
                //清空唯一key
                [weakSelf.curentGiftKeys removeObject:giftKey];
            }];
            operation.model.defaultCount += giftModel.sendCount;
            //存储操作信息
            [self.operationCache setObject:operation forKey:giftModel.giftKey];
            //操作加入队列 会自行等待
            [queue addOperation:operation];
        }
    }
    [self _changeShowGiftViewPosition];
}

- (void)_changeShowGiftViewPosition { //交换各自位置
    if(CGRectGetMaxY(self.giftShowView1.frame) < CGRectGetMaxY(self.giftShowView2.frame)) { //giftShowView1高
        NSInteger topCount = self.giftShowView1.currentGiftCount;
        NSInteger bottomCount = self.giftShowView2.currentGiftCount;
        if(topCount == bottomCount || topCount == 0 || bottomCount == 0) {
            return;
        }
        if(topCount < bottomCount) { //底部count大 顶部frame.y高
            [UIView animateWithDuration:0.3 animations:^{
                self.giftShowView1.frame = CGRectMake(0, 250, 200, 50);
                self.giftShowView2.frame = CGRectMake(0, 100, 200, 50);
                //不是实际交换位置 会导致重叠
                //self.giftShowView1.transform = CGAffineTransformMakeTranslation(220, 50);
                //self.giftShowView2.transform = CGAffineTransformMakeTranslation(220, - 50);
            }];
        }
    } else { //giftShowView2高
        NSInteger topCount = self.giftShowView2.currentGiftCount;
        NSInteger bottomCount = self.giftShowView1.currentGiftCount;
        if(topCount == bottomCount || topCount == 0 || bottomCount == 0) {
            return;
        }
        if(topCount < bottomCount) { //底部count大 顶部frame.y高
            [UIView animateWithDuration:0.3 animations:^{
                self.giftShowView1.frame = CGRectMake(0, 200, 200, 50);
                self.giftShowView2.frame = CGRectMake(0, 250, 200, 50);
                //不是实际交换位置 会导致重叠
                //self.giftShowView1.transform = CGAffineTransformMakeTranslation(220, 0);
                //self.giftShowView2.transform = CGAffineTransformMakeTranslation(220, 0);
            }];
        }
    }
}

- (LDSGiftShowView *)giftShowView1 {
    if (_giftShowView1 == nil) {
        _giftShowView1 = [[LDSGiftShowView alloc] initWithFrame:CGRectMake(-200, 200, 200, 50)];
        __weak typeof(self) weakSelf = self;
        [_giftShowView1 setShowViewKeyBlock:^(LDSGiftModel *giftModel) {
            [weakSelf.curentGiftKeys addObject:giftModel.giftKey];
        }];
    }
    return _giftShowView1;
}

- (LDSGiftShowView *)giftShowView2 {
    if (_giftShowView2 == nil) {
        _giftShowView2 = [[LDSGiftShowView alloc] initWithFrame:CGRectMake(-200, 250, 200, 50)];
        __weak typeof(self) weakSelf = self;
        [_giftShowView2 setShowViewKeyBlock:^(LDSGiftModel *giftModel) {
            [weakSelf.curentGiftKeys addObject:giftModel.giftKey];
        }];
    }
    return _giftShowView2;
}

- (NSOperationQueue *)giftQueue1 {
    if (_giftQueue1 == nil) {
        _giftQueue1 = [[NSOperationQueue alloc] init];
        _giftQueue1.maxConcurrentOperationCount = 1;
    }
    return _giftQueue1;
}

- (NSOperationQueue *)giftQueue2 {
    if (_giftQueue2 == nil) {
        _giftQueue2 = [[NSOperationQueue alloc] init];
        _giftQueue2.maxConcurrentOperationCount = 1;
    }
    return _giftQueue2;
}

- (NSMutableArray *)curentGiftKeys {
    if (_curentGiftKeys == nil) {
        _curentGiftKeys = [NSMutableArray array];
    }
    return _curentGiftKeys;
}

- (NSCache *)operationCache {
    if (_operationCache == nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

@end

