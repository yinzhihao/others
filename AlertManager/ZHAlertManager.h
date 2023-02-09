//
//  ZHAlertManager.h
//  community
//
//  Created by NO NAME on 2023/2/8.
//

//当需要同时弹出多个系统弹窗，有两种处理方式
//1.仿照系统权限弹窗，处理完一个再处理前一个，2.最终只展示队列最后一个

#import <Foundation/Foundation.h>
#import "PPAlertController.h"

typedef void(^ZH_Completion)(void);
typedef void(^ZH_PopCompletion)(PPAlertController * _Nullable alert);

typedef NS_ENUM(NSUInteger, ZHAlertType) {
//    ZHAlertTypeSequence, //正序一个个展示，第一个消失后展示第二个
    ZHAlertTypeReverse, //倒序一个个展示
    ZHAlertTypeOnlyOne, //最终只展示队列最后一个
};


NS_ASSUME_NONNULL_BEGIN

@interface ZHAlertManager : NSObject
KSINGLETON_FOR_HEADER(ZHAlertManager)

/// alert出栈后的回调
@property (nonatomic, copy) ZH_PopCompletion popCompletionBlock;

@property (nonatomic, assign) ZHAlertType type;

/// 添加并管理新弹框
- (void)addAlert:(PPAlertController *)alert controller:(UIViewController *)controller completion:(ZH_Completion)completion;

/// 移除弹框管理
- (void)pop;

@end

NS_ASSUME_NONNULL_END
