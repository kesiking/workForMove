//
//  EHFamNumberEditViewController.m
//  eHome
//
//  Created by jinmiao on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHFamNumberEditViewController.h"
#import "WeAppBasicFieldView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EHAddBabyFamilyPhoneService.h"
#import "EHDelBabyFamilyPhoneService.h"
#import "EHUtils.h"
#import "EdgeInsetUILabel.h"
#import "EHFamilyNumberSelectRelectionViewController.h"
#define kMaxChar 20


@interface EHFamNumberEditViewController ()<ABPeoplePickerNavigationControllerDelegate>
{

    
    EHAddBabyFamilyPhoneService *_addBabyFamilyPhoneService;
    EHDelBabyFamilyPhoneService *_delBabyFamilyPhoneService;
    NSArray* _relationArray;
    NSArray* _headImageArray;

    
}
@property (nonatomic, strong) EdgeInsetUILabel                   *nickNameLabel;
@property (nonatomic, strong) WeAppBasicFieldView       *userPhone;
@property (nonatomic, strong) UIButton                  *btn_done;
@property (nonatomic, strong) NSMutableString                  *nickName;
@property (nonatomic, strong) UIImageView               *headImage;
@property (nonatomic, strong) UIImageView               *arrow;


@end

@implementation EHFamNumberEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _relationArray = @[@"爸爸", @"妈妈", @"爷爷", @"奶奶",@"外公",@"外婆",@"叔叔", @"阿姨",@"舅舅",@"舅妈", @"哥哥", @"姐姐",@"弟弟",@"妹妹", @"家人"];
    
   _headImageArray = @[@"icon_dad160",@"icon_mom160",@"icon_grandpa160",@"icon_grandma160",@"icon_grandpa_pa160",@"icon_grandma_ma160",@"icon_uncle160",@"icon_aunt160",@"icon_uncle_m160",@"icon_aunt_m160",@"icon_brother160",@"icon_sister160",@"icon_brother_y160",@"icon_sister_y160",@"icon_family160"];
    
    
    [self headImage];
    // [self selectRelationBtn];
    [self nickNameLabel];
    [self userPhone];

    [self rightButton];
    [self addConstrints];
    self.view.backgroundColor=EHBgcor1;
    self.nickName=[NSMutableString string];
    
    [self setUpHeadImage];

}


-(void)setUpHeadImage{
    if ( [EHUtils isEmptyString: self.relationShip]) {
        NSInteger index=[_relationArray indexOfObject:@"家人"];
        _headImage.image=[UIImage imageNamed:[_headImageArray objectAtIndex:index]];
    }else{
        NSInteger index=[_relationArray indexOfObject:self.relationShip];
        if (index==NSNotFound) {
            _headImage.image=[UIImage imageNamed:[_headImageArray lastObject]];
        }else{
            _headImage.image=[UIImage imageNamed:[_headImageArray objectAtIndex:index]];
        }
    }
    if (![EHUtils isEmptyString:self.relationShip]) {
        _nickNameLabel.text=self.relationShip;
    }
}

-(void)addConstrints{
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    
//    [_selectRelationBtn mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.view.mas_top).with.offset(110);
//        make.left.equalTo(self.view.mas_left).with.offset(12);
//        make.right.equalTo(self.view.mas_right).with.offset(-12);
//        make.height.mas_equalTo(44);
//    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(110);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
        make.height.mas_equalTo(44);
    }];

    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.nickNameLabel.mas_top).with.offset(16);
        make.right.equalTo(self.nickNameLabel.mas_right).with.offset(-12);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
    
    
    [_userPhone mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-12);
        make.height.mas_equalTo(44);
    }];
        
    


}

//创建右导航按钮

