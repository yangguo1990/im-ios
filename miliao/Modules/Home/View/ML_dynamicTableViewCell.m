//
//  ML_dynamicTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_dynamicTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_dynamicTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;
@property (nonatomic,strong)UIButton *videobtn;
@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)UIButton *ssbtn;
@property (nonatomic,strong)NSDictionary *nmdict;
@end


@implementation ML_dynamicTableViewCell

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
        make.width.height.mas_equalTo(self.width - 32);
        make.width.height.mas_equalTo(92);
    }];
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.layer.cornerRadius = self.img.frame.size.width / 2;
    img.layer.masksToBounds = YES;
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bg.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(bg.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
       UILabel *nameLabel = [[UILabel alloc]init];
       nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
       nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
       nameLabel.adjustsFontSizeToFitWidth = YES;
       nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
       [self.contentView addSubview:nameLabel];
       self.nameLabel = nameLabel;
    
    
       UILabel *timeLabel = [[UILabel alloc] init];
       timeLabel.textAlignment = NSTextAlignmentRight;
       timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
       timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
       [self addSubview:timeLabel];
       self.timeLabel = timeLabel;
    
    
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(img.mas_right).mas_offset(16);
//        make.top.mas_equalTo(img.mas_top);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-150);
//    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"黄金"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
//    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(28);
//        make.centerY.mas_equalTo(nameLabel.mas_centerY);
//        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(8);
//    }];

    UIButton *ssbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ssbtn setTitle:@"" forState:UIControlStateNormal];
    ssbtn.layer.backgroundColor = [UIColor colorWithRed:251/255.0 green:66/255.0 blue:64/255.0 alpha:0.1].CGColor;
    [ssbtn setTitleColor:[UIColor colorWithRed:251/255.0 green:66/255.0 blue:64/255.0 alpha:1.0] forState:UIControlStateNormal];
    ssbtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    ssbtn.layer.cornerRadius = 2;
    [self.contentView addSubview:ssbtn];
    self.ssbtn = ssbtn;
