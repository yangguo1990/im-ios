//
//  MLZhuxiaoShowView.m
//  miliao
//
//  Created by apple on 2022/10/24.
//

#import "MLZhuxiaoShowView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>

@interface MLZhuxiaoShowView()

@property(nonatomic,retain)UIView *alterView;

@property(nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIView *databgview;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong)UILabel *namelabel;

@property(nonatomic,strong)UILabel *userlabel;
@property(nonatomic,strong)UILabel *phonelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *timerlabel;
@property(nonatomic,strong)UIButton *lookbtn;
@end

@implementation MLZhuxiaoShowView

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        namelabel.textColor = [UIColor colorWithHexString:@"#333333"];
        namelabel.text = Localized(@"操作提示", nil);
        [self addSubview:namelabel];
        self.namelabel = namelabel;
        
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self addSubview:lineview];

        UILabel *contentlabel = [[UILabel alloc]init];
        contentlabel.text = @"确认删除这条招呼语吗?";
        contentlabel.textAlignment = NSTextAlignmentCenter;
        contentlabel.numberOfLines = 0;
        contentlabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        contentlabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:contentlabel];
        self.contentlabel = contentlabel;
        
        UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
        cancelbtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cancelbtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [cancelbtn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        self.cancelBtn = cancelbtn;
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
        lookbtn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [lookbtn setTitleColor:kZhuColor forState:UIControlStateNormal];
        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lookbtn];
        self.lookbtn = lookbtn;
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(25);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];

        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(namelabel.mas_bottom).mas_offset(24);
            make.right.mas_equalTo(self.mas_right).mas_offset(-16);
            make.left.mas_equalTo(self.mas_left).mas_offset(16);
            make.height.mas_equalTo(1);
        }];
        [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineview.mas_bottom).mas_offset(17);
            make.left.mas_equalTo(self.mas_left).mas_offset(28);
            make.right.mas_equalTo(self.mas_right).mas_offset(-27);
        }];
        [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_centerX).mas_offset(-0.5);
            make.left.mas_equalTo(self.mas_left).mas_offset(0);
            make.height.mas_equalTo(60);
        }];
        
        [lookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(self.mas_right).mas_offset(0);
            make.left.mas_equalTo(self.mas_centerX).mas_offset(0.5);
            make.height.mas_equalTo(60);
        }];
     }
    return self;
}

+(instancetype)alterViewWithTitle:(NSString *)title
                         content:(NSString *)content
                            sure:(NSString *)sure
                          cancel:(NSString *)cancel
                      sureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock{
    MLZhuxiaoShowView *alterView=[[MLZhuxiaoShowView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-80, 200)];
    alterView.backgroundColor = [UIColor whiteColor];
    alterView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    alterView.layer.cornerRadius = 16;
    alterView.layer.masksToBounds=YES;
    alterView.sure_block=sureBlock;
    [alterView.cancelBtn setTitle:sure forState:UIControlStateNormal];
    [alterView.lookbtn setTitle:cancel forState:UIControlStateNormal];
    alterView.namelabel.text = title;
    alterView.contentlabel.text = content;
    alterView.cancel_block = cancelBlock;
    return alterView;
}

#pragma mark--给属性重新赋值

-(void)setContent:(NSString *)content{
    _contentlabel.text = content;
}

-(void)settitle:(NSString *)title{
    _namelabel.text = title;
}

-(void)setsure:(NSString *)sure{
    _titleLb.text = sure;
}






//-(void)setSure:(NSString *)sure{
////    [_sureBt setTitle:sure forState:UIControlStateNormal];
//}

#pragma mark----确定按钮点击事件
-(void)cancelclick{
    [self removeFromSuperview];
     self.cancel_block();
}

-(void)lookclick{
    NSLog(@"hehheheh");
    [self removeFromSuperview];
    self.sure_block();
}


@end
