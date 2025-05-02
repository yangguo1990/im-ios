
#import "ML_BillCell.h"

@interface ML_BillCell()
@property (strong, nonatomic) UILabel *t2;
@property (strong, nonatomic) UILabel *t3;
@property (strong, nonatomic) UILabel *t4;
@property (strong, nonatomic) UILabel *t1;
@property (strong, nonatomic) UIImageView *imgV;
@property (strong, nonatomic) UIView *lineV;
@end

@implementation ML_BillCell

+ (instancetype)ML_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ML_BillCell";
    ML_BillCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ML_BillCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageV];
        imageV.layer.cornerRadius = 20;
        imageV.layer.masksToBounds = YES;
        self.imgV = imageV;
        
        
        self.lineV = [[UIImageView alloc] init];
        self.lineV.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self.contentView addSubview:self.lineV];
        

        UILabel *ziTitle0 = [[UILabel alloc] init];
        ziTitle0.textAlignment = NSTextAlignmentLeft;
        ziTitle0.textColor = [UIColor colorWithHexString:@"#333333"];
        ziTitle0.font = kGetFont(16);
        [self.contentView addSubview:ziTitle0];
        self.t1 = ziTitle0;
        
        UILabel *ziTitle2 = [[UILabel alloc] init];
        ziTitle2.textAlignment = NSTextAlignmentLeft;
        ziTitle2.textColor = [UIColor colorWithHexString:@"#666666"];
        ziTitle2.font = kGetFont(14);
        [self.contentView addSubview:ziTitle2];
        self.t2 = ziTitle2;
        
        UILabel *ziTitle3 = [[UILabel alloc] init];
        ziTitle3.textAlignment = NSTextAlignmentRight;
        ziTitle3.textColor = kGetColor(@"ff0000");
        ziTitle3.font = kGetFont(15);
        [self.contentView addSubview:ziTitle3];
        ziTitle0.userInteractionEnabled = YES;
        self.t3 = ziTitle3;
        
        
        UILabel *ziTitle4 = [[UILabel alloc] init];
        ziTitle4.textAlignment = NSTextAlignmentRight;
        ziTitle4.textColor = [UIColor colorWithHexString:@"#0491FF"];
        ziTitle4.font = kGetFont(14);
        [self.contentView addSubview:ziTitle4];
        ziTitle4.userInteractionEnabled = YES;
        self.t4 = ziTitle4;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgV.frame = CGRectMake(16, 20, 40, 40);
    self.t1.frame = CGRectMake(72, 20, 200, 20);
    self.t2.frame = CGRectMake(72, 40, 200, 20);
    self.lineV.frame = CGRectMake(72, 79, ML_ScreenWidth, 1);
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    
    self.t4.hidden = YES;
    self.t3.frame = CGRectMake(ML_ScreenWidth - 216, 20, 200, 40);
    if (self.type == 0) {
        
            self.t1.text = [NSString stringWithFormat:@"%@", dic[@"desc"]];
            self.t2.text = [NSString stringWithFormat:@"%@", dic[@"createTime"]];
            self.t3.text = [NSString stringWithFormat:@"+%@%@", dic[@"coin"],Localized(@"金币", nil)];
        if ([dic[@"payWay"] intValue] == 0) {
            self.imgV.image = kGetImage(@"icon_weixin_40_nor");
        } else if ([dic[@"payWay"] intValue] == 1) {
            self.imgV.image = kGetImage(@"icon_zhifubao_40_nor");
        } else if ([dic[@"payWay"] intValue] == 2)  {
            self.imgV.image = kGetImage(@"icon_pingguo_40_nor");
        } else {
            self.imgV.image = kGetImage(@"bank_card");
        }
        
    } else if (self.type == 1) {
        
        self.t1.text = [NSString stringWithFormat:@"%@", dic[@"desc"]];
        self.t2.text = [NSString stringWithFormat:@"%@", dic[@"createTime"]];
        self.t3.text = [NSString stringWithFormat:@"-%@%@", dic[@"coin"],Localized(@"金币", nil)];
        
        [self.imgV sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
        
    } else if (self.type == 2) {
        

        self.t3.hidden = NO;
        self.t4.hidden = NO;
        self.t3.frame = CGRectMake(ML_ScreenWidth - 216, 20, 200, 20);
        self.t4.frame = CGRectMake(ML_ScreenWidth - 216, 40, 200, 20);
        self.t2.text = [NSString stringWithFormat:@"ID:%@", dic[@"userId"]];
        self.t1.text = [NSString stringWithFormat:@"%@", dic[@"desc1"]];
        self.t3.text = [NSString stringWithFormat:@"%@积分", dic[@"credit"]];
        self.t4.text = [NSString stringWithFormat:@"%@", dic[@"createTime"]];
//
        [self.imgV sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
        
    } else {
        
        self.t4.hidden = NO;
        self.t3.frame = CGRectMake(ML_ScreenWidth - 216, 20, 200, 20);
        self.t4.frame = CGRectMake(ML_ScreenWidth - 216, 40, 200, 20);
        
//        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
            
            self.t1.text = [NSString stringWithFormat:@"%@", dic[@"desc"]];
            self.t2.text = [NSString stringWithFormat:@"%@", dic[@"createTime"]];
            self.t3.text = [NSString stringWithFormat:@"+%@", dic[@"amount"]];
            self.t3.hidden = NO;
            NSString *status = Localized(@"审核中", nil);
            if([dic[@"status"] intValue] == 1) {
                status = Localized(@"已通过", nil);
            } else if([dic[@"status"] intValue] == 2) {
                status = Localized(@"已驳回", nil);
            } else {
                self.t3.hidden = YES;
            }
            self.t4.text = status;
            [self.imgV sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
            
        
    }
        
}

@end
