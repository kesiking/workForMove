//
//  EHNotificationConst.h
//  eHome
//
//  Created by louzhenhua on 15/7/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#ifndef eHome_EHNotificationConst_h
#define eHome_EHNotificationConst_h

//#define EHBindBabySuccessNotification @"EHBindBabySuccessNotification"             // 宝贝关注
//#define EHUNBindBabySuccessNotification @"EHUNBindBabySuccessNotification"         // 宝贝解绑
#define EHBabyListNeedChangeNotification @"EHBabyListNeedChangeNotification"             // 宝贝列表需要更新通知:绑定、解绑、宝贝信息变化时需要刷新列表，通知babylist data center更新
//#define EHBabyAuthorityChangedNotification @"EHBabyAuthorityChangedNotification"

#define EHCurrentSelectBabyChangedNotification @"EHCurrentSelectBabyChangedNotification" // 当前选中宝贝变化消息

// 宝贝列表更新完成通知，用于babylist更新完成后通知各个模块更新UI（若有需要）
#define EHBabyListChangedNotification @"EHBabyListChangedNotification"


#define EHGeofenceChangeNotification @"EHGeofenceChangeNotification"               // 围栏变化消息

#define EHRemoteMessageNotification @"EHRemoteMessageNotification"                 // 远程消息
#define EHClearRemoteMessageAttentionNotification @"EHClearRemoteMessageAttentionNotification"   // 取消小红点远程消息

// remote message category
#define EHBabyOutLineNotification @"EHBabyOutLineNotification"                      // 宝贝离线消息
#define EHBabyOnLineNotification  @"EHBabyOnLineNotification"                       // 宝贝在线消息
#define EHBabyLowBatteryNotification @"EHBabyLowBatteryNotification"                // 宝贝低电量消息
#define EHBabySOSMessageNotification @"EHBabySOSMessageNotification"                // 宝贝SOS消息
#define EHBabyLocationNotification @"EHBabyLocationNotification"                    // 宝贝位置消息

#define EHRecieveSelectedBabyChatMessageNotification  @"EHRecieveSelectedBabyChatMessageNotification"  // 收到当前选中的宝贝聊天消息
#define EHRecieveUnselectedBabyChatMessageNotification  @"EHRecieveUnselectedBabyChatMessageNotification"  // 收到未选中的宝贝聊天消息

#define EHXiaoXiHistoryChatMessageNotification  @"EHXiaoXiHistoryChatMessageNotification"  //小溪的历史消息

#define EHFORCE_REFRESH_DATA   @"__forceRefreshData__"
#define EHSELEC_BABY_ID_DATA   @"__selectBabyIdData__"
#define EHMESSAGE_BABY_ID_DATA @"__messageBabyIdData__"
#define EHBabyChatMessageModel_DATA   @"__babyChatMessageModelData__"


#endif
