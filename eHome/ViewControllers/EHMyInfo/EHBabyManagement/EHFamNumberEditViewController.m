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

#define kMaxChar 20


@interface EHFamNumberEditViewController ()<ABPeoplePickerNavigationControllerDelegate>
{

    
    EHAddBabyFamilyPhoneService *_addBabyFamilyPhoneService;
    EHDelBabyFamilyPhoneService *_delBabyFamilyPhoneService;
    
}
@property (nonatomic, strong) WeAppBasicFieldView       *userNickName;
@property (nonatomic, strong) WeAppBasicFieldView       *userPhone;
@property (nonatomic, strong) UIButton                  *btn_done;



@end

@implementation EHFamNumberEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self userNickName];
    [self userPhone];
    [self rightButton];

    
    

}

//创建右导航按钮

-(void)rightButton{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(editDone:)];
    //rightButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem=rightButtonItem;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void) addPhoneNumber{
    
    _addBabyFamilyPhoneService = [EHAddBabyFamilyPhoneService new];
    WEAKSELF
    _addBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^
    (WeAppBasicService *service) {
        STRONGSELF
        NSLog(@"serviceDidFinishLoadBlock...");
        NSString *name = strongSelf.userNickName.textView.text;
        NSString *familyphone = strongSelf.userPhone.textView.text;
        if (name.length == 0) {
            name = familyphone;
        }
        
        name = [EHUtils trimmingHeadAndTailSpaceInstring:name];
        if (name.length > EHPersonNameLength) {
            [WeAppToast toast:@"亲情号码昵称长度超过最大长度!"];
            return;
        }
        
        strongSelf.phoneModel.phone_name = name;
        strongSelf.phoneModel.attention_phone = familyphone;
        strongSelf.editBlock(strongSelf.phoneModel);
        [strongSelf.navigationController popViewControllerAnimated:YES];

        
    };
    _addBabyFamilyPhoneService.serviceDidFailLoadBlock = ^
    (WeAppBasicService *service,NSError *error){
        [WeAppToast toast:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        //[WeAppToast toast:@"编辑中添加失败"];
    };
    NSString *familyphone = self.userPhone.textView.text;
    NSString *name = self.userNickName.textView.text;
    if (name.length == 0) {
        name = familyphone;
    }
    
    [_addBabyFamilyPhoneService addBabyFamilyPhone:familyphone andPhoneName:name andPhoneType:self.phoneModel.phone_type byBabyId:self.babyId];


    
}

- (void) deletePhoneNumber
{
    _delBabyFamilyPhoneService = [EHDelBabyFamilyPhoneService new];
    WEAKSELF
    _delBabyFamilyPhoneService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service) {
        STRONGSELF
        strongSelf.phoneModel.phone_name = @"";
        strongSelf.phoneModel.attention_phone = @"";
        strongSelf.editBlock(strongSelf.phoneModel);
        [strongSelf.navigationController popViewControllerAnimated:YES];

    };
    
    _delBabyFamilyPhoneService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        [WeAppToast toast:@"编辑中删除失败"];
    };
    NSDictionary *delDict = @{kEHAttentionPhone:self.phoneModel.attention_phone, kEHPhoneType:[NSNumber numberWithInteger:[self.phoneModel.phone_type integerValue]]};
    NSArray *delArr = @[delDict];
    //[NSNumber numberWithInteger:[self.phoneModel.phone_type integerValue]]
    //NSArray *delArr =[[NSArray alloc]initWithObjects:delDict, nil];
    NSString *phone = [[KSLoginComponentItem sharedInstance] user_phone];
    [_delBabyFamilyPhoneService delBabyFamilyPhone:delArr andAdminPhone:phone byBabyId:self.babyId];
    
}



