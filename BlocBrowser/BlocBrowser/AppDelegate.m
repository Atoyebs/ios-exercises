//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by Inioluwa Work Account on 19/04/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AppDelegate.h"
#import "BLCWebBrowserViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    BLCWebBrowserViewController *blcWebBrowserVC = [[BLCWebBrowserViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController: blcWebBrowserVC];
    
    [self.window makeKeyAndVisible];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:@"Get Excited To Use The Best Web Browser Ever" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Excited" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:okAction];
    
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    
    [navigationVC presentViewController:alert animated:YES completion:nil];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    BLCWebBrowserViewController *browserVC = [[navigationVC viewControllers] firstObject];
    [browserVC resetView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    NSLog(@"Application has come back in")
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
