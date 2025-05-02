
#import "ML_DuibiCell.h"
#import "ML_TanchuangView.h"

@interface ML_DuibiCell()
@property (strong, nonatomic) UILabel *t2;
@property (strong, nonatomic) UILabel *t1;
@property (strong, nonatomic) UIView *lineV;
@property (strong, nonatomic) UIView *bgV;
@end

@implementation ML_DuibiCell

+ (instancetype)ML_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ML_DuibiCell";
    ML_DuibiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ML_DuibiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = kGetFont(16);
        self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];

//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIView *view = [[UIView alloc] init];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0].CGColor;
        view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        view.layer.cornerRadius = 8;
        self.bgV = view;
        [self.contentView addSubview:view];
        
        
        UILabel *ziTitle0 = [[UILabel alloc] init];
        ziTitle0.textAlignment = NSTextAlignmentCenter;
        ziTitle0.textColor = [UIColor colorWithHexString:@"#FE005B"];
        ziTitle0.backgroundColor = [UIColor colorWithHexString:@"#FFE8E2" alpha:1];
        ziTitle0.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        ziTitle0.layer.cornerRadius = 12;
        ziTitle0.layer.masksToBounds = YES;
        [self.contentView addSubview:ziTitle0];
        ziTitle0.userInteractionEnabled = YES;
        [ziTitle0 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ziTitle0Tap:)]];
        
        self.t2 = ziTitle0;
        
        UILabel *t1 = [[UILabel alloc] init];
        t1.textAlignment = NSTextAlignmentLeft;
        t1.textColor = [UIColor colorWithHexString:@"#333333"];
        t1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.contentView addSubview:t1];
        self.t1 = t1;
        
        
        UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
//        [self.contentView addSubview:lineview];
        self.lineV = lineview;
    }
    return self;
}

- (void)ziTitle0Tap:(UIGestureRecognizer *)gr
{
    
    ML_TanchuangView *tanV = [ML_TanchuangView shareInstance];
    tanV.dic = @{@"type" : @(ML_TanchuangViewType_Duihuan), @"data" : _dic};
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(30, 13, 30, 30);
    self.bgV.frame = CGRectMake(16,0,ML_ScreenWidth-32,56);
    self.t2.frame = CGRectMake(ML_ScreenWidth - 130, 16, 100, 24);
    self.t1.frame = CGRectMake(70, 0, 200, 56);
    self.lineV.frame = CGRectMake(68, self.height - 1, ML_ScreenWidth, 1);
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.imageView.image = kGetImage(@"icon_jinbi_17_nor");
    self.t2.text = [NSString stringWithFormat:@"%@积分", dic[@"credit"]];
    self.t1.text = [NSString stringWithFormat:@"兑换%@金币", dic[@"coin"]];
}

@end
