
#import "ML_tongjiCell.h"

@interface ML_tongjiCell()
@property (strong, nonatomic)UIButton *btntong;
@property (strong, nonatomic)UILabel *label1;
@property (strong, nonatomic)UILabel *label2;

@end

@implementation ML_tongjiCell

+ (instancetype)ML_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ML_tongjiCell";
    ML_tongjiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ML_tongjiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *bgView = [[UIButton alloc] init];
        [bgView setImage:[UIImage imageNamed:@"icon_total_points"] forState:UIControlStateNormal];;
        [self.contentView addSubview:bgView];
        self.btntong = bgView;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"总积分"attributes: @{NSFontAttributeName: [UIFont systemFontOfSize: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.alpha = 1.0;
        self.label1 = label;

        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(26,206,83,29);
        label2.numberOfLines = 0;
        [self.contentView addSubview:label2];

        label2.font = [UIFont systemFontOfSize:24];
        label2.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.alpha = 1.0;
        self.label2 = label2;
        
        NSArray *arr2 = @[@"注册数",@"充值金额（元）",@"充值分成（积分）",@"VIP充值分成...",@"活动奖励分成...",@"邀请注册分成...",@"其他（积分）" ];
        NSArray *arr = @[@"number_of_icons",@"icon_amount",@"icon_recharge",@"icon_vip",@"icon_activity",@"icon_invitation",@"icon_other" ];
        
        for (int i = 0; i< arr.count; i++) {
            
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.tag = 10+i;
            imageV.image = [UIImage imageNamed:arr[i]];
    //        imageV.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageV];
            
            
            UILabel *ziTitle0 = [[UILabel alloc] init];
            ziTitle0.tag = 20+i;
            ziTitle0.textAlignment = NSTextAlignmentLeft;
            ziTitle0.text = arr2[i];
            ziTitle0.textColor = [UIColor colorWithHexString:@"#666666"];
            ziTitle0.font = kGetFont(12);
            [imageV addSubview:ziTitle0];
            
            
            UILabel *ziTitle1 = [[UILabel alloc] init];
            ziTitle1.tag = imageV.tag;
            ziTitle1.textAlignment = NSTextAlignmentLeft;
            ziTitle1.text = arr2[i];
            ziTitle1.textColor = [UIColor colorWithHexString:@"#000000"];
            ziTitle1.font = kGetFont(20);
            [imageV addSubview:ziTitle1];
            
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat H = ML_ScreenWidth * 88/347;
    self.btntong.frame = CGRectMake(0, 0, ML_ScreenWidth, H);
    self.label1.frame = CGRectMake(26, self.btntong.height / 2 - 9, 160, 17);
    self.label2.frame = CGRectMake(self.label1.x, CGRectGetMaxY(self.label1.frame), 160, 30);
    
    
    int i = 0;
    CGFloat W2 = (ML_ScreenWidth - 48) / 3;
    CGFloat H2 = W2 * 88/W2;
    for (UIImageView *imgV in self.contentView.subviews) {
        if (imgV.tag-10 == i && imgV.tag>0) {
            int col = i % 3;
            int row = i / 3;
            imgV.frame = CGRectMake(14 + col * (10 + W2), self.btntong.height + row * (H+10), W2, H2);
            
            for (UILabel *la in imgV.subviews) {
                if (la.tag == imgV.tag && [la isKindOfClass:[UILabel class]]) {
                    
                    la.frame = CGRectMake(8, 57, imgV.width - 8, 24);
                   
                } else if ((la.tag -20) == (imgV.tag-10) && [la isKindOfClass:[UILabel class]]) {
                    
                    la.frame = CGRectMake(8, 36, imgV.width - 8, 17);
                }
            }
            
            i++;
                
        }
    }
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    self.label2.text = [NSString stringWithFormat:@"%@", dic[@"totalCredit"]?:@"0"];
    for (UIImageView *imgV in self.contentView.subviews) {

        for (UILabel *la in imgV.subviews) {
            if (la.tag == imgV.tag && la.tag > 0 && [la isKindOfClass:[UILabel class]]) {
                
                if (la.tag == 10) {
                    
                    la.text = [NSString stringWithFormat:@"%@", dic[@"registerNum"]?:@"0"];
                } else if (la.tag == 11) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"rechargeAmount"]?:@"0"];

                } else if (la.tag == 12) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"rechargeCredit"]?:@"0"];

                } else if (la.tag == 13) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"vipRechargeCredit"]?:@"0"];

                } else if (la.tag == 14) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"activityCredit"]?:@"0"];

                } else if (la.tag == 15) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"inviteCredit"]?:@"0"];

                } else if (la.tag == 16) {
                    la.text = [NSString stringWithFormat:@"%@", dic[@"otherCredit"]?:@"0"];
                }
                break;
            }
        }
  
    }
        
}

@end
