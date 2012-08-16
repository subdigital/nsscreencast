class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds

    evc = EpisodesViewController.alloc.init
    nav = UINavigationController.alloc.initWithRootViewController evc

    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end
end
