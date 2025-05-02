//
//  ML_SHowView.m
//  miliao
//
//  Created by apple on 2022/8/31.
//

#import "ML_SHowView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface ML_SHowView()<NERtcCallKitDelegate>

@property(nonatomic,retain)UIView *alterView;
@property (nonatomic,strong)UIView *bgView0;
@property(nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIImageView *img2;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIView *databgview;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong) UILabel *namelabel;
@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音
@property(nonatomic,strong)UILabel *userlabel;
@property(nonatomic,strong)UILabel *phonelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *timerlabel;
@property(nonatomic,strong)UIButton *lookbtn;
@end

@implementation ML_SHowView

- (AVAudioPlayer *)player {
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"mp3"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = 30;
    }
    return _player;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        
        [[NERtcCallKit sharedInstance] addDelegate:self];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        
        UIView *bgView0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 295*mWidthScale, 360*mHeightScale)];
        bgView0.backgroundColor=[UIColor whiteColor];
        bgView0.layer.cornerRadius = 16;
        bgView0.layer.masksToBounds = YES;
        bgView0.center = CGPointMake(WIDTH/2, HEIGHT/2);
        [self addSubview:bgView0];
        self.bgView0 = bgView0;
        
        UIImageView *topBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 295*mWidthScale, 168*mHeightScale)];
        topBg.image=kGetImage(@"showTop");
        [bgView0 addSubview:topBg];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = UIColor.whiteColor;
//        bgView.layer.cornerRadius=5;
//        bgView.layer.masksToBounds=YES;
        [bgView0 addSubview:bgView];
        self.bgView = bgView;
        
        UIImageView *img = [[UIImageView alloc]init];
        img.backgroundColor=UIColor.clearColor;
        img.layer.cornerRadius=44*mHeightScale;
        img.layer.masksToBounds=YES;
        img.image = [UIImage imageNamed:@"Group 2174"];
        [bgView0 addSubview:img];
        self.img = img;
        
        
//        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 110, 110)];
//        img2.layer.cornerRadius = 44*mHeightScale;
//        img2.layer.masksToBounds = YES;
//        //imgbgView.userInteractionEnabled = YES;
//        [self.img addSubview:img2];
//        self.img2 = img2;
        
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        namelabel.textColor = [UIColor colorWithHexString:@"000000"];
        namelabel.text = @"小可爱李真真";
        [bgView0 addSubview:namelabel];
        self.namelabel = namelabel;
        
        UILabel *contentlabel = [[UILabel alloc]init];
        contentlabel.text = @"24岁/模特/165cm/45kg";
        contentlabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
        contentlabel.textColor = [UIColor colorWithHexString:@"b4b4b4"];
        [bgView0 addSubview:contentlabel];
        self.contentlabel = contentlabel;
        
        
        UIButton *dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dashanbtn setTitle:@"清纯女神" forState:UIControlStateNormal];
        dashanbtn.backgroundColor = [UIColor colorWithRed:131/255.0 green:93/255.0 blue:255/255.0 alpha:0.1];
        [dashanbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dashanbtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        dashanbtn.layer.cornerRadius = 16;
        dashanbtn.hidden = YES;
        [bgView0 addSubview:dashanbtn];

        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [bgView0 addSubview:cancelbtn];
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        [bgView0 addSubview:lookbtn];
        self.lookbtn = lookbtn;
//        if (kisCH) {
//            [lookbtn setBackgroundImage:[UIImage imageNamed:@"Slice 30"] forState:UIControlStateNormal];
            [cancelbtn setBackgroundImage:[UIImage imageNamed:@"showCancel"] forState:UIControlStateNormal];
//        } else {
//            lookbtn.backgroundColor = kZhuColor;
            cancelbtn.backgroundColor = [UIColor whiteColor];
            lookbtn.layer.cornerRadius = 22*mHeightScale;
            cancelbtn.layer.cornerRadius = 22*mHeightScale;
        [lookbtn setBackgroundImage:kGetImage(@"showAccept") forState:UIControlStateNormal];
//            [lookbtn setTitle:Localized(@"接听", nil) forState:UIControlStateNormal];
////            [cancelbtn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
//            [lookbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView0.mas_top).mas_offset(168*mHeightScale);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView0.mas_top).offset(40*mHeightScale);
            make.centerX.mas_equalTo(bgView0.mas_centerX);
            make.width.height.mas_equalTo(88*mWidthScale);
        }];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(img.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(bgView0.mas_centerX);
        }];
        
        [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(namelabel.mas_bottom).mas_offset(18);
            make.centerX.mas_equalTo(bgView0.mas_centerX);
        }];

        [dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView0.mas_centerX);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(32);
            make.top.mas_equalTo(contentlabel.mas_bottom).mas_offset(18);

        }];

        [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bgView0.mas_bottom).mas_offset(-16);
            make.left.mas_equalTo(bgView0.mas_left).mas_offset(16*mWidthScale);
            make.height.mas_equalTo(44*mHeightScale);
            make.width.mas_equalTo(103*mWidthScale);
        }];
        
        [lookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bgView0.mas_bottom).mas_offset(-16);
            make.left.mas_equalTo(bgView0.mas_left).mas_offset(135*mWidthScale);
            make.height.mas_equalTo(44*mHeightScale);
            make.width.mas_equalTo(144*mWidthScale);
        }];
        [self.player play];
     }
    return self;
}

