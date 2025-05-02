//
//  ML_CityTableViewCell.m
//  miliao
//
//  Created by apple on 2022/8/30.
//

#import "ML_CityTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
#import "ML_sayHelloApi.h"
@interface ML_CityTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;

@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *cityView;
@property (nonatomic,strong)UILabel *adrrnameLabel;


@property (nonatomic,strong)UIImageView *hostimg;


@property (nonatomic,strong)UIImageView *onlineimg;
@end


@implementation ML_CityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setCell];
    }
    return self;
}


-(void)setCell{
    UIView *bg = [[UIImageView alloc]init];
    bg.layer.cornerRadius = 8;
    bg.layer.masksToBounds = YES;
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = [UIColor colorWithHexString:@"#FDE9F1"].CGColor;
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width - 32);
        make.height.mas_equalTo(102);
    }];
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.layer.cornerRadius = 8;
    img.layer.masksToBounds = YES;
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    [bg addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bg.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(bg.mas_centerY);
        make.width.height.mas_equalTo(70);
    }];
    [img layoutIfNeeded];
    
    UIImageView *onlineImg = [[UIImageView alloc]init];
    [bg addSubview:onlineImg];
    self.onlineimg = onlineImg;
    [onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.bottom.mas_equalTo(self.img.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
    
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
    [img addSubview:selectimg];
    self.selectimg = selectimg;
//    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(30);
//        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
//        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
//        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
//        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
//
//    }];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 16, 100, 22)];
    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [bg addSubview:nameLabel];
    self.nameLabel = nameLabel;
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(img.mas_right).mas_offset(16);
//        make.top.mas_equalTo(img.mas_top);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-120);
//    }];
    
    
    UIImageView *hostimg = [[UIImageView alloc]init];
//    hostimg.contentMode = UIViewContentModeScaleAspectFit;
    hostimg.image = [UIImage imageNamed:@"tags_real_18"];
    [bg addSubview:hostimg];
    self.hostimg = hostimg;
    [hostimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(96);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(18);
    }];
    
    [self.hostimg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
    }];
    
    UIButton *agebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agebtn setTitle:@"32" forState:UIControlStateNormal];
    [agebtn setBackgroundImage:[UIImage imageNamed:@"label_female_18"] forState:UIControlStateNormal];
    [agebtn setBackgroundImage:[UIImage imageNamed:@"label_male_18"] forState:UIControlStateSelected];
//    agebtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;
    [agebtn setTitleColor:[UIColor colorWithHexString:@"#FF458E"] forState:UIControlStateNormal];
    [agebtn setTitleColor:[UIColor colorWithHexString:@"#4DA6FF"] forState:UIControlStateSelected];
    agebtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
//    agebtn.layer.cornerRadius = 7;
    agebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [bg addSubview:agebtn];
    self.agebtn = agebtn;
    [agebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51.5);
        make.left.mas_equalTo(hostimg.mas_right).mas_offset(10);
//        make.left.mas_equalTo(150);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(14);
    }];
    
    
    UIButton *agebtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [agebtn2 setBackgroundImage:kGetImage(@"label_address_18") forState:UIControlStateNormal];
    [bg addSubview:agebtn2];
    [agebtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(agebtn.mas_right).mas_offset(10);
//        make.left.mas_equalTo(150);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(18);
    }];
    
    
    
    UILabel *ciytView = [[UILabel alloc] init]; //
    ciytView.textAlignment = NSTextAlignmentLeft;
    [ciytView setTextColor:[UIColor colorWithHexString:@"#FF5029"]];
    ciytView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [agebtn2 addSubview:ciytView];
    self.cityView = ciytView;
    [ciytView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(18);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(18);
    }];
    

    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setImage:[UIImage imageNamed:@"icon_pick_up_24"] forState:UIControlStateNormal];
    [self.dashanbtn setImage:[UIImage imageNamed:@"icon_reply_blue_24"] forState:UIControlStateSelected];
//    [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
//    [self.dashanbtn setImage:[UIImage imageNamed:@"icon_pick_up_24"] forState:UIControlStateNormal];
//    self.dashanbtn.layer.borderWidth = 0.5;
//    self.dashanbtn.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
//    [self.dashanbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
//    self.dashanbtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
//    self.dashanbtn.layer.cornerRadius = 16;
//    self.dashanbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0, 2);
//    self.dashanbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [self.dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-12);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(16);
    }];

    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
    [videobtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videobtn];
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(self.dashanbtn.mas_left).mas_offset(-10);
        //make.centerY.mas_equalTo(dashanbtn.mas_centerY);
        make.top.mas_equalTo(20);

    }];
    
    UILabel *tnameLabel = [[UILabel alloc]init];