-(void)editDone:(id)sender{
    
    if (_userPhone.text.length==0&&_userNickName.text.length==0) {
        if (self.phoneModel.phone_name.length==0&&self.phoneModel.attention_phone.length==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self deletePhoneNumber];
        }
        
    }
    else if (![EHUtils isValidMobile:_userPhone.text]) {
        [WeAppToast toast:@"手机号码输入有误，请重新输入!"];
        
    }
    else{
        [self addPhoneNumber];
    }

}

        
//创建输入框
-(WeAppBasicFieldView *)userNickName{
    if(!_userNickName)
    {
        _userNickName= [WeAppBasicFieldView getCommonFieldView];
        _userNickName.textView.colorWhileEditing = EH_cor2;
        _userNickName.textView.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        //_userNickName.textView.clearButtonMode = UITextFieldViewModeNever;
        _userNickName.textView.placeholder = @"输入用户昵称";
        [_userNickName setFrame:CGRectMake(12, 12, self.view.width-24, 44)];
        _userNickName.textView.font = [UIFont systemFontOfSize:EHSiz2];
        _userNickName.textView.textColor = EHCor5;
        _userNickName.textView.clearButtonMode=UITextFieldViewModeNever;
        [_userNickName.textView becomeFirstResponder];
        
        UIImage *rightImgNormal = [UIImage imageNamed:@"icon_addressbook"];
      //  UIImage *rightImgPressed = [UIImage imageNamed:@"ico_contacts_qinqingdianhua_press"];
        
        //UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 21.5, 23, 23)];
        [rightBtn setImage:rightImgNormal forState:UIControlStateNormal];
    //    [rightBtn setImage:rightImgPressed forState:UIControlStateSelected];
        
        [rightBtn addTarget:self action:@selector(rightViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        _userNickName.textView.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);

        [self.view addSubview:_userNickName];
        [self.view addSubview:rightBtn];
        if (self.phoneModel.phone_name) {
            _userNickName.textView.text = self.phoneModel.phone_name;
            //rightBtn.hidden = YES;
            _userNickName.textView.clearButtonMode = UITextFieldViewModeNever;
        }
        else{
            //rightBtn.hidden = NO;
            _userNickName.textView.clearButtonMode = UITextFieldViewModeNever;
        }
        WEAKSELF
        _userNickName.textValueDidChanged = ^(UITextField* textView){
            STRONGSELF
            if (strongSelf.userNickName.textView.markedTextRange == nil && strongSelf.userNickName.textView.text.length> kMaxChar) {
                NSString *subString = [strongSelf.userNickName.textView.text substringToIndex:kMaxChar];
                strongSelf.userNickName.textView.text = subString;
                
            }
            
        };

    }
    return _userNickName;
}

-(WeAppBasicFieldView *)userPhone{
    if(!_userPhone)
    {
        _userPhone= [WeAppBasicFieldView getCommonFieldView];
        //_userPhone.textView.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _userPhone.textView.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        _userPhone.textView.colorWhileEditing = EH_cor2;
        [_userPhone setFrame:CGRectMake(12, 80, self.view.width-24, 44)];
        _userPhone.textView.font = [UIFont systemFontOfSize:EHSiz2];
        _userPhone.textView.textColor = EHCor5;
        _userPhone.textView.placeholder = @"输入用户手机号码";
        _userPhone.textView.keyboardType = UIKeyboardTypeNumberPad;
        _userPhone.textView.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        _userPhone.textView.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (self.phoneModel.attention_phone) {
            _userPhone.textView.text = self.phoneModel.attention_phone;
        }
        WEAKSELF
        _userPhone.textValueDidChanged = ^(UITextField* textView){
            STRONGSELF
//            if (strongSelf.phoneModel.attention_phone) {
//                if (strongSelf.userPhone.textView.text.length==0&&strongSelf.userNickName.textView.text.length>0) {
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
//                }
//                else{
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
//                    
//                }
//            }
//            else{
//                if (strongSelf.userPhone.textView.text.length==0) {
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
//                }
//                else{
//                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
//                }
//            }
        };
        
            [self.view addSubview:_userPhone];
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
    self.phoneModel.attention_phone = data.attention_phone;
    self.phoneModel.phone_name = data.phone_name;
    
    _userNickName.textView.text=data.phone_name;
    _userPhone.textView.text=data.attention_phone;
   self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"didSelectPerson1");
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
//    NSMutableString *muStr = [[NSMutableString alloc]init];
//    NSArray *arr = [str componentsSeparatedByString:@"-"];
//    for (NSString *s in arr) {
//        [muStr appendString:s];
//    }
//    return (NSString *)muStr;
    NSMutableString *muStr = [[NSMutableString alloc]init];
    NSArray *arr = [phone componentsSeparatedByString:@"-"];
    for (NSString *s in arr) {
        [muStr appendString:s];
    }
    NSString *newPhone = (NSString *)muStr;
    NSString *name = [NSString stringWithFormat:@"%@%@",lastName, firstName];
    EHBabyFamilyPhone *data = [EHBabyFamilyPhone new];
    data.phone_name = name;
    data.attention_phone = newPhone;
    WEAKSELF
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        STRONGSELF
        [strongSelf setContentToUI:data];
    }];
}



// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"didSelectPerson2");
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
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
    NSMutableString *muStr = [[NSMutableString alloc]init];
    NSArray *arr = [phone componentsSeparatedByString:@"-"];
    for (NSString *s in arr) {
        [muStr appendString:s];
    }
    NSString *newPhone = (NSString *)muStr;
    
    NSString *name = [NSString stringWithFormat:@"%@%@", lastName,firstName];
    EHBabyFamilyPhone *data = [EHBabyFamilyPhone new];
    data.phone_name = name;
    data.attention_phone = newPhone;

    
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
