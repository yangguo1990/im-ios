//
//  LDSGiftShowView.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftShowView.h"
#import "LDSGiftModel.h"
#import "UIImageView+WebCache.h"

static const NSInteger animationTime = 3;
@interface LDSGiftShowView()

@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UILabel *whoNameLabel;
@property(nonatomic, strong) UILabel *sendWhatLabel;
@property(nonatomic, strong) UIImageView *giftImageView;
@property(nonatomic, strong) UILabel *countLabel;

@end

@implementation LDSGiftShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor]; //245 50
        self.hidden = YES;
        
        [self addSubview:self.backView];
        [self addSubview:self.whoNameLabel];
        [self addSubview:self.sendWhatLabel];
        [self addSubview:self.giftImageView];
        [self addSubview:self.countLabel];
    }
    return self;
}

- (void)showGiftShowViewWithModel:(LDSGiftModel *)giftModel completeBlock:(completeShowViewBlock)completeBlock {
    self.finishModel = giftModel;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftImage] placeholderImage:[UIImage imageNamed:@""]];
    self.whoNameLabel.text = giftModel.giftName;
    [self.whoNameLabel sizeToFit];
    self.sendWhatLabel.text = [NSString stringWithFormat:@"送 %@",giftModel.userName];
    [self.sendWhatLabel sizeToFit];
    
    CGRect frame = self.giftImageView.frame;
    frame.origin.x = CGRectGetMaxX(self.sendWhatLabel.frame) + 10;
    self.giftImageView.frame = frame;
    _backView.frame = CGRectMake(20, 5, CGRectGetMaxX(self.giftImageView.frame)-5, 40);
    
    self.hidden = NO;
    
    self.showViewFinishBlock = completeBlock;
    NSLog(@"当前展示的礼物--%@",giftModel.giftName);
    if (self.showViewKeyBlock && self.currentGiftCount == 0) {
        self.showViewKeyBlock(giftModel);
    }
    [self giftViewShow:giftModel.defaultCount];
}

- (void)giftViewShow:(NSInteger)defaultCount {  //第一次就调用 defaultCount
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(200, 0);
    } completion:^(BOOL finished) {
        self.currentGiftCount = 0;
        [self setGiftCount:defaultCount];
    }];
}

- (void)hiddenGiftShowView {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (self.showViewFinishBlock) {
            self.showViewFinishBlock(YES, self.finishModel.giftKey);
            self.finishModel = nil;
        }

        self.hidden = YES;
        self.currentGiftCount = 0;
        self.countLabel.text = @"";
    }];
}

- (void)setGiftCount:(NSInteger)giftCount {
    _giftCount = giftCount;
    self.currentGiftCount += giftCount;
    self.countLabel.text = [NSString stringWithFormat:@"x%zd",self.currentGiftCount];
    [self.countLabel sizeToFit];
    self.countLabel.center = CGPointMake(CGRectGetMaxX(_backView.frame) + 30, self.height / 2);
    
    NSLog(@"累计礼物数 %zd",self.currentGiftCount);
    
    if (self.currentGiftCount > 1) { //多次调用 count
        [self _p_SetAnimation];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenGiftShowView) object:nil];
        [self performSelector:@selector(hiddenGiftShowView) withObject:nil afterDelay:animationTime];
    } else { //第一次就调用 defaultCount
        [self performSelector:@selector(hiddenGiftShowView) withObject:nil afterDelay:animationTime];
    }
}

- (void)_p_SetAnimation { //放大字体效果
    [UIView animateWithDuration:0.15 animations:^{
        self.countLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        self.countLabel.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (UIView *)backView {
    if(_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, self.frame.size.width * 0.6, 40)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 20;
    }
    return _backView;
}

- (UILabel *)whoNameLabel {
    if(_whoNameLabel == nil) {
        _whoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 20, 5, 0, 19)];
        _whoNameLabel.text = @"Drive-Turbo";
        _whoNameLabel.textAlignment = NSTextAlignmentLeft;
        _whoNameLabel.font = [UIFont systemFontOfSize:18];
        _whoNameLabel.textColor = [UIColor whiteColor];
    }
    return _whoNameLabel;
}

- (UILabel *)sendWhatLabel {
    if(_sendWhatLabel == nil) {
        _sendWhatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 20, 26, 0, 14)];
        _sendWhatLabel.text = @"send Roses";
        _sendWhatLabel.textAlignment = NSTextAlignmentLeft;
        _sendWhatLabel.font = [UIFont systemFontOfSize:13];
        _sendWhatLabel.textColor = [UIColor whiteColor];
    }
    return _sendWhatLabel;
}

- (UIImageView *)giftImageView {
    if(_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + self.frame.size.width * 0.6 - 25, 0, 50, 50)];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UILabel *)countLabel {
    if(_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + self.frame.size.width * 0.6 + 45, 10, 0, 30)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:20];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"x1";
    }
    return _countLabel;
}

@end