//    tnameLabel.text = @"有点小内向但是熟了就好了,幽默成熟稳...";
    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [bg addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(96);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-150);
        make.top.mas_equalTo(agebtn.mas_bottom).mas_offset(7);
    }];

    
    UILabel *adrrnameLabel = [[UILabel alloc]init];
    adrrnameLabel.text = @"10km";
    adrrnameLabel.hidden = YES;
    adrrnameLabel.textAlignment = NSTextAlignmentCenter;
    adrrnameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    adrrnameLabel.textColor = [UIColor colorFromHexString:@"#FF666666"];
    [bg addSubview:adrrnameLabel];
    self.adrrnameLabel = adrrnameLabel;
    [adrrnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(agebtn.mas_right).mas_offset(6);
        make.centerY.mas_equalTo(agebtn.mas_centerY);
    }];
    
//    UIView *lineview = [[UIView alloc]init];
//    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
//    [bg addSubview:lineview];
//    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(76);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
//        make.right.mas_equalTo(self.contentView.mas_right);
//        make.height.mas_equalTo(1);
//    }];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.cityView.text = nil;
//    if ([dict[@"any_value"][@"province"] length] && ![dict[@"any_value"][@"province"] isEqual:[NSNull null]]) {
//
//        self.cityView.text = [NSString stringWithFormat:@"城市：%@", dict[@"any_value"][@"province"]];
//    }
    self.cityView.text = [NSString stringWithFormat:@"%@", dict[@"province"]];
    
    
    if ([dict[@"online"] integerValue] == 1) {
        self.onlineimg.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([dict[@"online"] integerValue] == 2){
        self.onlineimg.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([dict[@"online"] integerValue] == 3){
        self.onlineimg.image = kGetImage(@"label_online");
    } else {
        self.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    
    [_img sd_setImageWithURL:kGetUrlPath(dict[@"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    //self.nameLabel.text = dict[@"name"];
    self.nameLabel.text = dict[@"name"];
//     if (self.nameLabel.text.length > 6) {
//         NSString *str1 = [self.nameLabel.text substringToIndex:6];//截取掉下标5之前的字符串
//         self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
//     }else{
         self.nameLabel.text = dict[@"name"];
//    self.nameLabel.text = @"山东分公司的风格山东分公司的风格";
         CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(110, 22)];
         self.nameLabel.frame = CGRectMake(96, 16, size.width, 22);
//         self.hostimg.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.y, 41.5, self.nameLabel.height);
//     }

    if (![dict[@"persionSign"] length]) {
        self.tnameLabel.text = @"";
    }else{
        self.tnameLabel.text = dict[@"persionSign"];
    };
    
    
    if ([dict[@"gender"] integerValue] == 0) {//nv
        self.agebtn.selected = NO;
//        [self.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
//        self.agebtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
    }else{
        self.agebtn.selected = YES;
//        [self.agebtn setImage:[UIImage imageNamed:@"icon_nansheng_24_sel-1"] forState:UIControlStateNormal];
//        self.agebtn.backgroundColor = [UIColor colorWithRed:175/255.0 green:189/255.0 blue:250/255.0 alpha:1.0];
    }
    [self.agebtn setTitle:[NSString stringWithFormat:@"%@",dict[@"age"]] forState:UIControlStateNormal];

    if ([_dict[@"host"] integerValue] == 0) {
        self.hostimg.hidden = YES;
        
        [self.hostimg mas_updateConstraints:^(MASConstraintMaker *make) {
            
                make.left.mas_equalTo(86);
                make.width.mas_equalTo(0);
        }];
    }else{
        self.hostimg.hidden = NO;
        
        [self.hostimg mas_updateConstraints:^(MASConstraintMaker *make) {
            
                make.left.mas_equalTo(96);
                make.width.mas_equalTo(46);
        }];
    }
    
    
//    float starting = [dict[@"distance"] floatValue];
//    float formatted = starting/1000.0;
//    NSString *formattedstr = [NSString stringWithFormat:@"%.1fkm", formatted];
    self.adrrnameLabel.text = _dict[@"province"];

    self.dashanbtn.selected = [dict[@"call"] boolValue];
    if ([dict[@"call"] integerValue] == 0) {//nv
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
//        self.dashanbtn.layer.borderWidth = 0.5;
//        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(65);
//            make.height.mas_equalTo(32);
//        }];
    }else{
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
//        self.dashanbtn.layer.borderWidth = 0;
//        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(40);
//            make.height.mas_equalTo(28);
//        }];

    }

}

//- (void)setType:(CityUITableViewCell)type{
//    if (type == CityUITableViewCellfocus) {
//        self.agebtn.hidden = YES;
//        self.adrrnameLabel.hidden = YES;
//        [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.width.height.mas_equalTo(50);
//        }];
//        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.img.mas_right).mas_offset(16);
//            make.top.mas_equalTo(self.img.mas_top);
//        }];
//        [self.tnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.nameLabel.mas_left);
//                make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(7);
//        }];
//    }else{
//        self.agebtn.hidden = NO;
//        self.adrrnameLabel.hidden = NO;
//        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.img.mas_right).mas_offset(16);
//            make.top.mas_equalTo(self.img.mas_top);
//        }];
//        [self.tnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.nameLabel.mas_left);
//                make.top.mas_equalTo(self.agebtn.mas_bottom).mas_offset(7);
//        }];
//    }
//
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    [self.img layoutIfNeeded];
}


-(void)dashanClick:(UIButton *)btn{
    
     if (self.clickcellCityButtonBlock && [_dict[@"call"] integerValue] == 0) {
         
         NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
         ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:_dict[@"userId"] extra:[self jsonStringForDictionary]];
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
             NSLog(@"打招呼%@",response.data);
             //[self showMessage:@"打招呼成功,可以给好友私信啦"];
            // [self giveML_getTypeHostsApi];
             btn.selected = !btn.selected;
//             if ([response.status integerValue] == 0) {
//                 [btn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//                 [btn setTitle:@"" forState:UIControlStateNormal];
//                 btn.layer.borderWidth = 0;
//                 [btn mas_updateConstraints:^(MASConstraintMaker *make) {
//                     make.width.mas_equalTo(40);
//                     make.height.mas_equalTo(28);
//                 }];
                 self.clickcellCityButtonBlock(btn);
     //           [self.statusArray insertObject:@"1" atIndex:index];
     //            [self.tablview reloadData];
//             }
         } error:^(MLNetworkResponse *response) {
         } failure:^(NSError *error) {
         }];
         
         
     } else {
         [self gotoChatVC:_dict[@"userId"]];
     }

    
//    NIMMessage *message = [[NIMMessage alloc] init];
//    message.text = @"你好，可以认识一下吗？";
//
//    NSError * error = nil;
//    // @"15198698"
//    NIMSession * session = [NIMSession session:[NSString stringWithFormat:@"%@", _dict[@"userId"]] type:NIMSessionTypeP2P];
//    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:&error];
////    ML_SessionViewController *vc = [ML_SessionViewController new];
////    NIMMessageModel *model = [vc uiDeleteMessage:message];
////    NIMMessage *tip = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevokedTwo:message]];
////    tip.timestamp = model.messageTime;
////    [vc uiInsertMessages:@[tip]];
////    tip.timestamp = message.timestamp;
////    vc = nil;
////    [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
////    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:[NIMSession session:[NSString stringWithFormat:@"%@", _dict[@"userId"]] type:NIMSessionTypeP2P] completion:nil];
//
//    if(error){
//        PNSToast([UIViewController topShowViewController].view, @"发送失败", 1.0);
//        return;
//    }else{
//        if (self.clickcellCityButtonBlock) {
//            self.clickcellCityButtonBlock(self.tag);
//            [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//            [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
//            self.dashanbtn.layer.borderWidth = 0;
//            [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(24);
//                make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
//                make.height.mas_equalTo(24);
//                make.top.mas_equalTo(self.nameLabel.mas_top);
//            }];//
//        }
//    }
    
}


-(void)videoClick{
    if (self.clickCellVideoBlock) {
        self.clickCellVideoBlock(self.tag);
    }
}
//
//- (void)setIsChecked:(BOOL)isChecked{
//    _isChecked = isChecked;
//    //选中
//    if (_isChecked) {
//        self.selectimg.hidden = NO;
//    }
//    else{
//        self.selectimg.hidden = YES;
//    }
//}



@end
