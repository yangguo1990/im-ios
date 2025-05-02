//
//  MLFaceViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFaceViewController.h"
#import "MLTuijianuserlistTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>



@interface MLFaceViewController ()

@end

@implementation MLFaceViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self giveML_getTypeHostsApi];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorFromHexString:@"#000000"];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(296);
    }];
        
    UIView *videoView = [[UIView alloc]init];
    videoView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:videoView];
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text =Localized(@"视频认证", nil) ;
    titlelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(bottomView.mas_top).mas_offset(12);
    }];

    UILabel *titlelabelone = [[UILabel alloc]init];
    titlelabelone.text = Localized(@"·录制需展露全脸,自我介绍我是(昵称与注册一致)/我是(职业)/我喜欢(爱好和特长) ...", nil);
    titlelabelone.numberOfLines = 0;
    titlelabelone.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabelone.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabelone.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:titlelabelone];
    [titlelabelone mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(25);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-25);
        make.top.mas_equalTo(titlelabel.mas_bottom).mas_offset(14);
    }];
    
    UILabel *titlelabeltwo = [[UILabel alloc]init];
    titlelabeltwo.text = Localized(@"·首页推荐和排行榜等均需认证通过", nil);
    titlelabeltwo.numberOfLines = 0;
    titlelabeltwo.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabeltwo.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabeltwo.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titlelabeltwo];
    [titlelabeltwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titlelabelone.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(titlelabelone.mas_left);
    }];

    UILabel *titlelabelthree = [[UILabel alloc]init];
    titlelabelthree.text = Localized(@"·拍摄3-10秒视频,通过审核有丰富奖励", nil) ;
    titlelabelthree.numberOfLines = 0;
    titlelabelthree.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titlelabelthree.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabelthree.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titlelabelthree];
    [titlelabelthree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titlelabeltwo.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(titlelabelone.mas_left);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickAction)forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitle:Localized(@"长按", nil) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"changan"] forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    CGSize buttonSize = btn.frame.size;
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    /// 图片的向上偏移titleLabel的高度（如果觉得图片和文字挨的太近，可以增加向上的值）【负值】，0，0，图片右边偏移偏移按钮的宽减去图片的宽然后除以2【正值】
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(titleSize.height) - 8, 0, 0, (buttonSize.width - imageSize.width) / 2)];
    /// 文字的向上偏移图片的高度【正值】，向左偏移图片的宽带【负值】，0，0
    [btn setTitleEdgeInsets:UIEdgeInsetsMake((imageSize.height) ,-(imageSize.width), 0,0)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.view.mas_bottom).offset(-SSL_TabbarMLMargin);
       //  make.bottom.equalTo(self.view.mas_bottom).offset(-70);
      make.size.mas_equalTo(CGSizeMake(60 , 110));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [btn layoutIfNeeded];

}


-(void)clickAction{
    NSLog(@"heheheh");
}


@end
