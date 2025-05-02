
#import "ML_CommunityCell.h"
#import "ML_CommunityModel.h"


@interface ML_CommunityCell()<UICollectionViewDelegate, UICollectionViewDataSource, ExpandLabelDelegate>


@end

@implementation ML_CommunityCell

+ (instancetype)ML_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ML_CommunityCell";
    ML_CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ML_CommunityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
        backView.layer.cornerRadius = 16*mWidthScale;
        backView.layer.borderColor = kGetColor(@"ffe0ee").CGColor;
        backView.layer.borderWidth = 1;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
//        backView.backgroundColor = UIColor.systemPinkColor;
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10*mWidthScale);
            make.right.mas_equalTo(-10*mWidthScale);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-15*mHeightScale);
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 355*mWidthScale, 218*mHeightScale);
        gradientLayer.colors = @[(id)kGetColor(@"ffdced").CGColor, (id)kGetColor(@"ffffff").CGColor];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 0.5);
        [backView.layer addSublayer:gradientLayer];
        self.gradLayer = gradientLayer;
        
        
        
        self.ML_AvImgV = [[UIImageView alloc] init];
        self.ML_AvImgV.layer.masksToBounds = YES;
        self.ML_AvImgV.layer.cornerRadius = 22*mHeightScale;
        self.ML_AvImgV.backgroundColor = UIColor.blackColor;
        [self imageViewAddClickWithImageView:self.ML_AvImgV];
        self.ML_AvImgV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.ML_AvImgV];
        
        self.ML_Name = [[UILabel alloc] init];
        self.ML_Name.textColor = [UIColor colorWithHexString:@"#000000"];
        [self.ML_Name setFont:[UIFont boldSystemFontOfSize:14]];
        self.ML_Name.textAlignment = NSTextAlignmentLeft;
        self.ML_Name.numberOfLines = 1;
        [self.contentView addSubview:self.ML_Name];
        
        UIImageView *sexIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:sexIV];
        [sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ML_Name.mas_right).offset(5*mWidthScale);
            make.centerY.mas_equalTo(self.ML_Name.mas_centerY);
            make.width.mas_equalTo(16*mWidthScale);
            make.height.mas_equalTo(16*mWidthScale);
        }];
        self.sexIV = sexIV;
        
        UILabel *onlineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:onlineLabel];
        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ML_Name.mas_left);
            make.top.mas_equalTo(self.ML_Name.mas_bottom).offset(5*mHeightScale);
            make.height.mas_equalTo(15*mHeightScale);
        }];
        onlineLabel.font = [UIFont systemFontOfSize:10];
        onlineLabel.textColor = kGetColor(@"aaa6ae");
        self.onlineLabel = onlineLabel;
        
        UIButton *shipinBT = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:shipinBT];
        [shipinBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(243*mWidthScale);
            make.top.mas_equalTo(20*mHeightScale);
            make.width.height.mas_equalTo(32*mWidthScale);
        }];
        [shipinBT setBackgroundImage:kGetImage(@"comShi") forState:UIControlStateNormal];
        self.shipBt = shipinBT;
        [self.shipBt addTarget:self action:@selector(shipingCick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentTextView = [[ExpandLabel alloc] init];
        self.contentTextView.delegate = self;
        [self.contentView addSubview:self.contentTextView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumLineSpacing=5;
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        
        
        UICollectionView *collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(10, 80, self.width - 24, 80) collectionViewLayout:layout];
        collectionView.delegate=self;
        collectionView.dataSource=self;
        //背景
        collectionView.backgroundColor= [UIColor clearColor];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        //注册
        [collectionView registerClass:[ML_PictureCell class] forCellWithReuseIdentifier:@"ML_PictureCell"];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
        
        self.ML_LoveBtn = [[UIButton alloc] init];
        [self.ML_LoveBtn setImage:kGetImage(@"icon_dianzan_22_999_nor") forState:UIControlStateNormal];
        [self.ML_LoveBtn setImage:kGetImage(@"icon_dianzan_22_999_sel") forState:UIControlStateSelected];
        [self.ML_LoveBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.ML_LoveBtn.titleLabel.font = kGetFont(14);
        [self.ML_LoveBtn addTarget:self action:@selector(ML_LoveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ML_LoveBtn];
        [self.ML_LoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20*mHeightScale);
            make.right.mas_equalTo(-30*mWidthScale);
            make.width.mas_equalTo(64*mWidthScale);
            make.height.mas_equalTo(32*mHeightScale);
        }];
        self.ML_LoveBtn.layer.cornerRadius = 16*mHeightScale;
        self.ML_LoveBtn.layer.masksToBounds = YES;
        self.ML_LoveBtn.backgroundColor = UIColor.systemPinkColor;
        self.ML_Linve = [[UIView alloc] init];
        self.ML_Linve.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self.contentView addSubview:self.ML_Linve];
        
        
    }
    return self;
}