- (void)onUserCancel:(NSString *)userID
{
    
    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
        
//        [self hiddenView];
        [[NERtcCallKit sharedInstance] removeDelegate:self];
    }];
    
    
    [self hiddenView];
    
}
- (void)onUserLeave:(NSString *)userID
{
    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
        
//        [self hiddenView];
        [[NERtcCallKit sharedInstance] removeDelegate:self];
    }];
    
    
    [self hiddenView];
}
- (void)onUserDisconnect:(NSString *)userID
{
    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
        
//        [self hiddenView];
        [[NERtcCallKit sharedInstance] removeDelegate:self];
    }];
    
    
    [self hiddenView];
}


- (void)setDic:(NSDictionary *)dic sureBtClcik:(sureBlock)sureBlock cancelClick:(cancelBlock)cancelBlock
{
    
    [self.img sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
    self.namelabel.text = dic[@"name"];
//    self.namelabel.backgroundColor = [UIColor redColor];
    
    if ([dic[@"age"] boolValue]) {
        self.contentlabel.text = [NSString stringWithFormat:@"%@岁/%@cm/%@kg", dic[@"age"], [dic[@"height"] boolValue]?dic[@"height"]:@"0", [dic[@"weight"] boolValue]?dic[@"weight"]:@"0"];
        
        if ([dic[@"pro"] length]) {
            self.contentlabel.text = [NSString stringWithFormat:@"%@岁/%@/%@cm/%@kg", dic[@"age"], dic[@"pro"], [dic[@"height"] boolValue]?dic[@"height"]:@"0", [dic[@"weight"] boolValue]?dic[@"weight"]:@"0"];
        }
        
    } else {
        if([dic[@"pro"] isEqual:[NSNull null]]) {
            
            self.contentlabel.text = [NSString stringWithFormat:@"%@cm/%@kg", [dic[@"height"] boolValue]?dic[@"height"]:@"0", [dic[@"weight"] boolValue]?dic[@"weight"]:@"0"];
            
        } else {
            
            self.contentlabel.text = [NSString stringWithFormat:@"%@/%@cm/%@kg", dic[@"pro"], [dic[@"height"] boolValue]?dic[@"height"]:@"0", [dic[@"weight"] boolValue]?dic[@"weight"]:@"0"];
        }
    }
    NSArray *arr = dic[@"userLabels"];
//    arr = @[[arr lastObject], [arr lastObject], [arr lastObject]];
    CGFloat maxW = 0;
    int i = 0;
    
    UILabel *v1 = nil;
    UILabel *v2 = nil;
    UILabel *v3 = nil;
    
    for (NSDictionary *dic in arr) {

        CGSize laVsize = [dic[@"name"]?:@"" sizeWithFont:kGetFont(14) maxSize:CGSizeMake(100, 20)];
        UILabel *laV = [[UILabel alloc] initWithFrame:CGRectMake(maxW, 215, laVsize.width + 15, 32)];
        
        
        if (i == 0) {
            v1 = laV;
        } else if (i == 1) {
            v2 = laV;
        } else if (i == 2) {
            v3 = laV;
        }
        
        
        
        laV.textColor = [UIColor colorWithHexString:dic[@"color"]];
        laV.font = kGetFont(14);
        laV.backgroundColor = [UIColor colorWithHexString:dic[@"color"] alpha:0.15];
        laV.text = dic[@"name"];
        laV.layer.cornerRadius = 16;
        laV.layer.masksToBounds = YES;
        laV.textAlignment = NSTextAlignmentCenter;
        [self.bgView0 addSubview:laV];
        laV.tag = 10000 + i;
        maxW = CGRectGetMaxX(laV.frame) + 8;

        if (i == arr.count-1) {
            maxW = CGRectGetMaxX(laV.frame) - 8;

            CGFloat x = (self.bgView0.width - maxW) / 2 - 4;

                if (v1) {
                    v1.frame = CGRectMake(x, v1.y, v1.width, v1.height);
                }
                if (v2) {
                    v2.frame = CGRectMake(x + v1.width + 8, v1.y, v2.width, v2.height);
                }
                if (v3) {
                    v3.frame = CGRectMake(x + v1.width + 8 * 2 + v2.width, v1.y, v3.width, v3.height);
                }

            break;
        }
        i ++;
    }
    
    
    self.sure_block=sureBlock;
    self.cancel_block = cancelBlock;
}

- (void)hiddenView {
    
    [self.player stop];
    [self removeFromSuperview];
}

#pragma mark----确定按钮点击事件
-(void)cancelclick{
    self.cancel_block();
    
    [self hiddenView];
}

-(void)lookclick{
    self.sure_block();
    [self hiddenView];
}

- (void)show
{
    [KEY_WINDOW.window addSubview:self];
}

@end
