#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "ViewController.h"
#import "LoginService.h"

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
        // vc => login service
        it(@"should verify username & password with the login service", ^{
            //arrange
            id mockLoginService = [OCMockObject mockForClass:[LoginService class]];
            [[mockLoginService expect] verifyUsername:@"user1"
                                             password:@"password1"
                                           completion:[OCMArg any]];
            
            _vc.loginService = mockLoginService;
            _vc.usernameTextField.text = @"user1";
            _vc.passwordTextField.text = @"password1";
            
            
            //act
            [_vc loginTapped:nil];
            
            // assert
            [mockLoginService verify];
        });
    });
});

SpecEnd


