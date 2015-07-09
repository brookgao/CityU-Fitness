//
//  CTLoginViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/1.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTLoginViewController.h"

#import "AFNetworking.h"
#import "HTMLReader.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

#import "CTHTTPRequestOperationManager.h"
#import "CTUser.h"
#import "CTSaveTool.h"

#import "CTTabBarViewController.h"

@interface CTLoginViewController () <NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eidFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@property (strong, nonatomic) NSString *sessionID;
@end

@implementation CTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    [self setUpTextField];
    [self isAutoLogin];
}


//设置导航栏
-(void)setUpNavigation{
    self.navigationItem.title = @"CityU Fitness Booking";
}

//设置输入栏
-(void)setUpTextField{
    self.pwdField.leftView = [[[NSBundle mainBundle] loadNibNamed:@"loginFieldLeftView" owner:nil options:nil] firstObject];
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    
    self.eidFiled.leftView = [[[NSBundle mainBundle] loadNibNamed:@"loginFieldLeftView" owner:nil options:nil] lastObject];
    self.eidFiled.leftViewMode = UITextFieldViewModeAlways;
}

//判断是否自动登录
-(void)isAutoLogin{
    self.eidFiled.text = [CTSaveTool getAutoUsername];
    self.pwdField.text = [CTSaveTool getAutoPassword];
    self.autoLoginSwitch.on  = [CTSaveTool getAutologinState];
    if (self.autoLoginSwitch.isOn == YES) {
        [self clickLoginBtn];
    }
    
}

//点击登陆按钮
- (IBAction)clickLoginBtn {
    if ([self validTimeperiod] == FALSE) {
        [self showAlertViewWithTitle:@"Error" message:@"The system is not available during 00:00 - 08:00."];
        return;
    }
    
    if ([self validInput] == FALSE) {
        [self showAlertViewWithTitle:@"Error" message:@"Please input your EID and Password."];
        return;
    }

    
    CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
    [MBProgressHUD showMessage:@"Connect..." toView:self.view];
    //1.try to get session
    
    [mgr getSessionDidSuccess:^(NSString *session){
        [MBProgressHUD hideHUDForView:self.view];

        [MBProgressHUD showMessage:@"Login..." toView:self.view];
          //  2.try to login
         [mgr loginWithUsername:self.eidFiled.text password:self.pwdField.text DidSuccess:^(NSString *p_user_no){
             [MBProgressHUD hideHUDForView:self.view];
             [MBProgressHUD showSuccess:@"Success"];
             
             //储存自动登录
             [CTSaveTool setAutoUsername:self.eidFiled.text];
             [CTSaveTool setAutoPassword:self.pwdField.text];
            
             if (self.autoLoginSwitch.isOn == YES) {
                 [CTSaveTool setAutologinState:YES];
             }
             
             //3. load main TabBarView;
             [self presentViewController:[[CTTabBarViewController alloc] init] animated:YES completion:nil];

         } DidFailure:^(NSString *error){
             [MBProgressHUD hideHUDForView:self.view];
             [self showAlertViewWithTitle:@"Incorrect Account" message:error];
         }];
    } DidFailure:^(NSString *error){
        [MBProgressHUD hideHUDForView:self.view];
        [self showAlertViewWithTitle:@"Error" message:error];
    }];
}


-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - close KB
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - validation
-(BOOL)validTimeperiod{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSInteger currentHour = [[formatter stringFromDate:currentDate] integerValue];
    
    if (currentHour>= 0 && currentHour<= 8) {
        return NO;
    }
    return YES;
}

-(BOOL)validInput{
    return self.pwdField.text.length&&self.eidFiled.text.length;
}

@end