-(void)rightButton{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(editDone:)];
    //rightButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem=rightButtonItem;
    if( [EHUtils isEmptyString: _userPhone.text]||[ EHUtils isEmptyString:self.relationShip]){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void) addPhoneNumber{
    
    _addBabyFamilyPhoneService = [EHAddBabyFamilyPhoneService new];
    WEAKSELF
    _addBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^
    (WeAppBasicService *service) {
        STRONGSELF
        NSLog(@"serviceDidFinishLoadBlock...");
        NSString *familyphone = strongSelf.userPhone.textView.text;
        NSString *name = strongSelf.nickNameLabel.text;
        
        name = [EHUtils trimmingHeadAndTailSpaceInstring:name];
        if (name.length > EHPersonNameLength) {
            [WeAppToast toast:@"亲情号码昵称长度超过最大长度!"];
            return;
        }    
        strongSelf.phoneModel.relationship =strongSelf.nickName ;
        strongSelf.phoneModel.phoneNumber = familyphone;
        strongSelf.editBlock(strongSelf.phoneModel);
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    };
    _addBabyFamilyPhoneService.serviceDidFailLoadBlock = ^
    (WeAppBasicService *service,NSError *error){
        [WeAppToast toast:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        //[WeAppToast toast:@"编辑中添加失败"];
    };
    NSString *familyphone = self.userPhone.textView.text;
    NSString *name = self.nickNameLabel.text;
    NSInteger index = self.phoneModel.index;
    
    [_addBabyFamilyPhoneService addBabyFamilyPhone:familyphone andRelationship:name andindex:[NSNumber numberWithInteger:index] byBabyId:self.babyId];


    
}

- (void) deletePhoneNumber
{
    _delBabyFamilyPhoneService = [EHDelBabyFamilyPhoneService new];
    WEAKSELF
    _delBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
        STRONGSELF
        strongSelf.phoneModel.relationship = @"";
        strongSelf.phoneModel.phoneNumber = @"";
        strongSelf.editBlock(strongSelf.phoneModel);
        [strongSelf.navigationController popViewControllerAnimated:YES];

    };
    
    _delBabyFamilyPhoneService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"编辑中删除失败"];
    };
    NSDictionary *delDict = @{@"phoneNumber":self.phoneModel.phoneNumber, @"index":[NSNumber numberWithInteger:self.phoneModel.index]};
    NSArray *delArr = @[delDict];
    //[NSNumber numberWithInteger:[self.phoneModel.phone_type integerValue]]
    //NSArray *delArr =[[NSArray alloc]initWithObjects:delDict, nil];
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    [_delBabyFamilyPhoneService delBabyFamilyPhone:delArr andAdminPhone:phone byBabyId:self.babyId];
    
}



-(void)editDone:(id)sender{
    
//    if (_userPhone.text.length==0&& [EHUtils isEmptyString:self.nickName] ) {
//        if (self.phoneModel.phone_name.length==0&&self.phoneModel.attention_phone.length==0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else{
//            [self deletePhoneNumber];
//        }
//        
//    }
    if (![EHUtils isValidMobile:_userPhone.text]) {
        [WeAppToast toast:@"您输入的手机号码格式有误，请重新输入!"]; 
    }
    else
    {
        [self addPhoneNumber];
    }

}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel=[[EdgeInsetUILabel alloc]initWithFrame:CGRectMake(12, 110, CGRectGetWidth(self.view.frame)-24, 44)];
        _nickNameLabel.text=@"设定与宝贝的关系";
        
        _nickNameLabel.layer.borderColor = RGB(202, 202, 202).CGColor;
        _nickNameLabel.layer.borderWidth = 0.5;
        _nickNameLabel.layer.cornerRadius = 4;
        _nickNameLabel.layer.masksToBounds = YES;
        _nickNameLabel.textColor=EHCor5;
        _nickNameLabel.textAlignment=NSTextAlignmentLeft;
        _nickNameLabel.font=EH_font2;
        
        _nickNameLabel.backgroundColor=[UIColor whiteColor];
        UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectRelation)];
        [self.nickNameLabel addGestureRecognizer:gestureRecognizer];
        self.nickNameLabel.userInteractionEnabled = YES;
        
        
        _arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_icon_arrow"]];
        [_nickNameLabel addSubview:_arrow];

        [self.view addSubview:_nickNameLabel];
        
    }
    return _nickNameLabel;
}


-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_family160"]];
        [self.view addSubview:_headImage];
    }
    return _headImage;
}


-(void)selectRelation{
    EHFamilyNumberSelectRelectionViewController  * selectRelationViewController=[[EHFamilyNumberSelectRelectionViewController alloc]init];
    selectRelationViewController.title=@"选择关系";
    WEAKSELF
    selectRelationViewController.selectRelationBlock=^(NSString *relationship){
        STRONGSELF
        NSInteger index=[_relationArray indexOfObject:relationship];

        if (index==NSNotFound) {
            _headImage.image=[UIImage imageNamed:[_headImageArray lastObject]];
        }else{
            _headImage.image=[UIImage imageNamed:[_headImageArray objectAtIndex:index]];
        }
        
        [strongSelf.nickNameLabel setText:relationship];
        strongSelf.relationShip=relationship;
        if (![EHUtils isEmptyString: self.userPhone.text]) {
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }
    };
    [self.navigationController pushViewController:selectRelationViewController animated:YES];

}


