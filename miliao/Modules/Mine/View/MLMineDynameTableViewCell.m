//
//  MLMineDynameTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLMineDynameTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLMineDynamelistCollectionViewCell.h"

@interface MLMineDynameTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UITextView *titlelabel;
@property (nonatomic,strong)UILabel *timerlabel;
@property (nonatomic,strong)UILabel *indexlabel;
@property (nonatomic,strong)UILabel *timerbottomlabel;
@property (nonatomic,strong)UIView *bgView;
//@property (nonatomic,strong)UICollectionView *ML_headCollectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *headflowLayout;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSArray *nmarray;
@property (nonatomic,strong)UIImageView *videoimg;

@end


@implementation MLMineDynameTableViewCell

-(NSArray *)nmarray{
    if (_nmarray == nil) {
        _nmarray = [NSArray array];
    }
    return _nmarray;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    //虚线
    UIBezierPath *path=[[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(34*mWidthScale, 0)];
    [path addLineToPoint:CGPointMake(34*mWidthScale, 180)];
    CAShapeLayer *shape=[CAShapeLayer layer];
    shape.strokeColor = [UIColor colorWithHexString:@"d4d5d8"].CGColor;
    shape.fillColor=[UIColor clearColor].CGColor;
    shape.lineWidth=0.5;
    shape.lineJoin=kCALineJoinRound;
    shape.lineCap = kCALineCapRound;
    shape.path=path.CGPath;
    shape.lineDashPattern=@[@2,@2];
    
    [self.contentView.layer addSublayer:shape];
    
    
    UIView *timeview=[[UIView alloc]initWithFrame:CGRectMake(16*mWidthScale, 10, 36*mWidthScale, 46*mHeightScale)];
    timeview.backgroundColor=[UIColor colorWithHexString:@"ffe962"];
    timeview.layer.cornerRadius=6;
    timeview.layer.masksToBounds=YES;
    [self.contentView addSubview:timeview];
    
    UILabel *timerlabel = [[UILabel alloc]init];
    timerlabel.text = @"08";
    timerlabel.textAlignment=NSTextAlignmentCenter;
    timerlabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    timerlabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [timeview addSubview:timerlabel];
    self.timerlabel = timerlabel;
    [timerlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18*mHeightScale);
    }];
    
    UILabel *timerbottomlabel = [[UILabel alloc]init];
//    timerbottomlabel.text = @"11月";
    timerbottomlabel.textAlignment=NSTextAlignmentCenter;
    timerbottomlabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightRegular];
    timerbottomlabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [timeview addSubview:timerbottomlabel];
    self.timerbottomlabel = timerbottomlabel;
    [timerbottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(16*mHeightScale);
        make.height.mas_equalTo(28*mHeightScale);
    }];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, 16, 142, 142)];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(88*mWidthScale);
        make.left.mas_equalTo(timerlabel.mas_right).mas_offset(14);
        make.top.mas_equalTo(40);
    }];
    
    
    UIImageView *videoimg =[[UIImageView alloc]init];
    videoimg.tag = 101;
    videoimg.image = [UIImage imageNamed:@"icon_shiping_36_nor"];
    [bgView addSubview:videoimg];
    self.videoimg = videoimg;
    [videoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.width.height.mas_equalTo(36);
    }];
        
    UITextView *titlelabel = [[UITextView alloc]init];
    titlelabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    titlelabel.textColor = [UIColor colorFromHexString:@"#8c8c8c"];
    titlelabel.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    titlelabel.editable = NO;
    [self.contentView addSubview:titlelabel];
    self.titlelabel = titlelabel;
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(16);
        make.left.mas_equalTo(timeview.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(36*mHeightScale);
    }];

    UILabel *statuslabel = [[UILabel alloc]init];
    statuslabel.text = Localized(@"审核中...", nil);
    statuslabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    statuslabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [self.contentView addSubview:statuslabel];
    self.statuslabel = statuslabel;
    [statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).mas_offset(0);
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(15);
    }];

    UILabel *indexlabel = [[UILabel alloc]init];
    indexlabel.textAlignment = NSTextAlignmentCenter;
    indexlabel.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    indexlabel.layer.cornerRadius= 9*mHeightScale;
    indexlabel.layer.masksToBounds = YES;
    indexlabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    indexlabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.contentView addSubview:indexlabel];
    self.indexlabel = indexlabel;
    [indexlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(statuslabel.mas_centerY);
        make.width.mas_equalTo(50*mWidthScale);
        make.height.mas_equalTo(18*mHeightScale);
    }];
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timerbottomlabel.mas_right).mas_offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    titlelabel.userInteractionEnabled = NO;
    [self.contentView addGestureRecognizer: self.titlelabel.panGestureRecognizer];
    
    
