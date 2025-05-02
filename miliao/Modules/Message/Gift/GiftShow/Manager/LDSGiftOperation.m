//
//  LDSGiftOperation.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftOperation.h"
#import "LDSGiftShowView.h"
#import "LDSGiftModel.h"

@implementation LDSGiftOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)addOperationWithView:(LDSGiftShowView *)giftShowView
                              OnView:(UIView *)backView
                                Info:(LDSGiftModel *)model
                       completeBlock:(completeOpBlock)completeBlock {
    LDSGiftOperation *op = [[LDSGiftOperation alloc] init];
    op.giftShowView = giftShowView;
    op.model = model;
    op.backView = backView;
    op.opFinishedBlock = completeBlock;
    return op;
}

- (instancetype)init {
    if (self = [super init]) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)start { //子类要实现的方法
    if ([self isCancelled]) {
        _finished = YES;
        return;
    }
    
    _executing = YES;
    //NSLog(@"当前队列-- %@",self.model.giftName);
    __weak typeof(self) weakSelf = self;
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"currentThread - %@", [NSThread currentThread]);
        [weakSelf.backView addSubview:weakSelf.giftShowView];
        
        [weakSelf.giftShowView showGiftShowViewWithModel:weakSelf.model completeBlock:^(BOOL finished,NSString *giftKey) {
            weakSelf.finished = finished;
            if (weakSelf.opFinishedBlock) {
                weakSelf.opFinishedBlock(finished,giftKey);
            }
        }];
    }];
    
}

#pragma mark - 手动触发 KVO

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end

