//
//  PPAlertController.m
//  community
//
//  Created by NO NAME on 2023/2/8.
//

#import "PPAlertController.h"
#import "ZHAlertManager.h"

@interface PPAlertController ()

@end

@implementation PPAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

+ (PPAlertController *)zh_alertTwoButton:(NSString *)title text:(NSString *)text leftButtonText:(NSString *)leftButtonText rightButtonText:(NSString *)rightButtonText buttonBlock:(void(^)(int))buttonBlock {
    PPAlertController *alertController = [PPAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZHAlertManager.sharedZHAlertManager pop];
        if (buttonBlock) buttonBlock(0);
    }];
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZHAlertManager.sharedZHAlertManager pop];
        if (buttonBlock) buttonBlock(1);
    }];
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    return alertController;
}

- (void)zh_presentedBy:(UIViewController *)controller completion:(void(^)(void))completion {
    [ZHAlertManager.sharedZHAlertManager addAlert:self controller:controller completion:completion];
}

@end
