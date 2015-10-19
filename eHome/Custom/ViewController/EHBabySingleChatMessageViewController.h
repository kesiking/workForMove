//
//  EHBabySingleChatMessageViewController.h
//  eHome
//
//  Created by 孟希羲 on 15/9/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "XHMessageTableViewController.h"

/*!
 *  @author 孟希羲, 15-10-08 09:10:53
 *  
 *  备注：特别说明！！！
 *  从后台启动到前台或是应用重启时，可能面临数据丢失情况：
 *     启动后没有同步拉取历史聊天数据，如果此时刚好收到新的消息，那么新的消息与老消息中间的历史聊天数据将丢失。
 *
 *  解决方案如下：（依次从难到易）  目前采用最简单的方案一！
 *  方案一  接收到小溪的消息时，如果判定是当前正在聊天的宝贝才接受insert操作，否则都不更新数据库，避免漏掉聊天数据 
 *     优点：操作简单
 *     缺点：最耗流量，很多消息数据都将被作废
 *
 *  方案二  每次后台进入应用是应用重启时就同步拉一次数据，并将更新聊天数据与宝贝id同时发出，由消息接受页面根据babyid处理，应用使用中不再拉取数据，依靠小溪的消息推送。
 *     优点：操作相对方案一复制一些，每次进入应用登录后就需要同步聊天数据
 *     缺点：历史消息数据部分被废弃，部分耗流量，登录后拉取的数据比较多
 *
 *  方案三  不做拉取，只利用小溪的消息推送完成，为优化性能需要建立数据池，如5秒内将推送消息放到babyid对应的数组中，5秒后将所有接收在数据池中的数据与宝贝id同时发出，由消息接受页面根据babyid处理。
 *     优点：最节省流量
 *     缺点：操作相对最复杂，操作不得当会有性能问题及数据丢失问题
 *
 *
 */

@interface EHBabySingleChatMessageViewController : XHMessageTableViewController

@property (nonatomic, strong) EHGetBabyListRsp *             babyUserInfo;

@property (nonatomic, strong) KSLoginComponentItem *         userInfoComponentItem;

@end
