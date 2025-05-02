//
//  MLHomefocuslistTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/15.
//

#import "MLHomefocuslistTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
#import "ML_sayHelloApi.h"

@interface MLHomefocuslistTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)UIImageView *hostimg;


@property (nonatomic,strong)UIImageView *onlineimg;

@end


@implementation MLHomefocuslistTableViewCell

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
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.layer.masksToBounds = YES;
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bg.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(bg.mas_centerY);
        make.width.height.mas_equalTo(70);
    }];
    [img layoutIfNeeded];
    
    UIImageView *onlineImg = [[UIImageView alloc]init];
    [self.contentView addSubview:onlineImg];
    self.onlineimg = onlineImg;
    [onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.bottom.mas_equalTo(self.img.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(img.mas_right).mas_offset(16);
//        make.top.mas_equalTo(img.mas_top);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-170);
//    }];
    
    UIImageView *hostimg = [[UIImageView alloc]init];
    hostimg.contentMode = UIViewContentModeScaleAspectFit;
    hostimg.image = [UIImage imageNamed:@"Groupzhenren"];
    [self.contentView addSubview:hostimg];
    self.hostimg = hostimg;
//    [hostimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(41.5);
//        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(5);
//        make.centerY.mas_equalTo(nameLabel.mas_centerY);
//    }];
    
    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setTitle:Localized(@"搭讪",nil) forState:UIControlStateNormal];
    [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
    
    [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateSelected];
    [self.dashanbtn setTitle:@"" forState:UIControlStateSelected];
    
    self.dashanbtn.layer.borderWidth = 0.5;
    self.dashanbtn.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    [self.dashanbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.dashanbtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.dashanbtn.layer.cornerRadius = 16;
    self.dashanbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0, 2);
    self.dashanbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [self.dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-12);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(img.mas_top);
        //make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
    [videobtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videobtn];
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(self.dashanbtn.mas_left).mas_offset(-18);
        make.top.mas_equalTo(10);
    }];
    
    UILabel *tnameLabel = [[UILabel alloc]init];
//    tnameLabel.text = @"有点小内向但是熟了...";
    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [self.contentView addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(102);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.top.mas_equalTo(63);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-150);
    }];
    
    UIView *lineview = [[UIView alloc]init];
    lineview.hidden = YES;
    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(76);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
//    UILabel *adrrnameLabel = [[UILabel alloc]init];
//    adrrnameLabel.text = @"10km";
//    adrrnameLabel.textAlignment = NSTextAlignmentCenter;
//    adrrnameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
//    adrrnameLabel.textColor = [UIColor colorFromHexString:@"#FF666666"];
//    [self.contentView addSubview:adrrnameLabel];
//    self.adrrnameLabel = adrrnameLabel;
//    [adrrnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(agebtn.mas_right).mas_offset(6);
//        make.centerY.mas_equalTo(agebtn.mas_centerY);
//    }];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    [_img sd_setImageWithURL:kGetUrlPath(dict[@"icon"]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    
    if ([dict[@"online"] integerValue] == 1) {
        self.onlineimg.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([dict[@"online"] integerValue] == 2){
        self.onlineimg.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([dict[@"online"] integerValue] == 3){
        self.onlineimg.image = kGetImage(@"label_online");
    } else {
        self.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
    }
    

    if (![dict[@"name"] length]) {
        self.nameLabel.text = @"";
    }else{
       self.nameLabel.text = dict[@"name"];
        if (self.nameLabel.text.length > 8) {
            NSString *str1 = [self.nameLabel.text substringToIndex:8];//截取掉下标5之前的字符串
            self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
        }else{
            self.nameLabel.text = dict[@"name"];
        }
        
        CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(100, 22)];
        self.nameLabel.frame = CGRectMake(76+16+10, 10, size.width, 22);
        self.hostimg.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.y, 41.5, self.nameLabel.height);
    }
    
    
    if (![dict[@"persionSign"] length]) {
        self.tnameLabel.text = @"";
    }else{
        self.tnameLabel.text = dict[@"persionSign"];
    };

    [self.agebtn setTitle:[NSString stringWithFormat:@"%@",dict[@"age"]] forState:UIControlStateNormal];
    
    if ([_dict[@"host"] integerValue] == 0) {
        self.hostimg.hidden = YES;
    }else{
        self.hostimg.hidden = NO;
    }
    
    if ([dict[@"call"] integerValue] == 0) {//nv
        self.dashanbtn.selected = NO;
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"搭讪" forState:UIControlStateNormal];
        self.dashanbtn.layer.borderWidth = 0.5;
        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(32);
        }];
        
    }else{
//        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
//        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
        self.dashanbtn.selected = YES;
        self.dashanbtn.layer.borderWidth = 0;
        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(28);
        }];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.img.layer.cornerRadius = self.img.frame.size.width / 2;
    self.img.layer.masksToBounds = YES;
    [self.img layoutIfNeeded];
}


-(void)dashanClick:(UIButton *)btn{

    if (btn.selected) {
        [self gotoChatVC:[NSString stringWithFormat:@"%@", _dict[@"userId"]]];
    } else {
        [SVProgressHUD show];
        kSelf;
        NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
        ML_sayHelloApi *api = [[ML_sayHelloApi alloc]initWithtoken:token toUserId:_dict[@"userId"] extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"打招呼%@",response.data);
            kplaceToast(@"打招呼成功,可以给好友私信啦");
            [SVProgressHUD dismiss];
            if (weakself.clickbuttonBlock) {
                weakself.clickbuttonBlock(self.tag);
                weakself.dashanbtn.selected = YES;
                weakself.dashanbtn.layer.borderWidth = 0;
                [weakself.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(40);
                    make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
                    make.height.mas_equalTo(28);
                    make.top.mas_equalTo(self.nameLabel.mas_top);
                }];
            }
            
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
        
    }
    
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
