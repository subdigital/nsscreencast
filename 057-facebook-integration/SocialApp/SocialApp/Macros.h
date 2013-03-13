#define NAVIFY(controller) [[UINavigationController alloc] initWithRootViewController:controller]
#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title\
                                                      message:msg\
                                                     delegate:nil\
                                            cancelButtonTitle:@"OK"\
                                            otherButtonTitles:nil] show]