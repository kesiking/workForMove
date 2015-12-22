//
//  KSTouchEvent.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/20.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSTouchEvent.h"
#import "UIButton+KSTouchEvent.h"
#import <objc/runtime.h>

@implementation KSTouchEvent

static BOOL _needTouchEventLog = NO;

static inline void eh_touch_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eh_touch_swizzleSelector([UITableViewCell class], @selector(setSelected:animated:), @selector(KSSetSelected:animated:));
        eh_touch_swizzleSelector([UICollectionViewCell class], @selector(setSelected:), @selector(KSSetSelected:));
        eh_touch_swizzleSelector([UIGestureRecognizer class], @selector(_updateGestureWithEvent:buttonEvent:), @selector(KSUpdateGestureWithEvent:buttonEvent:));
        [self setNeedTouchEventLog:YES];
    });
}

+(void)setNeedTouchEventLog:(BOOL)needTouchEventLog{
    _needTouchEventLog = needTouchEventLog;
}

+(void)touchWithView:(UIView*)view{
    if (view == nil) {
        return;
    }
    [self touchWithView:view eventAttributes:view.ks_eventAttributes];
}

+(void)touchWithView:(UIView*)view eventAttributes:(NSDictionary*)eventAttributes{
    if (view == nil) {
        return;
    }
    if (!_needTouchEventLog) {
        return;
    }
    if (view.ks_notNeedEventLog) {
        return;
    }
    NSDate* currentDate = [NSDate date];
    NSString* instanseName = nil;
    NSString* actionForTarget = nil;
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl* control = (UIControl*)view;
        NSSet* sets = [control allTargets];
        id target = [sets anyObject];
        if (target) {
            instanseName = [self getInstanseNameWithInstanse:view target:target];
            NSArray* actions = [control actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            if ([actions count] > 0) {
                actionForTarget = [actions firstObject];
            }
        }
    }
    NSMutableDictionary* mutableEventAttributes = eventAttributes ? [eventAttributes mutableCopy] : [NSMutableDictionary dictionary];
    if (instanseName) {
        [mutableEventAttributes setObject:instanseName forKey:@"instanseName"];
    }
    if (actionForTarget) {
        [mutableEventAttributes setObject:actionForTarget forKey:@"actionForTarget"];
    }
    NSString* vcName = view.viewController ? NSStringFromClass([view.viewController class]) : @"UIViewController";
    EHLogInfo(@"\n ----> touch in %@, eventName is %@,\nit's viewController name is %@, at time %@ \n eventAttributes:  %@" ,[view class], view.ks_eventName?:(actionForTarget?:@"touch"),vcName, currentDate, mutableEventAttributes);
}

+(NSString*)getInstanseNameWithInstanse:(id)instanse target:(id)target{
    if (target == nil || instanse == nil) {
        return nil;
    }
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([target class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(target, thisIvar) == instanse)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}

@end
