//
//  ML_chongPayView.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import "ML_chongPayView.h"
#import "ML_chongPayViewCollectionViewCell.h"
#import "ML_TixianWayCollectionViewCell.h"

@interface ML_chongPayView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger type;
@end

@implementation ML_chongPayView

+ (void)showWithPaylist:(NSArray*)payList payCallBack:(void(^)(NSInteger payWay))callback type:(NSInteger)type zmaliinfo:(ZMAliInfos*)aliinfo{
    ML_chongPayView *payView = [[ML_chongPayView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight) type:type];
    payView.payCallBack = callback;
    payView.paylist = payList;
    payView.aliInfo = aliinfo;
    [[UIApplication sharedApplication].keyWindow addSubview:payView];
    [payView.collectionView reloadData];
}


- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:bottomView];
        if (type == 0) {
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(236*mHeightScale);
                make.bottom.mas_equalTo(16*mHeightScale);
            }];
        }else{
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(328*mHeightScale);
                make.bottom.mas_equalTo(16*mHeightScale);
            }];
        }
        
        bottomView.backgroundColor = kGetColor(@"ffffff");
        bottomView.layer.cornerRadius = 16*mWidthScale;
        bottomView.layer.masksToBounds = YES;
        self.index = 0;
        self.type = type;
        UILabel *slognameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0 , 200,48)];
        if (type == 0) {
            slognameLabel.text = @"选择充值方式";
        }else{
            slognameLabel.text = @"选择提现方式";
        }
        
        slognameLabel.font = [UIFont boldSystemFontOfSize:16];
        slognameLabel.textColor = kGetColor(@"000000");
        [bottomView addSubview:slognameLabel];
       
 
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 20*mWidthScale;
        layout.sectionInset = UIEdgeInsetsMake(0, 16*mWidthScale, 0, 16*mWidthScale);
        if (!type) {
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [bottomView addSubview:self.collectionView];
        if (type == 0) {
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(slognameLabel.mas_bottom).offset(10*mHeightScale);
                make.height.mas_equalTo(68*mHeightScale);
            }];
        }else{
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(slognameLabel.mas_bottom).offset(10*mHeightScale);
                make.height.mas_equalTo(136*mHeightScale);
            }];
        }
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        if (type==0) {
            [self.collectionView registerClass:[ML_chongPayViewCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        }else{
            [self.collectionView registerClass:[ML_TixianWayCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        }
       
        
        UIButton * payBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [bottomView addSubview:payBt];
        [payBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16*mWidthScale);
            make.right.mas_equalTo(-16*mWidthScale);
            make.bottom.mas_equalTo(-40*mHeightScale);
            make.height.mas_equalTo(48*mHeightScale);
        }];
        [payBt setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
        if (type == 0) {
            [payBt setTitle:@"立即支付" forState:UIControlStateNormal];
        }else{
            [payBt setTitle:@"立即提现" forState:UIControlStateNormal];
        }
       
        [payBt setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
        payBt.titleLabel.font = [UIFont systemFontOfSize:16];
        [payBt addTarget:self action:@selector(payBtClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)payBtClick:(UIButton *)sender{
    NSDictionary *data = self.paylist[self.index];
    NSInteger payway = [data[@"payWay"] integerValue];
    self.payCallBack(payway);
    [self removeFromSuperview];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == 0) {
        return self.paylist.count;
    }else{
        return 1;
    }
   
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        ML_chongPayViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.dataDic = self.paylist[indexPath.row];
        cell.isSelected = (self.index == indexPath.row);
        return cell;
    }else{
        ML_TixianWayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.payView = self;
        if (self.index == indexPath.row) {
            cell.selectIV.image = kGetImage(@"icon_select_sel");
        }else{
            cell.selectIV.image = kGetImage(@"icon_select_nor");
        }
        if (indexPath.row == 0) {
            cell.withDrawIcon.image = kGetImage(@"icon_zhifubao_26_nor");
            cell.withDrawName.text = @"提现到支付宝账户";
            cell.type = 1;
            if (self.aliInfo.aliPayNo.length) {
                cell.bindBT.hidden = YES;
                cell.withDrawinfo.text = [NSString stringWithFormat:@"已绑定:%@",self.aliInfo.aliPayName];
            }else{
                cell.bindBT.hidden = NO;
                cell.withDrawinfo.text = @"请绑定已实名的支付宝";
            }
        }else{
            cell.withDrawIcon.image = kGetImage(@"icon_weixin_26_nor");
            cell.withDrawName.text = @"提现到微信";
            cell.type = 2;
            if (self.aliInfo.aliPayNo.length) {
                cell.bindBT.hidden = YES;
                cell.withDrawinfo.text = [NSString stringWithFormat:@"已绑定:%@",self.aliInfo.banUserName];
            }else{
                cell.bindBT.hidden = NO;
                cell.withDrawinfo.text = @"请绑定已实名的微信";
            }
        }
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

        self.index = indexPath.row;
        [collectionView reloadData];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        return CGSizeMake(164*mWidthScale, 56*mHeightScale);
    }else{
        return CGSizeMake(343*mWidthScale, 48*mHeightScale);
    }
    
}

@end
