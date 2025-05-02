//
//  MLHomeOneZhaohuView.m
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import "MLHomeOneZhaohuView.h"
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLHomeOnlineyuanViewcellCollectionViewCell.h"
#import "MLMyLayout.h"
#import "MLDynameSHowTableViewCell.h"
#import "MLOnlineMatchingHostListApi.h"
#import "MLHomeselectUserCallCententApi.h"
#import "MLHomeSayHelloBatchApi.h"

@interface MLHomeOneZhaohuView()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UIView *alterView;

@property(nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIView *databgview;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong)UILabel *namelabel;

@property(nonatomic,strong)UILabel *indextitlelabel;
@property(nonatomic,strong)UILabel *phonelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *timerlabel;
@property(nonatomic,strong)UIButton *lookbtn;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy)NSString *textssss;
@property (nonatomic,copy)NSString *phonestr;
@property (nonatomic,copy)NSString *phonenamestr;

@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)NSMutableArray *ML_onlinArray;
@property (nonatomic,strong)NSDictionary *onlineDict;

@property (nonatomic,strong)UIView *bbbview;
@property (nonatomic,strong)UIImageView *headimg;
@property (nonatomic,strong)UIView *bigbbbview;

@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIImageView *downimg;
@property (nonatomic,strong)UIImageView *bglistimg;

@property (nonatomic,assign)BOOL isDashan;
@property (nonatomic,strong)NSMutableArray *zhaohudata;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)NSMutableArray *zhaohudataname;
@property (nonatomic,strong)NSMutableArray *zhaohudataid;


@end

@implementation MLHomeOneZhaohuView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self layoutIfNeeded];
    
    self.userInteractionEnabled = YES;
    self.image = kGetImage(@"card_greeting_background");
    
    self.downimg.image = [UIImage imageNamed:@"Sliceirow40down"];
    [self setmlnetwork];
    
    [self setzhaohuApi];
    
    if (self) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"cancelx"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(36*mHeightScale);
            make.right.mas_equalTo(-12*mWidthScale);
            make.width.height.mas_equalTo(24);
        }];

//        UILabel *namelabel = [[UILabel alloc]init];
//        namelabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
//        namelabel.textColor = [UIColor colorWithHexString:@"#000000"];
//        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"设置打招呼推荐通知"];
//        NSRange titleRange = {0,[title length]};
//        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
//        namelabel.attributedText = title;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCLikc)];
//        [namelabel addGestureRecognizer:tap];
//        namelabel.userInteractionEnabled = YES;
//        namelabel.hidden = YES;
//        [self addSubview:namelabel];
//        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-24);
//            make.centerX.mas_equalTo(self.mas_centerX);
//        }];

 
//        UIButton *changebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [changebtn setTitle:Localized(@"换一批", nil) forState:UIControlStateNormal];
//        [changebtn setImage:[UIImage imageNamed:@"yjrefesh"] forState:UIControlStateNormal];
//        [changebtn setImage:[UIImage imageNamed:@"icon_suijishengcheng_24_nor"] forState:UIControlStateNormal];
//        [changebtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        changebtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//        [changebtn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+10 ,-btn.imageView.frame.size.width - 5, 0.0,-5)];
//        [changebtn setImageEdgeInsets:UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height - 10,(btn.frame.size.width-btn.imageView.bounds.size.width)/2.0 + 6,0.0,(btn.frame.size.width-btn.imageView.bounds.size.width)/2.0)];
//        [changebtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:changebtn];
//        //self.changebtn = changebtn;
//        [changebtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(lookbtn.mas_bottom).mas_offset(0);
//            make.right.mas_equalTo(self.mas_right).mas_offset(-17);
//            make.left.mas_equalTo(lookbtn.mas_right).mas_offset(17);
//            make.top.mas_equalTo(lookbtn.mas_top);
//        }];
        
        UIImageView *bgview = [[UIImageView alloc]init];
        bgview.backgroundColor = UIColor.whiteColor;
        bgview.layer.masksToBounds = YES;
        bgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *downtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downClick)];
        [bgview addGestureRecognizer:downtap];
        bgview.layer.cornerRadius = 20*mHeightScale;
        bgview.layer.borderWidth = 1;
        bgview.layer.borderColor = [UIColor colorFromHexString:@"#d8d8d8"].CGColor;
        [self addSubview:bgview];
        self.bgView = bgview;
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(268*mWidthScale);
            make.top.mas_equalTo(125*mHeightScale);
            make.left.mas_equalTo(16*mWidthScale);
            make.height.mas_equalTo(40*mHeightScale);
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = Localized(@"招呼语:", nil);
        numberLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        numberLabel.textColor = kGetColor(@"ff72be");
        [bgview addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgview.mas_left).mas_offset(24);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(56);
        }];
        
        UIImageView *downimg = [[UIImageView alloc]init];
        downimg.image = [UIImage imageNamed:@"Sliceirow40down"];
        [bgview addSubview:downimg];
        self.downimg = downimg;
        [downimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgview.mas_right).mas_offset(-13);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"哈喽，小哥哥交个朋友呀!";
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [bgview addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberLabel.mas_right).mas_offset(4);
            make.right.mas_equalTo(downimg.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(bgview.mas_centerY);
        }];
        
        UIButton *lookbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookbtn setBackgroundColor:kGetColor(@"ff6fb3")];
        
