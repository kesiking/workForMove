//
//  EMModifyRelationCommonViewController.m
//  eHome
//
//  Created by 钱秀娟 on 15/11/17.
//  Copyright © 2015年 com.cmcc. All rights reserved.
//

#import "EMModifyRelationCommonViewController.h"
#import "IQKeyboardManager.h"

@interface EMModifyRelationCommonViewController ()<UIScrollViewDelegate>
{
    UIImageView *_topBackgroundImageView;
    UIImageView *_communicationImageView;
    
    UIImageView *_headImageView;
    
    NSArray *_headImageArray;
    UIView *_secondBackgroundView;
 
    UILabel *_shortcutLabel;
    UIImageView *_leftLineImageView;
    UIImageView *_rightLineImageView;
    
    
    UILabel *_shortcutLabelTwo;
    UIImageView *_leftLineImageViewTwo;
    UIImageView *_rightLineImageViewTwo;
    
    UIImageView* _selectedImageView;
    
    NSArray* _relationArray;
    NSArray* _selectRelationArray;
    NSArray* _relationImageArray;


}


@property(nonatomic,strong)UIImageView *selectedItem;


@end

@implementation EMModifyRelationCommonViewController


-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EHCor1;
    // Do any additional setup after loading the view from its nib.
    self.title = @"我与宝贝的关系";
    _relationArray = @[@"爸爸", @"妈妈", @"爷爷", @"奶奶",@"外公",@"外婆",@"叔叔", @"阿姨",@"舅舅",@"舅妈", @"哥哥", @"姐姐",@"弟弟",@"妹妹", @"家人"];

    _selectRelationArray = @[@"ico_family_dad_p",@"ico_family_mom_p",@"ico_family_grandpa_p",@"ico_family_grandma_p",@"ico_family_grandpapa_p",@"ico_family_grandmama_p",@"ico_family_uncle_p",@"ico_family_aunt_p",@"ico_family_unclema_p",@"ico_family_auntma_p",@"ico_family_brother_p",@"ico_family_sister_p",@"ico_family_brothery_p",@"ico_family_sistery_p",@"ico_family_people_p"];
    
    _relationImageArray = @[@"ico_family_dad_n",@"ico_family_mom_n",@"ico_family_grandpa_n",@"ico_family_grandma_n",@"ico_family_grandpapa_n",@"ico_family_grandmama_n",@"ico_family_uncle_n",@"ico_family_aunt_n",@"ico_family_unclema_n",@"ico_family_auntma_n",@"ico_family_brother_n",@"ico_family_sister_n",@"ico_family_brothery_n",@"ico_family_sistery_n",@"ico_family_people_n"];
    
    
    _headImageArray = @[@"icon_dad160",@"icon_mom160",@"icon_grandpa160",@"icon_grandma160",@"icon_grandpa_pa160",@"icon_grandma_ma160",@"icon_uncle160",@"icon_aunt160",@"icon_uncle_m160",@"icon_aunt_m160",@"icon_brother160",@"icon_sister160",@"icon_brother_y160",@"icon_sister_y160",@"icon_family160"];
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClicked:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.view.backgroundColor = EHBgcor1;
    
    [self setupFirstCommunicatePreviewView];

    [self setupSecondView];
    [self setupCustomTextfield];
    
    [self setupCurrentRelation:self.currentRelationShip];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relationTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    //    NSInteger index = [_relationArray indexOfObject:self.currentRelationShip];
    //    if (index >= 5) {
    //        index = 5;
    //    }
    //    [self.relationScrollView
    //     setContentOffset:CGPointMake(
    //                                  CGRectGetWidth([UIScreen mainScreen].bounds)/4*index, 0)];
    //
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}

- (void)setupFirstCommunicatePreviewView{
      
    _communicationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_relationship"]];
    [self.view addSubview:_communicationImageView];
    [_communicationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,245*SCREEN_SCALE));
    }];

    
    _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_family160"]];
    [_communicationImageView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(74*SCREEN_SCALE);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80*SCREEN_SCALE,80*SCREEN_SCALE));
    }];
    
}

- (void)setupSecondView{
    _secondBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, 200*SCREEN_SCALE)];
    _secondBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_secondBackgroundView];
    [_secondBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_communicationImageView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(200*SCREEN_SCALE));
    }];
    [self setupShotcutPromptLabel];
    [self setupRelationImageViews];
}


