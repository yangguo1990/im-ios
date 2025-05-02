//
//  ML_HostMessageTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/5.
//

#import "ML_HostMessageTableViewCell.h"
#import <Masonry.h>
#import <Colours/Colours.h>

@interface ML_HostMessageTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *messsage;
@property (nonatomic,strong) UICollectionViewFlowLayout *myLayout;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)UIView *liveV2;

@end


@implementation ML_HostMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupui];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tnameLabel.frame = CGRectMake(16, 12, 200, 40);
}

- (void)setFrame:(CGRect)frame {
    frame.size.height += 10;
    [super setFrame:frame];
}


-(void)setupui{
    
    UILabel *tnameLabel = [[UILabel alloc]init];
    tnameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    tnameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:tnameLabel];
//    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(16);
//    }];
    self.tnameLabel = tnameLabel;
    UIButton *bb = [UIButton buttonWithType:UIButtonTypeCustom];
    [bb setTitle:@"礼物已经备好，就是还没有遇到心仪的主播" forState:UIControlStateNormal];
    [bb setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
    bb.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    bb.layer.cornerRadius = 22;
    bb.layer.masksToBounds = YES;
    bb.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:bb];
    [bb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tnameLabel.mas_left);
        make.top.mas_equalTo(tnameLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-30);
    }];
    self.bb = bb;
    
//        self.myLayout = [[UICollectionViewFlowLayout alloc]init];
//        self.myLayout.minimumLineSpacing = 50;
//        self.myLayout.minimumInteritemSpacing = 1;
//        self.myLayout.itemSize = CGSizeMake(100,100);
//        self.myLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
//
//        self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.myLayout];
//        self.myCollectionView.delegate = self;
//        self.myCollectionView.dataSource = self;
//        self.myCollectionView.backgroundColor = [UIColor clearColor];
//    //    注册cell
//    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LeftCell"];
//    [self.contentView addSubview:self.myCollectionView];
//
//    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.messsage.mas_left);
//        make.top.mas_equalTo(self.messsage.mas_bottom).mas_offset(10);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
//    }];

        UIView *liveV2 = [[UIView alloc] init];
        liveV2.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [self.contentView addSubview:liveV2];
        self.liveV2 = liveV2;
}



- (void)setListArr:(NSArray *)listArr
{
    _listArr = listArr;
    if (!listArr.count) return;
    
    self.bb.hidden = listArr.count;
    
    for (UIView *view in self.subviews) {
        if (view.tag > 99) {
            [view removeFromSuperview];
        }
    }
    
    self.cellHeight = 110;
    
    CGFloat rowJianju = 9;
    CGFloat btnH = 96;
    CGFloat btnW = (ML_ScreenWidth - 32 - 3 * rowJianju) / 4;
    for (int i = 0; i <  self.listArr.count; i++) {
        NSDictionary *dic = self.listArr[i];
        
        int row = i / 4;
        int col = i % 4;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16 + (btnW + rowJianju) * col, 64 + (btnH + rowJianju) * row, btnW, btnH)];
        btn.tag = i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        btn.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self addSubview:btn];
        btn.tag = 100 + i;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, btn.width, 55)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
//        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [imageV sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
        [btn addSubview:imageV];
        
        UILabel *ziTitle0 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageV.frame), btnW - 10, 20)];
        ziTitle0.textAlignment = NSTextAlignmentCenter;
        ziTitle0.text = dic[@"name"];
        ziTitle0.textColor = [UIColor colorWithHexString:@"#333333"];
        ziTitle0.font = kGetFont(11);
        [btn addSubview:ziTitle0];
        
        UILabel *ziTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(ziTitle0.frame)-2, btnW - 10, 15)];
        ziTitle1.textAlignment = NSTextAlignmentCenter;
        ziTitle1.text = [NSString stringWithFormat:@"x%@", dic[@"num"]];
        ziTitle1.textColor = [UIColor colorWithHexString:@"#999999"];
        ziTitle1.font = kGetFont(11);
        [btn addSubview:ziTitle1];
        
        if (i == listArr.count -1) {
            self.cellHeight = CGRectGetMaxY(btn.frame);
        }
    }
//    self.liveV2.frame = CGRectMake(16, self.cellHeight + 11, ML_ScreenWidth - 32, 1);

}

//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//     return 9;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeftCell" forIndexPath:indexPath];
//            cell.backgroundColor = [UIColor redColor];
//    return cell;
//}


@end