//        [lookbtn setTitle:Localized(@"一键打招呼", nil) forState:UIControlStateNormal];
//        lookbtn.backgroundColor = [UIColor colorWithHexString:@"#ffe962"];
//        [lookbtn setImage:kGetImage(@"yjhellow") forState:UIControlStateNormal];
//        [lookbtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
//        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [lookbtn addTarget:self action:@selector(lookclick) forControlEvents:UIControlEventTouchUpInside];
        lookbtn.layer.masksToBounds = YES;
        lookbtn.layer.cornerRadius = 20*mHeightScale;
        [lookbtn setTitle:@"发送" forState:UIControlStateNormal];
        [lookbtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        lookbtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:lookbtn];
        self.lookbtn = lookbtn;
        [lookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(68*mWidthScale);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.left.mas_equalTo(295*mWidthScale);
            make.height.mas_equalTo(40*mHeightScale);
        }];
        

//        MLMyLayout * layout = [[MLMyLayout alloc]init];
//        self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//        self.ML_homeCollectionView.backgroundColor = [UIColor clearColor];
//        self.ML_homeCollectionView.dataSource = self;
//        self.ML_homeCollectionView.delegate = self;
//        [self.ML_homeCollectionView registerClass:[MLHomeOnlineyuanViewcellCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//        [self addSubview:self.ML_homeCollectionView];
//        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(btn.mas_bottom).mas_offset(50);
//            make.left.mas_equalTo(self.mas_left).mas_offset(16);
//            make.right.mas_equalTo(self.mas_right).mas_offset(-16);
//            make.bottom.mas_equalTo(bgview.mas_top).mas_offset(-32);
//        }];
//        
//        UIView *bigbbbview  = [[UIView alloc]init];
//        bigbbbview.backgroundColor = [UIColor colorWithHexString:@"#835DFF" alpha:0.08];
//        [self addSubview:bigbbbview];
//        self.bigbbbview = bigbbbview;
//        [bigbbbview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(260);
//            make.centerX.mas_equalTo(self.ML_homeCollectionView.mas_centerX);
//            make.centerY.mas_equalTo(self.ML_homeCollectionView.mas_centerY);
//        }];
//                
//        UIView *bbbview  = [[UIView alloc]init];
//        bbbview.backgroundColor = [UIColor colorWithHexString:@"#835DFF" alpha:0.15];
//        bbbview.layer.cornerRadius = bbbview.frame.size.width / 2;
//        bbbview.layer.masksToBounds = YES;
//        [bigbbbview addSubview:bbbview];
//        self.bbbview = bbbview;
//        [bbbview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(121);
//            make.centerX.mas_equalTo(self.ML_homeCollectionView.mas_centerX);
//            make.centerY.mas_equalTo(self.ML_homeCollectionView.mas_centerY);
//        }];
//        [bbbview layoutIfNeeded];

//        UIImageView *headimg = [[UIImageView alloc]init];
//        [headimg sd_setImageWithURL:kGetUrlPath([ML_AppUserInfoManager sharedManager].currentLoginUserData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
//        headimg.layer.cornerRadius = 28;
//        headimg.contentMode = UIViewContentModeScaleAspectFill;
//        headimg.layer.masksToBounds = YES;
//        [bbbview addSubview:headimg];
//        self.headimg = headimg;
//        [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(56);
//            make.centerX.mas_equalTo(bbbview.mas_centerX);
//            make.centerY.mas_equalTo(bbbview.mas_centerY);
//        }];
//        [headimg layoutIfNeeded];
//            CABasicAnimation *rotationAnimation;
//            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//            rotationAnimation.duration = 10;
//            rotationAnimation.cumulative = YES;
//            rotationAnimation.repeatCount = 10000;
//            [self.ML_homeCollectionView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            //[self.ML_homeCollectionView.layer removeAllAnimations]; 移除动画
    }
    return self;
}

