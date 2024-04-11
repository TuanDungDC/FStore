//
//  AppDelegate.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import SDWebImage
import FBSDKCoreKit
import GoogleSignIn
import Stripe

@main // Sử dụng @main thay vì @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Cấu hình cửa sổ và giao diện người dùng
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
        // Cấu hình thanh điều hướng
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        
        // Cấu hình Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Cấu hình Google SignIn
        GIDSignIn.sharedInstance()?.clientID = "YOUR_GOOGLE_CLIENT_ID"
        
        // Cấu hình Stripe
        Stripe.setDefaultPublishableKey("YOUR_STRIPE_PUBLISHABLE_KEY")
        
        return true
    }
    
    // Hàm xử lý mở URL cho Facebook và Google SignIn
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Xử lý URL cho Facebook SDK
        let appId: String = Settings.shared.appID!
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host == "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        // Xử lý URL cho Google SignIn
        if let sourceApplication = options[.sourceApplication] as? String, let annotation = options[.annotation] {
            return GIDSignIn.sharedInstance()?.handle(url, sourceApplication: sourceApplication, annotation: annotation) ?? false
        }
        
        return false
    }
    
    // Hàm được gọi khi ứng dụng trở nên hoạt động
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.shared.activateApp()
    }
}
