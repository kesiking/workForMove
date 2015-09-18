//
//  EHInterfaceFieldConst.h
//  eHome
//
//  Created by louzhenhua on 15/6/12.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#ifndef eHome_EHInterfaceFieldConst_h
#define eHome_EHInterfaceFieldConst_h

#import <Foundation/Foundation.h>

// API name
static NSString * const kEHGetThisUserAllBabys = @"PersonSafeManagement/babyAction/getThisUserAllBabys.do";
static NSString * const kEHBindingBabyApiName = @"babyAction/BindingBaby.do";
static NSString * const kEHUnBindBabyApiName = @"babyAction/cancelBabyUser.do";
static NSString * const kEHAddBabyApiName = @"PersonSafeManagement/babyAction/addBaby.do";
static NSString * const kEHUpdateBabyApiName = @"PersonSafeManagement/babyAction//updateBaby.do";

static NSString * const kEHAddBabyUserApiName = @"PersonSafeManagement/babyAction/addBabyUser.do";
static NSString * const kEHUpdateBabyUserApiName = @"PersonSafeManagement/babyAction/updateBabyUser.do";

static NSString * const kEHTransferBabyManagerApiName = @"PersonSafeManagement/babyAction/transferBabeManager.do";
static NSString * const kEHInviteBabyUserApiName = @"PersonSafeManagement/babyAction/inviteUserAttentionBaby.do";
static NSString * const kEHDeleteBabyUserApiName = @"PersonSafeManagement/babyAction/deleteBabyUser.do";
static NSString * const kEHCancelBabyUserApiName = @"PersonSafeManagement/babyAction/cancelBabyUser.do";

static NSString * const kEHCheckRandomNumApiName = @"PersonSafeManagement/babyAction/checkRandomNum.do";

static NSString * const kEHSendRandomToManagerApiName = @"PersonSafeManagement/babyAction/getRandomNumAndSendBabyManager.do";

static NSString * const kEHGetThisBabyAllUsersApiName = @"PersonSafeManagement/babyAction/getThisBabyAllUsers.do";

static NSString * const kEHGetBabyFamilyPhoneApiName = @"PersonSafeManagement/babyAction/queryPhoneById.do";
static NSString * const kEHAddBabyFamilyPhoneApiName = @"PersonSafeManagement/babyAction/addDevicePhone.do";
static NSString * const kEHDeleteBabyFamilyPhoneApiName = @"PersonSafeManagement/babyAction/deleteDevicePhone.do";

static NSString * const kEHGetMessageInfoListApiName  =  @"MessageAction/queryMessage.do";

static NSString * const kEHSOSMessageSendApiName = @"messageAction/sosForHelp.do";

static NSString * const kEHUploadUserPicApiName = @"terUserPictureAction/upLoadUserPicture.do";

static NSString * const kEHModifyUserInfoApiName = @"terUserAction/changeUserInfo.do";

static NSString * const kEHAddUserFeedBackApiName = @"feedBackAction/addClientUserFeedBack.do";

static NSString * const kEHInsertSuggestionApiName = @"suggestionAction/insertSuggestion.do";

static NSString * const kEHQueryForFeedbackApiName = @"suggestionAction/queryForFeedback.do";

static NSString * const kEHLocationTraceHistoryApiName = @"positionAction/getTraceHistory.do";

static NSString * const kEHUpdateMessageNumberApiName = @"terUserAction/updateMessageNumberByUserPhone.do";

static NSString * const kEHQueryForMessageNumberApiName = @"MessageAction/queryForTopMessage.do";//查询返回宝贝电量、状态等信息

static NSString * const kEHQueryBabyHealthyForDayApiName =@"PersonSafeManagement/babyHealthyAction/queryBabyHealthyForDay.do";


static NSString * const kEHInsertGeofenceApiName =@"geofenceAction/insertGeofence.do";
static NSString * const kEHUpdateGeofenceApiName =@"geofenceAction/updateGeofence.do";
static NSString * const kEHDeleteGeofenceApiName =@"geofenceAction/deleteGeofence.do";
static NSString * const kEHUpdateStatusSwitchByGeofenceIdApiName =@"geofenceAction/updateStatusSwitchByGeofenceId.do";
static NSString * const kEHQueryGeofenceForListApiName =@"geofenceAction/queryGeofenceForList.do";

static NSString * const kEHInsertGeofenceRemindApiName =@"geofenceRemindAction/insertGeofenceRemind.do";
static NSString * const kEHGetGeofenceRemindApiName =@"geofenceRemindAction/getGeofenceRemind.do";
static NSString * const kEHUpdateGeofenceRemindApiName =@"geofenceRemindAction/updateGeofenceRemind.do";
static NSString * const kEHDeleteGeofenceRemindApiName =@"geofenceRemindAction/deleteGeofenceRemind.do";

static NSString * const kEHGetHealthyWeekMonthInfoApiName = @"PersonSafeManagement/babyHealthyAction/queryHealthyHistory.do";

static NSString * const KEHSetLocationModeApiName=@"http://192.168.8.55:8080/PersonSafeManagement/babyAction/setWorkMode.do";
static NSString * const kEHGetBabyDeviceStartUserDayApiName = @"babyHealthyAction/queryForFirstTime.do";


static NSString * const kEHAddBabyAlarmApiName = @"PersonSafeManagement/babyAction/addBabyClock.do";

static NSString * const kEHEditBabyAlarmApiName = @"PersonSafeManagement/babyAction/updateBabyClock.do";

static NSString * const kEHDeleteBabyAlarmApiName = @"PersonSafeManagement/babyAction/deleteBabyClock.do";

static NSString * const kEHGetBabyAlarmApiName = @"PersonSafeManagement/babyAction/getAllBabyClock.do";




static NSString * const kEHGetBabyManagerIsReadMsgApiName=@"PersonSafeManagement/babyAction/checkAdminIsReadMsg.do";

static NSString *const kEHGetBabyBindingStatusListApiName=@"PersonSafeManagement/babyAction/getBabyBindingStatusList.do";

static NSString *const KEHCheckBabyIsAgreeApiName=@"PersonSafeManagement/babyAction/checkBabyIsAgree.do";

static NSString *const KEHGetChatMessageListApiName = @"PersonSafeManagement/babyAction/checkBabyIsAgree.do";

// 请求、响应字段名
static NSString * const kEHOutputMsg    = @"outPut_msg";
static NSString * const kEHOutputTime    = @"outPut_time";
static NSString * const kEHOutputStatus    = @"outPut_status";
static NSString * const kEHResponseData    = @"responseData";
static NSString * const kEHResponseError    = @"responseError";

static NSString * const kEHUserPhone    = @"user_phone";
static NSString * const kEHBabyId    = @"baby_id";
static NSString * const kEHGardianPhone    = @"gardian_phone";
static NSString * const kEHUserId    = @"user_id";
static NSString * const kEHSecurityCode    = @"securityCode";
static NSString * const kEHBabyName    = @"baby_name";
static NSString * const kEHHealthyDate = @"date";
static NSString * const kEHAttentionPhone = @"attention_phone";
static NSString * const kEHPhoneName = @"phone_name";
static NSString * const kEHPhoneType = @"phone_type";
static NSString * const kEHFamilyPhoneList = @"mapList";
static NSString * const kEHBabyAlarmId = @"id";
static NSString * const kEHBabyAlarmList = @"mapList";





#endif
