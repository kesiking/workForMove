//
//  EHModifyRelationViewController.m
//  eHome
//
//  Created by louzhenhua on 15/7/6.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyRelationViewController.h"
#import "KSInsetsTextField.h"
#import "EHUpdateBabyUserService.h"


#define TEXTFIELD_INSETS 20
#define RELATIONTEXTFIELD_Y_MARGIN 15
#define RELATIONTEXTFIELDHEIGHT 49
#define RELATIONTEXTFIELD_LEFTVIEW_HEIGHT 70

#define SHORTCUT_VERTIACAL_SPACE 15
#define SHORTCUT_X_MARGIN 20
#define SHORTCUT_WIDTH 80
#define SHORTCUT_HEIGHT 15

#define IMAGEVIEW_VERTIACAL_SPACE_40 50
#define IMAGEVIEW_VERTIACAL_SPACE_20 20

@interface EHModifyRelationViewController ()
{
    
    UIImageView *_topBackgroundImageView;
    KSInsetsTextField *_customRelationTextFiled;
    
    UILabel *_shortcutLabel;
    UIImageView *_leftLineImageView;
    UIImageView *_rightLineImageView;
    
    UIImageView* _fartherImageView;
    UIImageView* _motherImageView;
    UIImageView* _grandpaImageView;
    UIImageView* _grandmaImageView;
    UIImageView* _uncleImageView;
    UIImageView* _auntImageView;
    UIImageView* _brotherImageView;
    UIImageView* _sisterImageView;
    UIImageView* _familyImageView;
    UIImageView* _selectedImageView;
    
    NSArray* _relationArray;

}

@property(nonatomic, strong)EHUpdateBabyUserService* updateBabyUserService;
@property(nonatomic, strong)NSString* selectedRelation;
@end


@implementation EHModifyRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"您与宝贝的关系";
    _relationArray = @[@"爸爸", @"妈妈", @"爷爷", @"奶奶", @"叔叔", @"阿姨", @"哥哥", @"姐姐", @"家人"];
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
    self.view.backgroundColor = EH_bgcor1;
    
    [self setupCustomTextfield];
    [self setupShotcutPromptLabel];
    [self setupRelationImageViews];
    
    [self setupCurrentRelation:self.currentRelationShip];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relationTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupCustomTextfield
{
    _topBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_name"]];
    [self.view addSubview:_topBackgroundImageView];
    [_topBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@105);
    }];
    
    _customRelationTextFiled = [[KSInsetsTextField alloc] initWithFrame:CGRectZero];
    _customRelationTextFiled.textAlignment = NSTextAlignmentCenter;
    _customRelationTextFiled.text = self.currentRelationShip;

    _customRelationTextFiled.font = EHFont1;
    _customRelationTextFiled.textColor = EHCor1;
    _customRelationTextFiled.backgroundColor = [UIColor clearColor];
    _customRelationTextFiled.layer.borderColor=[[UIColor whiteColor] CGColor];
    _customRelationTextFiled.layer.borderWidth= .5f;
    _customRelationTextFiled.layer.cornerRadius=5.0f;
    _customRelationTextFiled.layer.masksToBounds=YES;
    
     _customRelationTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_customRelationTextFiled];
    [_customRelationTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_topBackgroundImageView);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@35);
    }];
}

- (void)setupShotcutPromptLabel
{
    _shortcutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _shortcutLabel.text = @"快速选择";
    _shortcutLabel.textAlignment = NSTextAlignmentCenter;
    _shortcutLabel.font = EHFont2;
    _shortcutLabel.textColor = EHCor3;
    [self.view addSubview:_shortcutLabel];
    [_shortcutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_topBackgroundImageView.mas_bottom).offset(30);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    
    _leftLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_leftLineImageView];
    [_leftLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabel.mas_centerY);
        make.right.equalTo(_shortcutLabel.mas_left).offset(-8);
        make.height.equalTo(@1);
        make.width.equalTo(@100);
    }];
    
    _rightLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_rightLineImageView];
    [_rightLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabel.mas_centerY);
        make.left.equalTo(_shortcutLabel.mas_right).offset(8);
        make.height.equalTo(@1);
        make.width.equalTo(@100);
    }];
    
}
- (void)setupRelationImageViews
{
    
    _fartherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_dad"]];
    
    _fartherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/4 - 20, 180+CGRectGetHeight(_fartherImageView.frame)/2);
    [self addSingleTapGestureToImageView:_fartherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _fartherImageView.tag = 1001;
    [self.view addSubview:_fartherImageView];

    
    _motherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_mom"]];
    _motherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, 180+CGRectGetHeight(_motherImageView.frame)/2);
    [self addSingleTapGestureToImageView:_motherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _motherImageView.tag = 1002;
    
    [self.view addSubview:_motherImageView];
    
    
    _grandpaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_grandpa"]];
    _grandpaImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 3/4 + 20, 180+CGRectGetHeight(_grandpaImageView.frame)/2);
    [self addSingleTapGestureToImageView:_grandpaImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _grandpaImageView.tag = 1003;
    
    [self.view addSubview:_grandpaImageView];
    
    _grandmaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_grandma"]];
    _grandmaImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/4 - 20, 180+CGRectGetHeight(_grandmaImageView.frame)*3/2+30);
    [self addSingleTapGestureToImageView:_grandmaImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _grandmaImageView.tag = 1004;
    
    [self.view addSubview:_grandmaImageView];
    
    _uncleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_uncle"]];
    _uncleImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, 180+CGRectGetHeight(_uncleImageView.frame)*3/2 + 30);
    [self addSingleTapGestureToImageView:_uncleImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _uncleImageView.tag = 1005;
    [self.view addSubview:_uncleImageView];
    
    _auntImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_aunt"]];
    _auntImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 3/4 + 20, 180+CGRectGetHeight(_auntImageView.frame)*3/2 + 30);
    [self addSingleTapGestureToImageView:_auntImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _auntImageView.tag = 1006;
    [self.view addSubview:_auntImageView];
    
    _brotherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_brother"]];
    _brotherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/4 - 20, 180+CGRectGetHeight(_brotherImageView.frame)*5/2 + 30*2);
    [self addSingleTapGestureToImageView:_brotherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _brotherImageView.tag = 1007;
    [self.view addSubview:_brotherImageView];
    
    _sisterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_sister"]];
    _sisterImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, 180+CGRectGetHeight(_sisterImageView.frame)*5/2 + 30*2);
    [self addSingleTapGestureToImageView:_sisterImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _sisterImageView.tag = 1008;
    [self.view addSubview:_sisterImageView];
    
    
    _familyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_family_families"]];
    _familyImageView.size = _sisterImageView.size;
    _familyImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 3/4 + 20, 180+CGRectGetHeight(_familyImageView.frame)*5/2 + 30*2);
    [self addSingleTapGestureToImageView:_familyImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _familyImageView.tag = 1009;
    [self.view addSubview:_familyImageView];
    
    
    _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pitchon"]];
}