- (void)setupCustomTextfield
{
    _shortcutLabelTwo = [[UILabel alloc] initWithFrame:CGRectZero];
    _shortcutLabelTwo.text = @"自定义输入";
    _shortcutLabelTwo.textAlignment = NSTextAlignmentCenter;
    _shortcutLabelTwo.font = EHFont2;
    _shortcutLabelTwo.textColor = EHCor3;
    [_shortcutLabelTwo sizeToFit];
    [self.view addSubview:_shortcutLabelTwo];
    [_shortcutLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_secondBackgroundView.mas_bottom).offset(25*SCREEN_SCALE);
    }];
    
    _leftLineImageViewTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_leftLineImageViewTwo];
    [_leftLineImageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabelTwo.mas_centerY);
        make.right.equalTo(_shortcutLabelTwo.mas_left).offset(-8*SCREEN_SCALE);
        make.height.equalTo(@1);
        make.width.equalTo(@(50*SCREEN_SCALE));
    }];
    
    _rightLineImageViewTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_rightLineImageViewTwo];
    [_rightLineImageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabelTwo.mas_centerY);
        make.left.equalTo(_shortcutLabelTwo.mas_right).offset(8*SCREEN_SCALE);
        make.height.equalTo(@1);
        make.width.equalTo(@(50*SCREEN_SCALE));
    }];

    _customRelationTextFiled = [[KSInsetsTextField alloc] initWithFrame:CGRectZero];
    _customRelationTextFiled.textAlignment = NSTextAlignmentCenter;
//    _customRelationTextFiled.text = self.currentRelationShip;
    _customRelationTextFiled.placeholder = @"自定义请输入";
//    [_customRelationTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    _customRelationTextFiled.font = EHFont2;
    _customRelationTextFiled.textColor = EHCor5;
    _customRelationTextFiled.backgroundColor = [UIColor whiteColor];
    _customRelationTextFiled.layer.borderColor= EHLinecor1.CGColor;
    _customRelationTextFiled.layer.borderWidth= .5f;
    _customRelationTextFiled.layer.cornerRadius=5.0f;
    _customRelationTextFiled.layer.masksToBounds=YES;
    
    _customRelationTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_customRelationTextFiled];
    [_customRelationTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shortcutLabelTwo.mas_bottom).offset(25*SCREEN_SCALE);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(37.5*SCREEN_SCALE);
        make.right.equalTo(self.view.mas_right).offset(-37.5*SCREEN_SCALE);
        make.height.equalTo(@(44*SCREEN_SCALE));
    }];
}

- (void)setupShotcutPromptLabel
{
    
    _shortcutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _shortcutLabel.text = @"快速选择";
    _shortcutLabel.textAlignment = NSTextAlignmentCenter;
    _shortcutLabel.font = EHFont2;
    _shortcutLabel.textColor = EHCor3;
    [_shortcutLabel sizeToFit];
    [self.view addSubview:_shortcutLabel];
    [_shortcutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_communicationImageView.mas_bottom).offset(25*SCREEN_SCALE);
    }];
    
    _leftLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_leftLineImageView];
    [_leftLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabel.mas_centerY);
        make.right.equalTo(_shortcutLabel.mas_left).offset(-8*SCREEN_SCALE);
        make.height.equalTo(@1);
        make.width.equalTo(@(50*SCREEN_SCALE));
    }];
    
    _rightLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_100"]];
    [self.view addSubview:_rightLineImageView];
    [_rightLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shortcutLabel.mas_centerY);
        make.left.equalTo(_shortcutLabel.mas_right).offset(8*SCREEN_SCALE);
        make.height.equalTo(@1);
        make.width.equalTo(@(50*SCREEN_SCALE));
    }];
    
}
- (void)setupRelationImageViews
{
    //添加滑动关系头像
    self.relationScrollView.contentSize = CGSizeMake(15*85*SCREEN_SCALE+15,70*SCREEN_SCALE);
    self.relationScrollView.showsHorizontalScrollIndicator = YES;
    self.relationScrollView.showsVerticalScrollIndicator = NO;
    //    self.relationScrollView.pagingEnabled = YES;
    [self.view addSubview:self.relationScrollView];
    //    self.relationScrollView.backgroundColor = [UIColor redColor];
    self.relationScrollView.delegate = self;
    //    self.relationScrollView.clipsToBounds = NO;
    //    self.healthScrollView.bounces = NO;
    
    [self.relationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shortcutLabel.mas_bottom).offset(40*SCREEN_SCALE);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80*SCREEN_SCALE));
    }];
    
    for (int i = 0; i<15; i++) {
        UIView *eachMemberBagView= [[UIView alloc]initWithFrame:CGRectMake(i*85*SCREEN_SCALE, 0.0, 85*SCREEN_SCALE, 70*SCREEN_SCALE)];
        
        UIImageView *eachMemberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 70*SCREEN_SCALE, 70*SCREEN_SCALE)];
        
        eachMemberImageView.image =[UIImage imageNamed:_relationImageArray[i]];
        [self addSingleTapGestureToImageView:eachMemberImageView withTarget:self andAction:@selector(relationImageViewClick:)];
        [eachMemberBagView addSubview:eachMemberImageView];
        [eachMemberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(eachMemberBagView.mas_top);
            make.left.equalTo(eachMemberBagView.mas_left).offset(15*SCREEN_SCALE);
            make.right.equalTo(eachMemberBagView.mas_right);
            make.bottom.equalTo(eachMemberBagView.mas_bottom);
            
        }];
        eachMemberImageView.tag = 1001+i;
        [self.relationScrollView addSubview:eachMemberBagView];

    }
 