//    self.ML_headCollectionView.userInteractionEnabled = NO;
//    [self.contentView addGestureRecognizer:self.ML_headCollectionView.panGestureRecognizer];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //self.headimg.layer.cornerRadius = self.headimg.frame.size.width / 2;
    //self.headimg.layer.masksToBounds = YES;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.nmarray = nil;
//    [self.dataArray removeLastObject];
   
    if ([dict[@"title"] isEqual:[NSNull null]]) {
        self.titlelabel.text = Localized(@"还没有文字描述哦~", nil);
    }else{
        self.titlelabel.text = _dict[@"title"];
    };

    if ([_dict[@"auditStatus"] integerValue] == 0) {
        self.statuslabel.text = Localized(@"待审核", nil);
    }else if ([_dict[@"auditStatus"] integerValue] == 1){
        self.statuslabel.text = Localized(@"审核通过", nil);
    }else{
        self.statuslabel.text = Localized(@"拒绝", nil);
    }

    if ([_dict[@"type"] integerValue] == 0) {
        self.videoimg.hidden = YES;
    }else{
        self.videoimg.hidden = NO;
    }

    self.timerlabel.text = _dict[@"aduitTime"];
    NSArray *array = [self.timerlabel.text componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    //NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
    self.timerlabel.text = [NSString stringWithFormat:@"%@%@",array[1], Localized(@"月", nil)];
    //    "18 14:05:44"
    NSString *bottomstr = array[2];
    NSString *leftstring = [bottomstr substringToIndex:3];//截取掉下标7之后的字符串
    //截取掉下标2之前的字符串
    self.timerbottomlabel.text = [leftstring substringFromIndex:0];
    NSArray *urlarray = dict[@"url"];
    self.indexlabel.text = [NSString stringWithFormat:@"%@%lu%@", Localized(@"共", nil), (unsigned long)urlarray.count, Localized(@"张", nil)];
//    [self.ML_headCollectionView reloadData];
    
    for (UIView *view in self.bgView.subviews) {
        if (view.tag != 101) {
            
            [view removeFromSuperview];
        }
    }
    NSArray *nmarray = dict[@"url"];

    int i = 0;
    
    for (NSString *url in nmarray) {

        UIImageView *leftbtn = [[UIImageView alloc] init];
        leftbtn.tag = i;
        if (self.type == DynameUITableViewCellone) {
            leftbtn.frame = CGRectMake(0, 0, 142, 142);
        }else if (self.type == DynameUITableViewCelltwo){
            
            if (i == 0) {
                leftbtn.frame = CGRectMake(0, 0, 142 / 2 - 2.5, 142);
            } else {
                leftbtn.frame = CGRectMake(142 / 2 + 2.5, 0, 142 / 2 - 2.5, 142);
            }
            
        }else if(self.type == DynameUITableViewCellthree){
            
            if (i == 0) {
                leftbtn.frame = CGRectMake(0, 0, 142 / 2 - 2.5, 142);
            } else if (i == 1) {
                
                leftbtn.frame = CGRectMake(142 / 2 + 2.5, 0, 142 / 2 - 2.5, 142 / 2 - 2.5);
            } else {
                leftbtn.frame = CGRectMake(142 / 2 + 2.5, 142 / 2 + 2.5, 142 / 2 - 2.5, 142 / 2 - 2.5);
            }
            
        }else{
            
            if (i == 0) {
                leftbtn.frame = CGRectMake(0, 0, 142 / 2 - 2.5, 142 / 2 - 2.5);
            } else if (i == 1) {
                
                leftbtn.frame = CGRectMake(142 / 2 + 2.5, 0, 142 / 2 - 2.5, 142 / 2 - 2.5);
            } else if (i == 2) {
                leftbtn.frame = CGRectMake(0, 142 / 2 + 2.5, 142 / 2 - 2.5, 142 / 2 - 2.5);
            } else {
                leftbtn.frame = CGRectMake(142 / 2 + 2.5, 142 / 2 + 2.5, 142 / 2 - 2.5, 142 / 2 - 2.5);
            }
        }
        
        leftbtn.contentMode = UIViewContentModeScaleAspectFill;
        leftbtn.layer.cornerRadius = 8;
        
        if ([_dict[@"type"] integerValue] == 0) {
            [leftbtn sd_setImageWithURL:kGetUrlPath(url)];
        }else{
            self.videoimg.hidden = NO;
            
            NSString *ss = [NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0", self.dict[@"cover"]];
            NSLog(@"asdf==asdf===%@", kGetUrlPath(ss));
            [leftbtn sd_setImageWithURL:kGetUrlPath(ss)];
        }
        
        leftbtn.layer.masksToBounds = YES;
        [self.bgView addSubview:leftbtn];
        [self.bgView bringSubviewToFront:self.videoimg];
        
//        leftbtn.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftbtnViewClick:)];
        [leftbtn addGestureRecognizer:tap];
        
        i++;
        if  (i >= 4) {
            break;
        }
    }

    
}

- (void)leftbtnViewClick:(UIGestureRecognizer *)gr
{
    
    NSArray *nmarray = _dict[@"url"];
    
    UIImageView *bigView = [[UIImageView alloc] initWithFrame:[UIViewController topShowViewController].view.bounds];
    bigView.backgroundColor = [UIColor blackColor];
    bigView.userInteractionEnabled = YES;
    bigView.contentMode = UIViewContentModeScaleAspectFit;
    [bigView sd_setImageWithURL:kGetUrlPath(nmarray[gr.view.tag])];
    [KEY_WINDOW.window addSubview:bigView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigViewClick:)];
    [bigView addGestureRecognizer:tap];
    
}

