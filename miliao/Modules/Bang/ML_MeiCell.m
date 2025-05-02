

#import "ML_MeiCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>



#import "ML_sayHelloApi.h"
@interface ML_MeiCell()

@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *cityView;
@property (nonatomic,strong)UILabel *adrrnameLabel;


@property (nonatomic,strong)UIImageView *hostimg;
@end


@implementation ML_MeiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setCell];
    }
    return self;
}

- (void)imageViewAddTap:(UIGestureRecognizer *)gr
{
    [self gotoInfoVC:[NSString stringWithFormat:@"%@", _dict[@"userId"]]];
}

-(void)setCell{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*mWidthScale);
        make.right.mas_equalTo(-10*mWidthScale);
        make.top.mas_equalTo(10*mHeightScale);
        make.bottom.mas_equalTo(-10*mHeightScale);
    }];
    self.backView = backView;
    backView.layer.cornerRadius = 16*mWidthScale;
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    numLabel.textColor = [UIColor colorWithHexString:@"#aaa6ae"];
    [self.contentView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(20*mWidthScale);
        make.width.height.mas_equalTo(24*mWidthScale);
    }];
    self.numLabel = numLabel;
    
    UIImageView *img = [[UIImageView alloc]init];
    [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAddTap:)]];
    img.layer.cornerRadius = 16;
    img.layer.masksToBounds = YES;
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(20*mWidthScale);
        make.width.height.mas_equalTo(24*mWidthScale);
    }];
  
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(80*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];

    UILabel *tnameLabel = [[UILabel alloc]init];
    tnameLabel.textAlignment = NSTextAlignmentCenter;
    tnameLabel.layer.cornerRadius = 4;
    tnameLabel.layer.masksToBounds = YES;
    tnameLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightMedium];
    [self.contentView addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom);
    }];
    
    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.dashanbtn setImage:kGetImage(@"list_button_not_received") forState:UIControlStateNormal];
    [self.dashanbtn setImage:kGetImage(@"list_button_has_been_received") forState:UIControlStateSelected];

    [self.dashanbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dashanbtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    self.dashanbtn.layer.cornerRadius = 8;

    [self.dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top);
        make.right.mas_equalTo(backView.mas_right);
        make.width.mas_equalTo(46*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    self.cityView = [[UILabel alloc] init];

    self.cityView.textAlignment = NSTextAlignmentRight;
    self.cityView.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    self.cityView.textColor = [UIColor colorWithHexString:@"#000000"];
    [self.contentView addSubview:self.cityView];
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(200*mWidthScale);
    }];
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.dashanbtn.userInteractionEnabled = [[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId integerValue] == [dict[@"userId"] integerValue];
    
    self.numLabel.text = [NSString stringWithFormat:@"%02ld", self.tag + 1];
    self.numLabel.frame = CGRectMake(0, 0, 40, 55);
    
//    self.cityView.text = nil;
//    if ([dict[@"any_value"][@"province"] length] && ![dict[@"any_value"][@"province"] isEqual:[NSNull null]]) {
//
//        self.cityView.text = [NSString stringWithFormat:@"城市：%@", dict[@"any_value"][@"province"]];
//    }
//    [_img sd_setImageWithURL:kGetUrlPath(dict[@"icon"])];

    self.nameLabel.text = dict[@"name"];
//     CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(110, 22)];
//     self.nameLabel.frame = CGRectMake(90, 9, size.width, 22);

    if ([dict[@"online"] intValue] == 1) {
        self.tnameLabel.text = @"•勿扰";
        self.tnameLabel.backgroundColor = [UIColor colorWithHexString:@"#ADADAD" alpha:0.2];
        self.tnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    }else if ([dict[@"online"] intValue] == 2) {
        self.tnameLabel.text = @"•在聊";
        self.tnameLabel.backgroundColor = [UIColor colorWithHexString:@"#22D12A" alpha:0.2];
        self.tnameLabel.textColor = [UIColor colorFromHexString:@"#00C013"];
    }else if ([dict[@"online"] intValue] == 3) {
        self.tnameLabel.text = @"•在线";
        self.tnameLabel.backgroundColor = [UIColor colorWithHexString:@"#22D12A" alpha:0.2];
        self.tnameLabel.textColor = [UIColor colorFromHexString:@"#00C013"];
    }else {
        self.tnameLabel.backgroundColor = [UIColor colorWithHexString:@"#ADADAD" alpha:0.2];
        self.tnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        self.tnameLabel.text = @"•离线";
    };
//    self.tnameLabel.frame = CGRectMake(self.nameLabel.x, self.nameLabel.height + 12, 33, 12);
    
    self.dashanbtn.selected = ![dict[@"status"] boolValue];
   
    self.dashanbtn.hidden = !(self.way == 1);

    if (self.way == 1){
        self.cityView.text = [NSString stringWithFormat:@"%@%@元", Localized(@"奖励：", nil), dict[@"reward"]?:@""];
    } else {
        self.cityView.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"距上名差：", nil), dict[@"distance"]?:@"", Localized(@"积分", nil)];
    }
    
    if (self.way == 4) {
//        if (self.type != 3){
            
            self.cityView.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"邀请首充：", nil), dict[@"num"]?:@"", Localized(@"人", nil)];
//        }
    }
    
    self.cityView.frame = CGRectMake(ML_ScreenWidth - 150, self.nameLabel.y, 130, 14);

    self.img.userInteractionEnabled = (self.way == 1);
}

-(void)dashanClick:(UIButton *)btn{
    
    
    
     if (self.clickcellCityButtonBlock && !self.dashanbtn.selected) {
         
         
         if ([_dict[@"userId"] intValue] != [ML_AppUserInfoManager.sharedManager.currentLoginUserData.userId intValue]) {
             
             return;
         }
         
         ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"id" : _dict[@"id"]} urlStr:@"top/receiveReward"];
          kSelf;
          [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

              weakself.clickcellCityButtonBlock(weakself.dict);
             
         } error:^(MLNetworkResponse *response) {
             
             
         } failure:^(NSError *error) {
             
             
         }];
         
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
