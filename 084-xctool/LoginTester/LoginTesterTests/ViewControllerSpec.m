#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "ViewController.h"
#import "LoginService.h"
#import "WelcomeViewController.h"

SpecBegin(ViewControllerSpec)

describe(@"ViewController", ^{
    __block ViewController *_vc;
    beforeEach(^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
        _vc = (ViewController *)[nav visibleViewController];
        
        UIView *view = _vc.view;
        expect(view).toNot.beNil();
    });
    
    
    it(@"should be instantiated from the storyboard", ^{
        expect(_vc).toNot.beNil();
        expect(_vc).to.beInstanceOf([ViewController class]);
    });
    
    it(@"should have an outlet for the username field", ^{
        expect(_vc.usernameTextField).toNot.beNil();
    });
    
    it(@"should have an outlet for the password field", ^{
        expect(_vc.passwordTextField).toNot.beNil();
    });
    
    it(@"should wire up the login button action", ^{
        UIButton *button = _vc.loginButton;
        NSArray *actions = [button actionsForTarget:_vc forControlEvent:UIControlEventTouchUpInside];
        expect(actions[0]).to.equal(@"loginTapped:");
    });
    
    describe(@"logging in", ^{
        __block id _mockLoginService;
        
        beforeEach(^{
            _mockLoginService = [OCMockObject mockForClass:[LoginService class]];
            _vc.loginService = _mockLoginService;
        });
        
        afterEach(^{
            [_mockLoginService verify];
        });
        
        it(@"should verify username & password with the login service", ^{
            [[_mockLoginService expect] verifyUsername:@"user1"
                                             password:@"password1"
                                           completion:[OCMArg any]];
            
            _vc.usernameTextField.text = @"user1";
            _vc.passwordTextField.text = @"password1";
            
            [_vc loginTapped:nil];
        });
        
        context(@"with invalid credentials", ^{
            __block id _alertProvider;
            
            beforeEach(^{
                _alertProvider = [OCMockObject mockForClass:[AlertViewProvider class]];
                _vc.alertProvider = _alertProvider;
                
                [[_mockLoginService stub] verifyUsername:[OCMArg any]
                                                password:[OCMArg any]
                                              completion:[OCMArg checkWithBlock:^BOOL(LoginServiceCompletionBlock block) {
                    block(NO);
                    return YES;
                }]];
            });
            
            it(@"should show an alert", ^{
                id mockAlert = [OCMockObject mockForClass:[UIAlertView class]];
                [[[_alertProvider expect] andReturn:mockAlert] alertViewWithTitle:[OCMArg any]
                                                                          message:[OCMArg any]];
                [[mockAlert expect] show];
                
                [_vc loginTapped:nil];
                
                [_alertProvider verify];
                [mockAlert verify];
            });
        });
        
        context(@"valid credentials", ^{
            beforeEach(^{
                [[_mockLoginService stub] verifyUsername:[OCMArg any]
                                                password:[OCMArg any]
                                              completion:[OCMArg checkWithBlock:^BOOL(LoginServiceCompletionBlock block) {
                    block(YES);
                    return YES;
                }]];
            });
            
            it(@"should push the welcome view controller", ^{
                [_vc loginTapped:nil];
                
                expect(_vc.navigationController.visibleViewController).to.beInstanceOf([WelcomeViewController class]);
            });
        });
        
    });
});

SpecEnd