- (void)bigViewClick:(UIGestureRecognizer *)gr
{
    [gr.view removeFromSuperview];
}

//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *nmarray = [NSArray array];
    nmarray = self.dict[@"url"];
    if (nmarray.count == 1) {
        return 1;
    }else if(nmarray.count == 2){
        return 2;
    }else if(nmarray.count == 3){
        return 3;
    }else{
        return 4;
    }
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLMineDynamelistCollectionViewCell *itemcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemcell" forIndexPath:indexPath];
    if (itemcell == nil) {
        itemcell = [[MLMineDynamelistCollectionViewCell alloc]init];
        itemcell.backgroundColor = [UIColor whiteColor];
    }
    [self.dataArray removeAllObjects];

        if ([self.dict[@"type"] integerValue] == 1) {
            [self.dict[@"url"] enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
                NSString *ss = [NSString stringWithFormat:@"%@%@",basess,self.dict[@"cover"]];
                NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";
                NSString *ee = [NSString stringWithFormat:@"%@%@",ss,dd];
                [self.dataArray addObject:ee];
            }];
          
        }else{
            
            [self.dict[@"url"] enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
                NSString *ss = [NSString stringWithFormat:@"%@%@",basess,url];
                [self.dataArray addObject:ss];
            }];
        }
        [itemcell.img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item]]];
        return itemcell;
}


@end