//    //默认设置第一个选中的是第一个
//    _selectedItem = nil;
    
    _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_family_people_p"]];
    _selectedImageView.frame = CGRectMake(0.0, 0.0, 70*SCREEN_SCALE, 70*SCREEN_SCALE);
}



- (UIScrollView*)relationScrollView
{
    if (!_relationScrollView) {
        _relationScrollView = [[UIScrollView alloc]
                               initWithFrame:CGRectMake(0.0, 0.0,
                                                        CGRectGetWidth([UIScreen mainScreen].bounds),70*SCREEN_SCALE)];
    }
    return _relationScrollView;
}
- (void)setupCurrentRelation:(NSString*)currentRelationShip
{
    //添加选中头像
    NSInteger index = [_relationArray indexOfObject:currentRelationShip];
    
    if (index == NSNotFound)
    {
        
        [_selectedImageView removeFromSuperview];
        
        //最后一个
        UIView* currentImageView = [self.view viewWithTag:1015];
     
        _selectedImageView.image = [UIImage imageNamed:_selectRelationArray[currentImageView.tag - 1001]];
        
        _headImageView.image = [UIImage imageNamed:_headImageArray[currentImageView.tag - 1001]];
        
        
        _selectedImageView.center = CGPointMake(currentImageView.superview.center.x+7.5*SCREEN_SCALE, currentImageView.center.y);
        
        [self.relationScrollView addSubview:_selectedImageView];
    }
    else
    {
        UIView* currentImageView = [self.view viewWithTag:index+1001];
        
        UIView *clickView = currentImageView.superview;
        [_selectedImageView removeFromSuperview];
        _selectedImageView.image = [UIImage imageNamed:_selectRelationArray[currentImageView.tag - 1001]];
        
        _headImageView.image = [UIImage imageNamed:_headImageArray[currentImageView.tag - 1001]];
        _selectedImageView.center = CGPointMake(clickView.center.x+7.5*SCREEN_SCALE, clickView.center.y);

        [self.relationScrollView addSubview:_selectedImageView];
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
    [self.customRelationTextFiled resignFirstResponder];
    UIImageView* clickImageView = (UIImageView*)sender.view;
    
    UIView *clickView = sender.view.superview;
//    clickImageView.image = [UIImage imageNamed:_selectRelationArray[clickImageView.tag - 1001]];
    
    self.selectedRelation = _relationArray[clickImageView.tag - 1001];
    _customRelationTextFiled.text = @"";
    self.finalSelectedRelation = self.selectedRelation;
    [_selectedImageView removeFromSuperview];
    
    _selectedImageView.image = [UIImage imageNamed:_selectRelationArray[clickImageView.tag - 1001]];
    _headImageView.image = [UIImage imageNamed:_headImageArray[clickImageView.tag - 1001]];
    
    _selectedImageView.center = CGPointMake(clickView.center.x+7.5*SCREEN_SCALE, clickView.center.y);
    [self.relationScrollView addSubview:_selectedImageView];
    
    [self scrollToVisibleItem:clickImageView];
    self.selectedItem = clickImageView;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)scrollToVisibleItem:(UIImageView *)item {
    
//    NSInteger selectedItemIndex = self.selectedItem.tag - 1001;
//    NSInteger visibleItemIndex = item.tag - 1001;
//    UIView *fartherView = item.superview;
//    UIView *selectFartherView = _selectedItem.superview;
//    // If the selected item is same to the item to be visible, nothing to do
//    if (selectedItemIndex == visibleItemIndex) {
//        return;
//    }
//    
//    CGPoint offset = self.relationScrollView.contentOffset;
//    
//    // If the item to be visible is in the screen, nothing to do
//    if (CGRectGetMinX(fartherView.frame) >= offset.x && CGRectGetMaxX(fartherView.frame) <= (offset.x + CGRectGetWidth(self.relationScrollView.frame))) {
//        return;
//    }
//    
//    // Update the scrollView's contentOffset according to different situation
//    if (selectedItemIndex < visibleItemIndex) {
//        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
//        if (CGRectGetMaxX(selectFartherView.frame) < offset.x) {
//            offset.x = CGRectGetMinX(fartherView.frame);
//        } else {
//            offset.x = CGRectGetMaxX(fartherView.frame) - CGRectGetWidth(_relationScrollView.frame);
//        }
//    } else {
//        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
//        if (CGRectGetMinX(selectFartherView.frame) > (offset.x + CGRectGetWidth(_relationScrollView.frame))) {
//            offset.x = CGRectGetMaxX(fartherView.frame) - CGRectGetWidth(_relationScrollView.frame);
//        } else {
//            offset.x = CGRectGetMinX(fartherView.frame);
//        }
//    }
//    self.relationScrollView.contentOffset = offset;
}



//点击屏幕，让键盘弹回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)confirmClicked:(id)sender{
    
    
}

- (void)relationTextFieldTextChanged:(NSNotification *)notification
{
    UITextField* textField = (UITextField*)[notification object];
    self.finalSelectedRelation = textField.text;
    [self setupCurrentRelation:textField.text];
    if (textField.text.length!=0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;    
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