//    [ssbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(selectimg.mas_right).mas_offset(6);
//        make.width.mas_equalTo(41);
//        make.height.mas_equalTo(21);
//        make.centerY.mas_equalTo(nameLabel.mas_centerY);
//    }];
   
    UIButton *agebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agebtn setTitle:@"" forState:UIControlStateNormal];
    //[agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
    //agebtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;
    [agebtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    agebtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    agebtn.layer.cornerRadius = 7;
    [self.contentView addSubview:agebtn];
    self.agebtn = agebtn;
//    [agebtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(12);
//        make.left.mas_equalTo(nameLabel.mas_left);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(14);
//    }];
    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
    [self.dashanbtn setTitle:@"" forState:UIControlStateSelected];
    [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
    [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateSelected];
    self.dashanbtn.layer.borderWidth = 0.5;
    self.dashanbtn.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    [self.dashanbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.dashanbtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.dashanbtn.layer.cornerRadius = 16;
    self.dashanbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0, 2);
    self.dashanbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [self.dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dashanbtn];
//    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(65);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
//        make.height.mas_equalTo(32);
//        //make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.top.mas_equalTo(nameLabel.mas_top);
//    }];

    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
    [videobtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videobtn];
    self.videobtn = videobtn;
//    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(24);
//        make.right.mas_equalTo(self.dashanbtn.mas_left).mas_offset(-18);
//        //make.centerY.mas_equalTo(dashanbtn.mas_centerY);
//        make.top.mas_equalTo(20);
//    }];

}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.nmdict = _dict;
    [_img sd_setImageWithURL:kGetUrlPath(dict[@"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    //interval
    if ([dict[@"name"] isEqual:[NSNull null]]) {
        self.nameLabel.text = @"";
        self.nameLabel.frame = CGRectMake(76+16, 16, 10, 22);
        
    }else{
       self.nameLabel.text = dict[@"name"];
//        if (self.nameLabel.text.length > 4) {
//            NSString *str1 = [self.nameLabel.text substringToIndex:4];//截取掉下标5之前的字符串
//            self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
//        }else{
//            self.nameLabel.text = dict[@"name"];
//        }
        
        if (self.nameLabel.text.length > 8) {
            NSString *str1 = [self.nameLabel.text substringToIndex:8];//截取掉下标5之前的字符串
            self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
        }else{
            self.nameLabel.text = dict[@"name"];
        }
        
        CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(100, 22)];
        self.nameLabel.frame = CGRectMake(76+16, 16, size.width, 22);
        
        
    }

    if ([dict[@"age"] isEqual:[NSNull null]]) {
        [self.agebtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.agebtn setTitle:[NSString stringWithFormat:@"%@",dict[@"age"]] forState:UIControlStateNormal];
    }
    
    if ([dict[@"gender"] integerValue] == 0) {//nv
        [self.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
        self.agebtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
    }else{
        [self.agebtn setImage:[UIImage imageNamed:@"icon_nansheng_24_sel-1"] forState:UIControlStateNormal];
        self.agebtn.backgroundColor = [UIColor colorWithRed:175/255.0 green:189/255.0 blue:250/255.0 alpha:1.0];
    }
    self.timeLabel.text = dict[@"interval"];
    
//    //打招呼状态，0-未打招呼 1-已打招呼
//    if ([dict[@"call"] integerValue] == 0) {
//        [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
//    }else{
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
//        self.dashanbtn.layer.borderWidth = 0;
//    }

    if ([_dict[@"call"] integerValue] == 0) {//nv
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
        self.dashanbtn.layer.borderWidth = 0.5;
        self.dashanbtn.selected = NO;
//        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(65);
//            make.height.mas_equalTo(32);
//        }];
        
        self.dashanbtn.frame = CGRectMake(ML_ScreenWidth - 12 - 65-16, self.nameLabel.y, 65, 32);
    }else{
        self.dashanbtn.selected = YES;
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
        self.dashanbtn.layer.borderWidth = 0;
//        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(40);
//            make.height.mas_equalTo(28);
//        }];
        self.dashanbtn.frame = CGRectMake(ML_ScreenWidth - 65-16, self.nameLabel.y, 40, 28);
        
    }
    
    
    self.selectimg.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.y, 28, self.nameLabel.height);
    switch ([dict[@"identity"] integerValue]) {
        case 0:
            
            self.selectimg.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.y, 0, self.nameLabel.height);
            self.selectimg.image = [UIImage imageNamed:nil];
            break;
        case 10:
            self.selectimg.image = [UIImage imageNamed:@"huangjin2_1"];
            break;
        case 20:
            self.selectimg.image = [UIImage imageNamed:@"bojin2_1"];
            break;
        case 30:
            self.selectimg.image = [UIImage imageNamed:@"zuanshi2_1"];
            break;
        default:
            break;
    }
    
    
    
    if ([dict[@"operation"] length]) {
        self.ssbtn.hidden = NO;
        
        [self.ssbtn setTitle:[NSString stringWithFormat:@"%@", dict[@"operation"]] forState:UIControlStateNormal];
        CGSize size2 = [[self.ssbtn currentTitle] sizeWithFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] maxSize:CGSizeMake(130, 22)];
    
        self.ssbtn.frame = CGRectMake(CGRectGetMaxX(self.selectimg.frame) + 6, self.nameLabel.y, size2.width+12, self.nameLabel.height);
    } else {
        
        self.ssbtn.hidden = YES;
    }

    
    
    self.agebtn.frame = CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame) + 12, 30, 14);
    self.videobtn.frame = CGRectMake(self.dashanbtn.x - 18 - 24, 20, 24, 24);
    

}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.timeLabel.frame = CGRectMake(0, 60, self.width - 20, 30);
}

-(void)dashanClick:(UIButton *)btn{
    if (self.clickbuttonBlock) {
        self.clickbuttonBlock(self.tag, btn);
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
//        self.dashanbtn.layer.borderWidth = 0;
//        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(40);
//            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
//            make.height.mas_equalTo(28);
//            make.top.mas_equalTo(self.nameLabel.mas_top);
//        }];
    }

    
//    NIMMessage *message = [[NIMMessage alloc] init];
//    message.text = @"你好，可以认识一下吗？";
//
//    NSError * error = nil;
//    // @"15198698"
//    NIMSession * session = [NIMSession session:[NSString stringWithFormat:@"%@", _dict[@"userId"]] type:NIMSessionTypeP2P];
//    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:&error];
//
//
//    [btn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//    [btn setTitle:@"" forState:UIControlStateNormal];
//    btn.layer.borderWidth = 0;
//
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
//
//        return;
//    }else{
//
//        if (self.clickbuttonBlock) {
//            self.clickbuttonBlock(self.tag);
//            [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//            [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
//            self.dashanbtn.layer.borderWidth = 0;
//            [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(24);
//                make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
//                make.height.mas_equalTo(24);
//                make.top.mas_equalTo(self.nameLabel.mas_top);
//            }];
//        }
//
//
//    }
}

-(void)videoClick{
    if (self.clickCellVideoBlock) {
        self.clickCellVideoBlock(self.tag);
    }
}



//-(void)imgClick{
//    if (self.addToCartsBlock) {
//        self.addToCartsBlock();
//    }
//}
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
