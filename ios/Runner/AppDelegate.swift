import UIKit
import Flutter
import SwiftyDropbox

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  var pendingResult: FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let dropBoxChannel = FlutterMethodChannel.init(name: "gr.sullenart.wordstudy/dropbox",
                                                   binaryMessenger: controller);
    dropBoxChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if ("startDropBoxAuth" == call.method) {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
             
                self.pendingResult = result
                DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                              controller: topController,
                                                              openURL: { (url: URL) -> Void in
                                                                UIApplication.shared.openURL(url)
                })
            }
        } else if ("signOutDropBoxAuth" == call.method) {
            DropboxClientsManager.unlinkClients();
            result("OK");
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    });
    
    DropboxClientsManager.setupWithAppKey("5imgefj1w8ughh6")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success(let accessToken):
                if (self.pendingResult != nil) {
                    self.pendingResult?(accessToken.accessToken);
                    self.pendingResult = nil
                }
                print("Success! User is logged into Dropbox.")
            case .cancel:
                if (self.pendingResult != nil) {
                    self.pendingResult?(FlutterError.init(code: "UNAVAILABLE",
                                                          message: "Authorization flow was manually canceled by user!",
                                                          details: nil));
                    self.pendingResult = nil
                }
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                if (self.pendingResult != nil) {
                    self.pendingResult?(FlutterError.init(code: "UNAVAILABLE",
                                                          message: "Error: \(description)",
                                                          details: nil));
                    self.pendingResult = nil
                }
                print("Error: \(description)")
            }
        }
        return true
    }
}
