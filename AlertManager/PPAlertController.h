//
//  PPAlertController.h
//  community
//
//  Created by NO NAME on 2023/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPAlertController : UIAlertController <NSCopying>

+ (PPAlertController *)zh_alertTwoButton:(NSString *)title text:(NSString *)text leftButtonText:(NSString *)leftButtonText rightButtonText:(NSString *)rightButtonText buttonBlock:(void(^)(int index))buttonBlock;

@end

NS_ASSUME_NONNULL_END