- (void)setupCurrentRelation:(NSString*)currentRelationShip
{
    NSInteger index = [_relationArray indexOfObject:currentRelationShip];
    
    if (index == NSNotFound)
    {

        [_selectedImageView removeFromSuperview];
    }
    else
    {
        UIView* currentImageView = [self.view viewWithTag:index+1001];
        
        [_selectedImageView removeFromSuperview];
        
        _selectedImageView.center = CGPointMake(currentImageView.center.x+25, currentImageView.center.y - 28);
        
        [self.view addSubview:_selectedImageView];
    }
    

    
}


-(void)addSingleTapGestureToImageView:(UIImageView*)imageview withTarget:(id)target andAction:(SEL)action
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [imageview addGestureRecognizer:singleTap];
    imageview.userInteractionEnabled = YES;
}

- (void)relationImageViewClick:(UITapGestureRecognizer*)sender
{
    UIImageView* clickImageView = (UIImageView*)sender.view;
    
    self.selectedRelation = _relationArray[clickImageView.tag - 1001];
    _customRelationTextFiled.text = self.selectedRelation;
    
    [_selectedImageView removeFromSuperview];
    
    _selectedImageView.center = CGPointMake(clickImageView.center.x+25, clickImageView.center.y - 28);
    
    [self.view addSubview:_selectedImageView];
}


//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)confirmClicked:(id)sender
{
    
    [_customRelationTextFiled resignFirstResponder];
    NSString*customRelation;
    if ([EHUtils isEmptyString:_customRelationTextFiled.text] && [EHUtils isEmptyString:self.selectedRelation])
    {
        customRelation = @"家人";
    }
    else
    {
        customRelation = [EHUtils trimmingHeadAndTailSpaceInstring:_customRelationTextFiled.text];
    }
    
    if ([customRelation length] > EHOtherNameLength) {
        [WeAppToast toast:(@"宝贝关系超过最大长度!")];
        return;
    }
    
    if (![EHUtils isValidString:customRelation]) {
        [WeAppToast toast:(@"宝贝关系不支持特殊字符!")];
        return;
    }
    
    if (![EHUtils isEmptyString:customRelation]) {
        self.selectedRelation = customRelation;
    }
    
    
    
    WEAKSELF
    
    self.updateBabyUserService = [EHUpdateBabyUserService new];
    
    self.updateBabyUserService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        //[WeAppToast toast:@"服务器访问成功"];
        EHLogInfo(@"服务器访问成功");
        if (!service.item) {
            EHLogError(@"EHBindingBabyRsp parser error!");
            return;
        }
        
        EHLogInfo(@"%@",service.item);
        
        if (strongSelf.modifyRelationSuccess)
        {
            strongSelf.modifyRelationSuccess(strongSelf.selectedRelation);
        }
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    // service 返回失败 block
    self.updateBabyUserService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        
        NSDictionary* userInfo = error.userInfo;
        [WeAppToast toast:[userInfo objectForKey:NSLocalizedDescriptionKey]];
    };
    
    EHBabyUser* babyUser = [EHBabyUser new];
    babyUser.baby_id = self.babyId;
    babyUser.user_id = [NSNumber numberWithInteger:[[KSAuthenticationCenter userId] integerValue]];
    babyUser.relationship = self.selectedRelation;
    babyUser.authority = self.authority;
    [self.updateBabyUserService updateBabyUser:babyUser];
    
    
}


- (void)relationTextFieldTextChanged:(NSNotification *)notification
{
    UITextField* textField = (UITextField*)[notification object];
    
    [self setupCurrentRelation:textField.text];
}



@end
