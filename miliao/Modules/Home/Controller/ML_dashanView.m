//
//  ML_dashanView.m
//  SiLiaoBack
//
//  Created by 密码：0000 on 2024/1/13.
//

#import "ML_dashanView.h"
#import "MLZhaohuListApi.h"
#import "ML_CommonApi.h"


@interface ML_dashanView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mytableview;
@property(nonatomic,strong)NSArray *mydata;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView*downimg;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)NSInteger selecdedIndex;
@end

@implementation ML_dashanView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dic= self.mydata[indexPath.row];
    cell.textLabel.text= dic[@"content"];
    cell.textLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30*mHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic= self.mydata[indexPath.row];
    self.selecdedIndex = indexPath.row;
    NSString *text=dic[@"content"];
    self.titleLabel.text=text;
    self.mytableview.hidden=YES;
}



-(UITableView *)mytableview{
    if(!_mytableview){
        _mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 150, 30) style:UITableViewStylePlain];
        [_mytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _mytableview.delegate=self;
        _mytableview.dataSource=self;
        _mytableview.layer.cornerRadius=10;
        _mytableview.layer.masksToBounds=YES;
        
    }
    return _mytableview;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        UIImageView *bgIV=[[UIImageView alloc]initWithFrame:self.bounds];
        bgIV.image=kGetImage(@"dashanBG");
        bgIV.userInteractionEnabled=YES;
        [self addSubview:bgIV];
        [self dashanAPI];
        UIView *bgview = [[UIView alloc]init];
        bgview.layer.masksToBounds = YES;
//        bgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *downtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downClick)];
        [bgview addGestureRecognizer:downtap];
        bgview.layer.cornerRadius = 20;
        bgview.backgroundColor=[UIColor whiteColor];
//        bgview.layer.borderWidth = 1;
//        bgview.layer.borderColor = kGetColor(@"000000").CGColor;
        [self addSubview:bgview];
        self.bgView = bgview;
       
        self.mytableview.hidden=YES;
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(522*mHeightScale);
            make.width.mas_equalTo(311*mWidthScale);
            make.left.mas_equalTo(32*mWidthScale);
            make.height.mas_equalTo(40*mHeightScale);
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = Localized(@"招呼语:", nil);
        numberLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        numberLabel.textColor = kGetColor(@"ff72be");
        [bgview addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgview.mas_left).mas_offset(16*mHeightScale);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(56*mWidthScale);
        }];
        
        UIImageView *downimg = [[UIImageView alloc]init];
        downimg.image = [UIImage imageNamed:@"downP"];
        [bgview addSubview:downimg];
        self.downimg = downimg;
        [downimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgview.mas_right).mas_offset(-13*mWidthScale);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.mas_equalTo(24*mWidthScale);
            make.height.mas_equalTo(24*mWidthScale);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"哈喽，小哥哥交个朋友呀!";
        titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kGetColor(@"333333");
        [bgview addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberLabel.mas_right).mas_offset(4);
            make.right.mas_equalTo(downimg.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(bgview.mas_centerY);
        }];
        
       
        
        UIButton *cancelbt=[[UIButton alloc]initWithFrame:CGRectMake(331*mWidthScale, 197*mHeightScale, 24*mWidthScale, 24*mWidthScale)];
        [cancelbt setBackgroundImage:kGetImage(@"cancelx") forState:UIControlStateNormal];
        [self addSubview:cancelbt];
        [cancelbt addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBt=[[UIButton alloc]initWithFrame:CGRectMake(20, 200, 299, 40)];

        [self addSubview:sureBt];
        [sureBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(574*mHeightScale);
            make.width.mas_equalTo(248*mWidthScale);
            make.height.mas_equalTo(44*mHeightScale);
            make.left.mas_equalTo(32*mWidthScale);
        }];
        [sureBt addTarget:self action:@selector(sureBTclick) forControlEvents:UIControlEventTouchUpInside];
        [sureBt setBackgroundImage:kGetImage(@"oneZhao") forState:UIControlStateNormal];
        [self addSubview:self.mytableview];
        [self.mytableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgview.mas_bottom).offset(2);
            make.left.mas_equalTo(bgview.mas_left);
            make.right.mas_equalTo(bgview.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    return self;
}

- (void)cancelClick{
    [self removeFromSuperview];
}

-(void)sureBTclick{
    kSelf;
    NSDictionary *data=self.mydata[self.selecdedIndex];
    if(!data){
        [SVProgressHUD showWithStatus:@"请选择招呼语"];
        return;
    }
     ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"contentId" : data[@"id"]} urlStr:@"host/sayHelloAccost"];
    
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
         if ([response.data[@"sayCode"] intValue] == 1) {
             
             [self um_oneTouchChatWithUserId:[NSString stringWithFormat:@"%@", data[@"id"]]];
         } else {
             kplaceToast(response.data[@"msg"]?:@"搭讪失败");
         }
         
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
       
    }];
    [weakself removeFromSuperview];
}

- (void)um_oneTouchChatWithUserId:(NSString *)userId {
           NSDictionary *eventParams = @{@"Um_Key_PageName":@"一键搭讪",
                                         @"Um_Key_UserID":userId,
                                         @"Um_Key_Type":@"1"
                                       };

//         [MobClick beginEvent:@"5122" primarykey:@"oneTouchChat" attributes:eventParams];
}


-(void)downClick{
    if(self.mytableview.hidden){
        self.mytableview.hidden = NO;
        self.downimg.image= kGetImage(@"Sliceirow40");
    }else{
        self.mytableview.hidden = YES;
        self.downimg.image=kGetImage(@"downP");
    }
}

-(void)dashanAPI{
    MLZhaohuListApi *api = [[MLZhaohuListApi alloc]initWithstatus:@"0" limit:@"10" page:@"1" token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
 
        NSArray *arr  = response.data[@"callContents"];
        NSDictionary *dic=arr[0];
        self.titleLabel.text=dic[@"content"];
        self.mydata = arr;
        [self.mytableview reloadData];
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}



@end
