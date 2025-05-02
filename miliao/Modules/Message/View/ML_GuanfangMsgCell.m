
#import "ML_GuanfangMsgCell.h"
#import "ML_CommunityModel.h"
#import "ExpandLabel.h"
#import "ML_PictureCell.h"
#import "UIView+ML.h"
#import "NTESSessionUtil.h"
#import "UIButton+ML.h"

@interface ML_GuanfangMsgCell()<UICollectionViewDelegate, UICollectionViewDataSource, ExpandLabelDelegate>

@property (strong, nonatomic) UILabel *timeV;
@property (strong, nonatomic) UILabel *ML_Name;
@property (strong, nonatomic) UILabel *contentTextView;
@property (strong, nonatomic) UIView *bgV;
@property (strong, nonatomic) UIButton *chaBtn;
@end

@implementation ML_GuanfangMsgCell

+ (instancetype)ML_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ML_GuanfangMsgCell";
    ML_GuanfangMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ML_GuanfangMsgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgV = [[UIView alloc] init];
        self.bgV.layer.cornerRadius = 10;
        self.bgV.layer.masksToBounds = YES;
        self.bgV.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.contentView addSubview:self.bgV];
        
        self.ML_Name = [[UILabel alloc] init];
        self.ML_Name.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.ML_Name setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        self.ML_Name.textAlignment = NSTextAlignmentLeft;
        self.ML_Name.numberOfLines = 1;
        [self.bgV addSubview:self.ML_Name];
        
        
        self.timeV = [[UILabel alloc] init];
        self.timeV.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.timeV setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
        self.timeV.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeV];
        
        
        self.contentTextView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth - 24, 0)];
        self.contentTextView.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        self.contentTextView.textColor = [UIColor colorWithHexString:@"#666666"];
        self.contentTextView.textAlignment = NSTextAlignmentLeft;
        self.contentTextView.numberOfLines = 0;
        [self.bgV addSubview:self.contentTextView];

        
        UIButton *chaBtn = [UIButton new];
        chaBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [chaBtn setTitle:Localized(@"查看详情", nil) forState:UIControlStateNormal];
        [chaBtn setTitle:Localized(@"收起详情", nil) forState:UIControlStateSelected];
        [chaBtn setImage:kGetImage(@"icon_jinru_101_nor") forState:UIControlStateSelected];
        [chaBtn setImage:kGetImage(@"icon_jinru_10_nor") forState:UIControlStateNormal];
        [chaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chaBtn addTarget:self action:@selector(chaBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgV addSubview:chaBtn];
        self.chaBtn = chaBtn;
    }
    return self;
}

- (void)chaBtnClick
{
    if (self.RefreshContenBlock) {
        self.chaBtn.selected = !self.chaBtn.selected;
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:_ML_Model];
        [muDic setValue:@(self.chaBtn.selected) forKey:@"isZhan"];
        self.RefreshContenBlock(muDic);
    }
}

- (void)setML_Model:(NSDictionary *)ML_Model
{
    _ML_Model = ML_Model;
    
    self.isZhan = [ML_Model[@"isZhan"] boolValue];
    self.chaBtn.selected = self.isZhan;
    
    self.timeV.text = [NTESSessionUtil showTime:[ML_Model[@"createTime"] longLongValue] / 1000 showDetail:YES];
    self.timeV.frame = CGRectMake(0, 0, ML_ScreenWidth, 54);
    
    self.ML_Name.text = ML_Model[@"title"];
    self.ML_Name.frame = CGRectMake(12, 12, ML_ScreenWidth - 24 * 2, 20);
    
    self.contentTextView.text = ML_Model[@"content"]?:@"";
    CGSize size = [ML_Model[@"content"]?:@"" sizeWithFont:self.contentTextView.font maxSize:CGSizeMake(self.ML_Name.width, 80)];
    CGSize size2 = [ML_Model[@"content"]?:@"" sizeWithFont:self.contentTextView.font maxSize:CGSizeMake(self.ML_Name.width, MAXFLOAT)];

    
    if (size2.height > size.height) {
        self.chaBtn.hidden = NO;

        if (self.isZhan) {
            
            self.contentTextView.frame = CGRectMake(12, CGRectGetMaxY(self.ML_Name.frame) + 12, size2.width, size2.height);
        } else {
            self.contentTextView.frame = CGRectMake(12, CGRectGetMaxY(self.ML_Name.frame) + 12, size.width, size.height);
        }

        self.chaBtn.frame = CGRectMake(self.ML_Name.width - 80, CGRectGetMaxY(self.contentTextView.frame) + 5, 100, 30);
        [self.chaBtn setIconInRightWithSpacing:5];
        self.bgV.frame = CGRectMake(10, 54, ML_ScreenWidth - 20, CGRectGetMaxY(self.chaBtn.frame)+ 15);
        
    } else {
        
        self.contentTextView.frame = CGRectMake(12, CGRectGetMaxY(self.ML_Name.frame) + 12, size.width, size.height);

        self.chaBtn.frame = CGRectMake(self.ML_Name.width - 80, CGRectGetMaxY(self.contentTextView.frame) + 5, 100, 30);
        
        self.chaBtn.hidden = YES;
        self.bgV.frame = CGRectMake(10, 54, ML_ScreenWidth - 20, CGRectGetMaxY(self.contentTextView.frame)+ 15);
    }
    
    self.cellHeight = CGRectGetMaxY(self.bgV.frame);
    
}


@end