-(WeAppBasicFieldView *)userPhone{
    if(!_userPhone)
    {
        _userPhone= [WeAppBasicFieldView getCommonFieldView];
        //_userPhone.textView.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _userPhone.textView.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//        _userPhone.textView.colorWhileEditing = EH_cor2;
        [_userPhone setFrame:CGRectMake(12, 166, self.view.width-24, 44)];
        _userPhone.textView.font = [UIFont systemFontOfSize:EHSiz2];
        _userPhone.textView.textColor = EHCor5;
        _userPhone.textView.placeholder = @"输入用户手机号码";
        _userPhone.textView.keyboardType = UIKeyboardTypeNumberPad;
        _userPhone.textView.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        _userPhone.textView.clearButtonMode = UITextFieldViewModeNever;
        if (self.phoneModel.phoneNumber) {
            _userPhone.textView.text = self.phoneModel.phoneNumber;
        }
        WEAKSELF
        _userPhone.textValueDidChanged = ^(UITextField* textView){
            STRONGSELF
//            if (strongSelf.phoneModel.attention_phone) {
//                if (strongSelf.userPhone.textView.text.length==0||[EHUtils isEmptyString:self.relationShip]) {
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
//                }
//                else{
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
//                    
//                }
//            }
//            else{
                if (strongSelf.userPhone.textView.text.length==0||[EHUtils isEmptyString:self.relationShip]) {
                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
                }
                else{
                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
                }
           // }
        };
        
            [self.view addSubview:_userPhone];
        
        
        UIImage *rightImgNormal = [UIImage imageNamed:@"icon_addressbook"];
        //  UIImage *rightImgPressed = [UIImage imageNamed:@"ico_contacts_qinqingdianhua_press"];
        
        //UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(_userPhone.right-12-23, _userPhone.top+11.5, 23, 23)];
        [rightBtn setImage:rightImgNormal forState:UIControlStateNormal];
        //    [rightBtn setImage:rightImgPressed forState:UIControlStateSelected];
        
        [rightBtn addTarget:self action:@selector(rightViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightBtn];
    }
    return _userPhone;
}


-(void)rightViewBtn:(id)sender
{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}

- (void)setContentToUI:(EHBabyFamilyPhone *)data
{
    self.phoneModel.phoneNumber = data.phoneNumber;
 //   self.phoneModel.relationship = data.relationship;
    
    _userPhone.textView.text=data.phoneNumber;
    if (   ![EHUtils isEmptyString:self.relationShip]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }    
}

// Called after a person has been selected by the user.
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
//{
//    NSLog(@"didSelectPerson1");
//    
//
//}



// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    if(property !=kABPersonPhoneProperty){
        [WeAppToast toast:@"请选择手机号码"];
        return;
    }
    NSLog(@"didSelectPerson2");
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
   // NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
 //   for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, identifier);
//        [phones addObject:aPhone];
//    }
    CFRelease(phoneMulti);
 //   NSString *phone = @"";
//    if (phones.count > 0) {
//        phone = [phones objectAtIndex:0];
//    }
   
    NSMutableString *muStr = [[NSMutableString alloc]init];
    NSArray *arr = [aPhone componentsSeparatedByString:@"-"];
    for (NSString *s in arr) {
        [muStr appendString:s];
    }
    NSString *newPhone = (NSString *)muStr;
    NSString *name = [NSString stringWithFormat:@"%@%@",lastName, firstName];
    EHBabyFamilyPhone *data = [EHBabyFamilyPhone new];
    data.relationship = name;
    data.phoneNumber = newPhone;
    WEAKSELF
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        STRONGSELF
        [strongSelf setContentToUI:data];
    }];
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"peoplePickerNavigationControllerDidCancel");
}


// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}

// Deprecated, use predicateForSelectionOfProperty and/or -peoplePickerNavigationController:didSelectPerson:property:identifier: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    if(property !=kABPersonPhoneProperty){
        [WeAppToast toast:@"请选择手机号码"];
        return NO;
    }
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
//    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, identifier);
//        [phones addObject:aPhone];
//    }
    CFRelease(phoneMulti);
 //   NSString *phone = @"";
//    if (phones.count > 0) {
//        phone = [phones objectAtIndex:0];
//    }
    NSMutableString *muStr = [[NSMutableString alloc]init];
    NSArray *arr = [aPhone componentsSeparatedByString:@"-"];
    for (NSString *s in arr) {
        [muStr appendString:s];
    }
    NSString *newPhone = (NSString *)muStr;
    
    NSString *name = [NSString stringWithFormat:@"%@%@", lastName,firstName];
    EHBabyFamilyPhone *data = [EHBabyFamilyPhone new];
    data.relationship = name;
    data.phoneNumber = newPhone;

    
    WEAKSELF
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        STRONGSELF
        [strongSelf setContentToUI:data];
    }];

    
    // 不执行默认的操作，如，打电话  
    return NO;  }









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EHBabyFamilyPhone *)phoneModel
{
    if (_phoneModel == nil) {
        _phoneModel = [EHBabyFamilyPhone new];
    }
    return _phoneModel;
}


@end
