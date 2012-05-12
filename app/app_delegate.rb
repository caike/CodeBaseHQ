class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)    
    @window.rootViewController = load_root_view_controller()
    @window.makeKeyAndVisible
  end


  private

    def load_root_view_controller
      codeBaseViewController = CodeBaseViewController.alloc.init
      codeBaseViewController.app_settings = Settings.load('codebasehq')
      UINavigationController.alloc.initWithRootViewController(codeBaseViewController)
    end
end
