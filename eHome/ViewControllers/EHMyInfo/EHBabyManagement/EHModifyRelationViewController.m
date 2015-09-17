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
    KSInsetsTextField *_customRelationTextFiled;
    UILabel *_shortcutLabel;
    UIImageView* _fartherImageView;
    UIImageView* _motherImageView;
    UIImageView* _grandpaImageView;
    UIImageView* _grandmaImageView;
    UIImageView* _uncleImageView;
    UIImageView* _auntImageView;
    UIImageView* _brotherImageView;
    UIImageView* _sisterImageView;
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
    _relationArray = @[@"爸爸", @"妈妈", @"爷爷", @"奶奶", @"叔叔", @"阿姨", @"哥哥", @"姐姐"];
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
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

- (void)setupRelationImageViews
{
    self.view.backgroundColor = EH_bgcor1;
    
    _customRelationTextFiled = [[KSInsetsTextField alloc] initWithFrame:CGRectMake(0, RELATIONTEXTFIELD_Y_MARGIN, CGRectGetWidth([UIScreen mainScreen].bounds), RELATIONTEXTFIELDHEIGHT)];
    _customRelationTextFiled.backgroundColor = [UIColor whiteColor];
    
    UILabel* customPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RELATIONTEXTFIELD_LEFTVIEW_HEIGHT, RELATIONTEXTFIELDHEIGHT)];
    customPrompt.text = @"自定义";
    customPrompt.font = [UIFont systemFontOfSize:EH_siz3];
    customPrompt.textColor = EH_cor4;
    
    _customRelationTextFiled.leftView = customPrompt;
    _customRelationTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    _customRelationTextFiled.textAlignment = NSTextAlignmentRight;
    _customRelationTextFiled.text = self.currentRelationShip;
    
    _customRelationTextFiled.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, TEXTFIELD_INSETS);
    _customRelationTextFiled.leftViewEdgeInsets = UIEdgeInsetsMake(0, TEXTFIELD_INSETS, 0, 0);
    
    _customRelationTextFiled.font = [UIFont systemFontOfSize:EH_siz3];
    _customRelationTextFiled.textColor = EH_cor5;
    
    _customRelationTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_customRelationTextFiled];
    
    _shortcutLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHORTCUT_X_MARGIN, CGRectGetMaxY(_customRelationTextFiled.frame)+SHORTCUT_VERTIACAL_SPACE, SHORTCUT_WIDTH, SHORTCUT_HEIGHT)];
    _shortcutLabel.text = @"快捷设置";
    _shortcutLabel.font = [UIFont systemFontOfSize:EH_siz6];
    _shortcutLabel.textColor = EH_cor4;
    
    [self.view addSubview:_shortcutLabel];
    
    _fartherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_dad"]];
    
    _fartherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_fartherImageView.frame)/2);
    [self addSingleTapGestureToImageView:_fartherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _fartherImageView.tag = 1001;
    
    [self.view addSubview:_fartherImageView];
    
    _motherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_mom"]];
    _motherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 3/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_motherImageView.frame)/2);
    [self addSingleTapGestureToImageView:_motherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _motherImageView.tag = 1002;
    
    [self.view addSubview:_motherImageView];
    
    
    _grandpaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_grandpa"]];
    _grandpaImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 5/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_grandpaImageView.frame)/2);
    [self addSingleTapGestureToImageView:_grandpaImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _grandpaImageView.tag = 1003;
    
    [self.view addSubview:_grandpaImageView];
    
    _grandmaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_grandma"]];
    _grandmaImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 7/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_grandmaImageView.frame)/2);
    [self addSingleTapGestureToImageView:_grandmaImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    _grandmaImageView.tag = 1004;
    
    [self.view addSubview:_grandmaImageView];
    
    _uncleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_uncle"]];
    _uncleImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_uncleImageView.frame)*3/2 + IMAGEVIEW_VERTIACAL_SPACE_20);
    [self addSingleTapGestureToImageView:_uncleImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _uncleImageView.tag = 1005;
    [self.view addSubview:_uncleImageView];
    
    _auntImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_aunt"]];
    _auntImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 3/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_auntImageView.frame)*3/2 + IMAGEVIEW_VERTIACAL_SPACE_20);
    [self addSingleTapGestureToImageView:_auntImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _auntImageView.tag = 1006;
    [self.view addSubview:_auntImageView];
    
    _brotherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_brother"]];
    _brotherImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 5/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_brotherImageView.frame)*3/2 + IMAGEVIEW_VERTIACAL_SPACE_20);
    [self addSingleTapGestureToImageView:_brotherImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _brotherImageView.tag = 1007;
    [self.view addSubview:_brotherImageView];
    
    _sisterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_sister"]];
    _sisterImageView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 7/8, IMAGEVIEW_VERTIACAL_SPACE_40+CGRectGetMaxY(_customRelationTextFiled.frame)+CGRectGetHeight(_sisterImageView.frame)*3/2 + IMAGEVIEW_VERTIACAL_SPACE_20);
    [self addSingleTapGestureToImageView:_sisterImageView withTarget:self andAction:@selector(relationImageViewClick:)];
    
    _sisterImageView.tag = 1008;
    [self.view addSubview:_sisterImageView];
    
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