- (void)shipingCick:(UIButton *)sender{
    [self gotoCallVCWithUserId:self.ML_Model.userId isCalled:NO];
}

- (void)ML_LoveBtnClick:(UIButton *)btn
{
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"dynamicId" : self.ML_Model.ID?:@"", @"like" : @(![self.ML_Model.isLike boolValue])} urlStr:@"/dynamic/likeDynamic"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        
//        PNSToast([UIViewController topShowViewController].view, @"请求成功", 1.0);
        btn.selected = !btn.selected;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (btn.selected) {
                [weakself.ML_LoveBtn setBackgroundColor:kGetColor(@"ff6366")];
            }else{
                [weakself.ML_LoveBtn setBackgroundColor:kGetColor(@"ffffff")];
               
            }
        });
        
        
        if (btn.selected) {
            weakself.ML_Model.likesCount = [NSString stringWithFormat:@"%d", [weakself.ML_Model.likesCount intValue] + 1];
        } else {
            weakself.ML_Model.likesCount = [NSString stringWithFormat:@"%d", [weakself.ML_Model.likesCount intValue] - 1];
        }
        
        weakself.ML_Model.isLike = [NSString stringWithFormat:@"%d", btn.selected];
        
        if ([weakself.ML_Model.likesCount intValue] > 1000000) {
            [weakself.ML_LoveBtn setTitle:@" 100W+" forState:UIControlStateNormal];
        } else {
            [weakself.ML_LoveBtn setTitle:[NSString stringWithFormat:@"  %@", weakself.ML_Model.likesCount] forState:UIControlStateNormal];
        }
        
        if (weakself.RefreshContenBlock) {

            weakself.RefreshContenBlock(weakself.ML_Model);
            
        }
           
        
    } error:^(MLNetworkResponse *response) {


    } failure:^(NSError *error) {



    }];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ML_ListArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ML_PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"ML_PictureCell_%ld", _ML_Model.index] forIndexPath:indexPath];

    NSString *urlStr = self.ML_ListArr[indexPath.row];
    if ([self.ML_Model.type intValue] == 1) {
        cell.ML_PlayImgV.hidden = NO;
        cell.ML_Picture = _ML_Model.cover?:@"";
    } else {
        cell.ML_PlayImgV.hidden = YES;
        cell.ML_Picture = urlStr;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ToastPictureVCBlock) {
        ML_PictureCell * cell = (ML_PictureCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
        cell.tag = indexPath.row;
        self.ToastPictureVCBlock(self.ML_Model, cell, [self.ML_Model.type intValue]);
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        if ([self.ML_Model.type intValue] == 1 && self.ML_ListArr.count) {
            
//            NSString *urlStr = self.ML_ListArr[0];
            
//            if ([urlStr hasSuffix:@".mp4"]) {
                layout.itemSize = CGSizeMake(170*mWidthScale, 226*mWidthScale);
//            }
        } else if (self.ML_ListArr.count == 2) {
            
            layout.itemSize = CGSizeMake(122*mWidthScale, 122*mWidthScale);
        } else if (self.ML_ListArr.count == 1) {
            
            layout.itemSize = CGSizeMake(170, 226);
        } else {
            
            layout.itemSize = CGSizeMake(88*mWidthScale, 88*mWidthScale);
        }
        layout.minimumLineSpacing=5;
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        
        
        UICollectionView *collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(10, 80, self.width - 24, layout.itemSize.height) collectionViewLayout:layout];
        collectionView.delegate=self;
        collectionView.dataSource=self;
        //背景
        collectionView.backgroundColor= [UIColor whiteColor];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        //注册
        [collectionView registerClass:[ML_PictureCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"ML_PictureCell_%ld", _ML_Model.index]];
        [self.contentView addSubview:collectionView];
        _collectionView = collectionView;
        
    }
    return _collectionView;
}

