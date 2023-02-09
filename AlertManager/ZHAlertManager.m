//
//  ZHAlertManager.m
//  community
//
//  Created by NO NAME on 2023/2/8.
//

#import "ZHAlertManager.h"

@interface ZHAlertManager ()

/// 所有展示中的alert栈 (先进后出,后进先出)
@property (nonatomic, strong) NSMutableArray <PPAlertController*> *alertStack;

/// 待展示alert队列, (先进先出,后进后出)
@property (nonatomic, strong) NSMutableArray <PPAlertController*> *waitAlertQueue;

/// 当前展示中的alert
@property (nonatomic, strong) PPAlertController *currentAlert;

/// 是否正在执行present
@property (nonatomic, assign) BOOL isPresenting;
/// 是否正在执行dismiss
@property (nonatomic, assign) BOOL isDismissing;

/// alert对应控制器
@property (nonatomic, strong) NSMutableDictionary <PPAlertController *, UIViewController *> *controlerDic;

/// alert对应的回调block
@property (nonatomic, strong) NSMutableDictionary <PPAlertController *, ZH_Completion> *completionDic;

@end

@implementation ZHAlertManager
KSINGLETON_FOR_CLASS(ZHAlertManager)

/// 展示栈中的alert数
- (NSString *)showCount {
    return [NSString stringWithFormat:@"%ld", self.alertStack.count];
}

/// 等待队列中的alert数
- (NSString *)waitCount {
    return [NSString stringWithFormat:@"%ld", self.waitAlertQueue.count];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alertStack = [NSMutableArray array];
        self.waitAlertQueue = [NSMutableArray array];
        self.currentAlert = nil;
        self.isPresenting = false;
        self.isDismissing = false;
        self.controlerDic = [NSMutableDictionary dictionary];
        self.completionDic = [NSMutableDictionary dictionary];
    }
    return self;
}

/// 添加并管理新弹框
- (void)addAlert:(PPAlertController *)alert controller:(UIViewController *)controller completion:(ZH_Completion)completion {
    // 1.记录一下alert对应的controller和回调
    self.controlerDic[alert] = controller;
    self.completionDic[alert] = completion;
    // 2.展示alert
    [self show:alert addToQueue:true completion:completion];
}

/// 移除弹框管理
- (void)pop {
    // 开始移除
    [self dismissTop:^{
        if (self.type == ZHAlertTypeReverse) {
            if (self.alertStack.count > 0) {
                PPAlertController *alert = self.alertStack.lastObject;
                [self.alertStack removeLastObject];
                [self.controlerDic removeObjectForKey:alert];
                [self.completionDic removeObjectForKey:alert];
                self.currentAlert = nil;
                if (self.popCompletionBlock) {
                    self.popCompletionBlock(alert);
                }
            }
            if (self.waitAlertQueue.count > 0) {
                [self showWait];
            } else if (self.alertStack.count > 0) {
                [self show:self.alertStack.lastObject addToQueue:false completion:nil];
            }
        } else {
            if (self.alertStack.count > 0) {
                PPAlertController *alert = self.alertStack.lastObject;
                [self.alertStack removeAllObjects];
                [self.controlerDic removeAllObjects];
                [self.completionDic removeAllObjects];
                self.currentAlert = nil;
                if (self.popCompletionBlock) {
                    self.popCompletionBlock(alert);
                }
            }
        }
    }];
}

/// 开始展示弹框
- (void)show:(PPAlertController *)alert addToQueue:(BOOL)addToQueue completion:(ZH_Completion)completion {
    // 1.判断当前是否处于动画中
    if (self.isPresenting || self.isDismissing) {
        // 1.1处于动画中,添加到等待队列中
        [self.waitAlertQueue appendObject:alert];
        return;
    }
    // 2.没有处于动画中, 隐藏顶层当前alert
    [self dismissTop:^{
        // 3.隐藏完毕, 开始展示最新alert
        self.isPresenting = true;
        self.currentAlert = alert;
        if (addToQueue) {
            [self.alertStack appendObject:alert];
        }
        [self.controlerDic[alert] presentViewController:alert animated:true completion:^{
            self.isPresenting = false;
            if (completion) {
                completion();
            }
            // 当前alert展示完成,去等待队列查看是否有最新的alert
            [self showWait];
        }];
    }];
}

/// 隐藏最顶部alert
- (void)dismissTop:(ZH_Completion)completion {
    if (!self.currentAlert) {
        // 当前没有展示中的alert, 直接走回调
        if (completion) {
            completion();
        }
        return;
    }
    // 隐藏当前展示的alert
    [self dismiss:self.currentAlert completion:completion];
}

/// 展示等待队列弹框
- (void)showWait {
    // 等待队列为空,直接return
    if (self.waitAlertQueue.count == 0) {
        return;
    }
    // 否则展示第一个
    PPAlertController *alert = self.waitAlertQueue.firstObject;
    ZH_Completion block = self.completionDic[alert];
    [self.waitAlertQueue removeFirstObject];
    [self show:alert addToQueue:true completion:block];
}

/// 隐藏弹框
- (void)dismiss:(PPAlertController *)alert completion:(ZH_Completion)completion {
    self.isDismissing = true;
    [self.controlerDic[alert] dismissViewControllerAnimated:true completion:^{
        self.isDismissing = false;
        if (completion) {
            completion();
        }
    }];
}
@end
