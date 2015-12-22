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
static NSString * const kEHGetThisUserAllBabys = @"babyAction/getThisUserAllBabys.do";
static NSString * const kEHBindingBabyApiName = @"babyAction/BindingBaby.do";
static NSString * const kEHUnBindBabyApiName = @"babyAction/cancelBabyUser.do";
static NSString * const kEHAddBabyApiName = @"babyAction/addBaby.do";
static NSString * const kEHUpdateBabyApiName = @"babyAction//updateBaby.do";

static NSString * const kEHAddBabyUserApiName = @"babyAction/addBabyUser.do";
static NSString * const kEHUpdateBabyUserApiName = @"babyAction/updateBabyUser.do";

static NSString * const kEHTransferBabyManagerApiName = @"babyAction/transferBabeManager.do";
static NSString * const kEHInviteBabyUserApiName = @"babyAction/inviteUserAttentionBaby.do";
static NSString * const kEHDeleteBabyUserApiName = @"babyAction/deleteBabyUser.do";
static NSString * const kEHCancelBabyUserApiName = @"babyAction/cancelBabyUser.do";

static NSString * const kEHCheckRandomNumApiName = @"babyAction/checkRandomNum.do";

static NSString * const kEHSendRandomToManagerApiName = @"babyAction/getRandomNumAndSendBabyManager.do";

static NSString * const kEHGetThisBabyAllUsersApiName = @"babyAction/getThisBabyAllUsers.do";

static NSString * const kEHGetBabyFamilyPhoneApiName = @"babyAction/queryPhoneById.do";
static NSString * const kEHAddBabyFamilyPhoneApiName = @"babyAction/addDevicePhone.do";
static NSString * const kEHDeleteBabyFamilyPhoneApiName = @"babyAction/deleteDevicePhone.do";

static NSString * const kEHUpdateBabyDeviceSmsCardApiName = @"babyAction/updateBabyDeviceSmsCard.do";

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

static NSString * const kEHQueryBabyHealthyForDayApiName =@"babyHealthyAction/queryBabyHealthyForDay.do";


static NSString * const kEHInsertGeofenceApiName =@"geofenceAction/insertGeofence.do";
static NSString * const kEHUpdateGeofenceApiName =@"geofenceAction/updateGeofence.do";
static NSString * const kEHDeleteGeofenceApiName =@"geofenceAction/deleteGeofence.do";
static NSString * const kEHUpdateStatusSwitchByGeofenceIdApiName =@"geofenceAction/updateStatusSwitchByGeofenceId.do";
static NSString * const kEHQueryGeofenceForListApiName =@"geofenceAction/queryGeofenceForList.do";

static NSString * const kEHInsertGeofenceRemindApiName =@"geofenceRemindAction/insertGeofenceRemind.do";
static NSString * const kEHGetGeofenceRemindApiName =@"geofenceRemindAction/getGeofenceRemind.do";
static NSString * const kEHUpdateGeofenceRemindApiName =@"geofenceRemindAction/updateGeofenceRemind.do";
static NSString * const kEHDeleteGeofenceRemindApiName =@"geofenceRemindAction/deleteGeofenceRemind.do";

static NSString * const kEHGetHealthyWeekMonthInfoApiName = @"babyHealthyAction/queryHealthyHistory.do";

static NSString * const KEHSetLocationModeApiName=@"babyAction/setWorkMode.do";
static NSString * const kEHGetBabyDeviceStartUserDayApiName = @"babyHealthyAction/queryForFirstTime.do";


static NSString * const kEHAddBabyAlarmApiName = @"babyAction/addBabyClock.do";

static NSString * const kEHEditBabyAlarmApiName = @"babyAction/updateBabyClock.do";

static NSString * const kEHDeleteBabyAlarmApiName = @"babyAction/deleteBabyClock.do";

static NSString * const kEHGetBabyAlarmApiName = @"babyAction/getAllBabyClock.do";




static NSString * const kEHGetBabyManagerIsReadMsgApiName=@"babyAction/checkAdminIsReadMsg.do";

static NSString *const kEHGetBabyBindingStatusListApiName=@"babyAction/getBabyBindingStatusList.do";

static NSString *const KEHCheckBabyIsAgreeApiName=@"babyAction/checkBabyIsAgree.do";

static NSString *const KEHGetChatMessageListApiName = @"querySmallVoiceCallMsg.do";

static NSString *const KEHSendChatMessageApiName = @"addSmallVoiceCallMsg.do";

static NSString *const KEHUploadVoiceCallMsgMessageApiName =@"smallVoiceCallMsgUpload/uploadSmallVoiceCallMsg.do";

static NSString *const KEHGetUserSetting =@"terUserSettingAction/getUserSetting.do";
static NSString *const KEHSetUserSetting =@"terUserSettingAction/setUserSetting.do";

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