-(NSMutableArray *)zhaohudataname{
    if (_zhaohudataname == nil) {
        _zhaohudataname = [NSMutableArray array];
    }
    return _zhaohudataname;
}
-(NSMutableArray *)zhaohudataid{
    if (_zhaohudataid == nil) {
        _zhaohudataid = [NSMutableArray array];
    }
    return _zhaohudataid;
}


-(NSMutableArray *)zhaohudata{
    if (_zhaohudata == nil) {
        _zhaohudata = [NSMutableArray array];
    }
    return _zhaohudata;
}



-(NSMutableArray *)ML_onlinArray{
    if (_ML_onlinArray == nil) {
        _ML_onlinArray = [NSMutableArray array];
    }
    return _ML_onlinArray;
}

-(void)changeClick{
    NSLog(Localized(@"换一批", nil));
    [self setmlnetwork];
}


-(void)tapCLikc{
    NSLog(@"设置推送");
}

//咋呼api
-(void)setzhaohuApi{
    MLHomeselectUserCallCententApi *api = [[MLHomeselectUserCallCententApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        self.zhaohudata  = response.data[@"hostCallContents"];
        if (self.zhaohudata.count) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",self.zhaohudata[0][@"content"]];
            [self.ML_showTableview reloadData];
        }
        [self.zhaohudata enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.zhaohudataname addObject:dict[@"content"]];
        }];
        [self.zhaohudata enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.zhaohudataid addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }];
        [self.ML_showTableview reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

-(void)setmlnetwork{
    MLOnlineMatchingHostListApi *api = [[MLOnlineMatchingHostListApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] limit:@"5"];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        self.ML_onlinArray = response.data[@"users"];
        [self.ML_homeCollectionView reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}



//xiazhankai-----
-(void)downClick{
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];
    self.downimg.image = [UIImage imageNamed:@"Sliceirow40"];
    self.bglistimg = [[UIImageView alloc]init];
    self.bglistimg.backgroundColor = UIColor.whiteColor;//.image = [UIImage imageNamed:@"zhaohubg"];
    [self addSubview:self.bglistimg];
    [self.bglistimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(33);
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.bottom.mas_equalTo(self.bgView.mas_top).mas_offset(0);
        make.height.mas_equalTo(130);
    }];
    self.ML_showTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ML_showTableview.delegate = self;
    self.ML_showTableview.dataSource = self;
    self.ML_showTableview.backgroundColor = UIColor.clearColor;
    self.ML_showTableview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2500].CGColor;
    self.ML_showTableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self addSubview:self.ML_showTableview];
    [self.ML_showTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bglistimg).mas_offset(0);
        make.top.mas_equalTo(self.bglistimg.mas_top).mas_offset(15);
        make.bottom.mas_equalTo(self.bglistimg.mas_bottom).mas_offset(-5);
    }];
    if (self.isDashan == NO) {
        self.isDashan = YES;
    }else{
        self.isDashan = NO;
        self.downimg.image = [UIImage imageNamed:@"Sliceirow40down"];
        [self.ML_showTableview removeFromSuperview];
        [self.bglistimg removeFromSuperview];
    }
}



//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.ML_onlinArray.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLHomeOnlineyuanViewcellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[MLHomeOnlineyuanViewcellCollectionViewCell alloc]init];
        }
    //cell.dict = self.ML_onlinArray[indexPath.item];
    [cell.imageView sd_setImageWithURL:kGetUrlPath(self.ML_onlinArray[indexPath.row][@"icon"])];
//    cell.imageView.backgroundColor = UIColor.redColor;
        return cell;
}