- (void)setML_Model:(ML_CommunityModel *)ML_Model
{
    _ML_Model = ML_Model;
    
    self.ML_ListArr = ML_Model.url;
    if (ML_Model.gender.intValue) {
        self.sexIV.image = kGetImage(@"male");
    }else{
        self.sexIV.image = kGetImage(@"female");
    }
    
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    [self.contentView addSubview:self.collectionView];
    self.collectionView.hidden = !self.ML_ListArr.count;
    self.ML_AvImgV.tag = [ML_Model.userId integerValue];
    [self.ML_AvImgV sd_setImageWithURL:kGetUrlPath(ML_Model.icon) placeholderImage:kPlaceImage];
    self.ML_AvImgV.frame = CGRectMake(22*mWidthScale, 17, 44*mWidthScale, 44*mWidthScale);
    [self.ML_AvImgV addOnLineViewWithState:ML_Model.online];
    
    self.ML_Name.text = ML_Model.username;
    [self.ML_Name setNameFrameWithOrigin:CGPointMake(CGRectGetMaxX(self.ML_AvImgV.frame) + 12, self.ML_AvImgV.y) height:20*mHeightScale];

    self.ML_LoveBtn.selected = [ML_Model.isLike boolValue];
    if ([ML_Model.likesCount intValue] > 1000000) {
        [self.ML_LoveBtn setTitle:@" 100W+" forState:UIControlStateNormal];
    } else {
        [self.ML_LoveBtn setTitle:[NSString stringWithFormat:@"  %@", ML_Model.likesCount] forState:UIControlStateNormal];
    }
    if (self.ML_LoveBtn.selected) {
        self.ML_LoveBtn.backgroundColor = kGetColor(@"ff6366");
    }else{
        self.ML_LoveBtn.backgroundColor = kGetColor(@"ffffff");
    }
    self.onlineLabel.text = [NSString stringWithFormat:@"%@%@",ML_Model.createTime,ML_Model.location];
    kSelf;
    self.contentTextView.block = ^(CGFloat height) {

        weakself.contentTextView.frame = CGRectMake(22*mWidthScale, CGRectGetMaxY(weakself.ML_AvImgV.frame) + 13, ML_ScreenWidth-44*mWidthScale, height);
        
        CGSize itemSize = CGSizeMake(80, 80);
        if ([self.ML_Model.type intValue] == 1 && self.ML_ListArr.count) {

            NSString *urlStr = weakself.ML_ListArr[0];

//            if ([urlStr hasSuffix:@".mp4"]) {
                itemSize = CGSizeMake(170, 226);
//            }
        } else if (self.ML_ListArr.count == 2) {

            itemSize = CGSizeMake(122, 122);
        } else if (self.ML_ListArr.count == 1) {

            itemSize = CGSizeMake(170, 226);
        }
        
        weakself.collectionView.frame = CGRectMake(weakself.contentTextView.x, CGRectGetMaxY(weakself.contentTextView.frame) + 12, weakself.contentTextView.width, weakself.collectionView.hidden?0:itemSize.height);
//        weakself.ML_LoveBtn.frame = CGRectMake(ML_ScreenWidth - 130, CGRectGetMaxY(weakself.collectionView.frame), 110, 40);
        weakself.ML_Linve.frame = CGRectMake(12, CGRectGetMaxY(weakself.collectionView.frame) + 12, weakself.contentTextView.width, 1);
        weakself.cellHeight = CGRectGetMaxY(weakself.ML_Linve.frame) + 20;
        weakself.gradLayer.frame = CGRectMake(0, 0, 355*mWidthScale, weakself.cellHeight);
        if (weakself.RefreshContenBlock) {
   
            weakself.RefreshContenBlock(weakself.ML_Model);
        }
        
    };
    
    self.contentTextView.isExpand = self.ML_Model.isOpen;
    [self.contentTextView setExpandAtt:ML_Model.title?:@"" YYLabelW:ML_ScreenWidth-24 MaxLineNum:3 font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] LineSpace:5];
}

- (void)ExpandLabelClickWei
{
    self.ML_Model.isOpen = !self.ML_Model.isOpen;

    if (self.RefreshContenBlock) {

        self.RefreshContenBlock(self.ML_Model);
    }
    
}

@end