#pragma mark ---- tablviewdelegate---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zhaohudata.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MLDynameSHowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
          if(cell == nil) {
              cell =[[MLDynameSHowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"showcell"];
          }
        cell.nameLabel.text = self.zhaohudata[indexPath.row][@"content"];
        //cell.nameLabel.text = @"测试数据";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.downimg.image = [UIImage imageNamed:@"Sliceirow40down"];
    MLDynameSHowTableViewCell * cell = (MLDynameSHowTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    self.titleLabel.text = cell.nameLabel.text;
    [self.ML_showTableview removeFromSuperview];
    [self.bglistimg removeFromSuperview];
    self.isDashan = NO;
 }

+(instancetype)alterVietextview:(NSString *)textview
                       namestr:(NSString *)namestr
            StrblocksureBtClcik:(sureBlock)sureBlock
                      cancelClick:(cancelBlock)cancelBlock{
    MLHomeOneZhaohuView *alterView=[[MLHomeOneZhaohuView alloc]initWithFrame:CGRectMake(0, ML_ScreenHeight-208*mHeightScale, WIDTH, 208*mHeightScale)];
            alterView.backgroundColor = [UIColor whiteColor];
//            alterView.center = CGPointMake(WIDTH/2, HEIGHT/2);
            alterView.layer.cornerRadius = 16;
            alterView.layer.masksToBounds=YES;
            alterView.sure_block=sureBlock;
            alterView.cancel_block = cancelBlock;
            alterView.textView.text = textview;
            alterView.namelabel.text = namestr;
          
            return alterView;
}

#pragma mark--给属性重新赋值

-(void)setContent:(NSString *)content{
    _contentlabel.text = content;
}

-(void)setTitleLb:(UILabel *)titleLb{
    self.namelabel.text = self.titleLb.text;
}

-(void)setphonelabel:(UILabel *)phonelabel{
    _phonelabel.text = phonelabel.text;
}

-(void)setPhonestr:(NSString *)phonestr{
    _phonestr = phonestr;
}

-(void)setNamelabel:(UILabel *)namelabel{
    _namelabel = namelabel;
}

-(void)setTextView:(UITextView *)textView{
    _textView = textView;
}

//-(void)setSure:(NSString *)sure{
////    [_sureBt setTitle:sure forState:UIControlStateNormal];
//}

#pragma mark----确定按钮点击事件
-(void)cancelclick{
    
     self.cancel_block();
}

-(void)lookclick{
    NSLog(@"hehheheh");
    //self.sure_block();
    self.lookbtn.enabled = NO;
    NSMutableArray *userarray = [NSMutableArray array];
    [self.ML_onlinArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [userarray addObject:[NSString stringWithFormat:@"%@",dict[@"userId"]]];
    }];
    NSString *userids= [userarray componentsJoinedByString:@","];
    NSLog(@"userids------%@",userids);

    NSInteger index = [self.zhaohudataname indexOfObject:self.titleLabel.text];
    NSLog(@"1---%ld---",index);
    NSString *zhoahuid = [self.zhaohudataid objectAtIndex:index];
    NSLog(@"%@",zhoahuid);
    
    MLHomeSayHelloBatchApi *api = [[MLHomeSayHelloBatchApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] contentId:zhoahuid toUserIds:userids];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        [self um_oneClickGreetingWithUserarray:userarray];
        self.sure_block();
    } error:^(MLNetworkResponse *response) {
        
        self.lookbtn.enabled = YES;
    } failure:^(NSError *error) {
        
        self.lookbtn.enabled = YES;
    }];
}


- (void)um_oneClickGreetingWithUserarray:(NSArray *)userarray { // 进入页面
      NSDictionary *eventParams = @{@"Um_Key_PageName":@"一键打招呼",
                                    @"Um_Key_UserID":[self arrayToJSONString:userarray],
                                    @"Um_Key_Type":@"1"
                                  };

//    [MobClick beginEvent:@"5123" primarykey:@"oneClickGreeting" attributes:eventParams];
}

- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonTemp;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.bigbbbview.layer.cornerRadius = self.bigbbbview.frame.size.width / 2;
    self.bigbbbview.layer.masksToBounds = YES;

    self.bbbview.layer.cornerRadius = self.bbbview.frame.size.width / 2;
    self.bbbview.layer.masksToBounds = YES;
    
    self.headimg.layer.cornerRadius = self.headimg.frame.size.width / 2;
    self.headimg.layer.masksToBounds = YES;
    
    [self.headimg layoutIfNeeded];
    [self.bbbview layoutIfNeeded];
    [self.bigbbbview layoutIfNeeded];
}




@end
