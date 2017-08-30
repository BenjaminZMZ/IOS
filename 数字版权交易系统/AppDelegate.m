//
//  AppDelegate.m
//  数字版权交易系统
//
//  Created by 李剑 on 16/11/1.
//  Copyright © 2016年 zdrjxy. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "DiscoverMusicViewController.h"
#import "MyMusicViewController.h"
#import "AccountViewController.h"

#import "LJThemeSwitcher.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navDiscoverMusicVC = [[UINavigationController alloc] initWithRootViewController:[[DiscoverMusicViewController alloc] init]];
    navDiscoverMusicVC.tabBarItem.image = [UIImage imageNamed:@"cm2_btm_icn_discovery_prs"];
    navDiscoverMusicVC.tabBarItem.title = @"发现音乐";
    //navDiscoverMusicVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
    //navDiscoverMusicVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    
    UINavigationController *navMyMusicVC = [[UINavigationController alloc] initWithRootViewController:[[MyMusicViewController alloc] init]];
    navMyMusicVC.tabBarItem.image = [UIImage imageNamed:@"cm2_btm_icn_music_prs"];
    navMyMusicVC.tabBarItem.title = @"我的音乐";
    
    UINavigationController *navAccountVC = [[UINavigationController alloc] initWithRootViewController:[[AccountViewController alloc] init]];
    navAccountVC.tabBarItem.image = [UIImage imageNamed:@"cm2_btm_icn_account_prs"];
    navAccountVC.tabBarItem.title = @"帐号";
    
    RootTabBarController *rootVC = [[RootTabBarController alloc] init];
    rootVC.viewControllers = @[navDiscoverMusicVC, navMyMusicVC, navAccountVC];
    rootVC.tabBar.barTintColor = [UIColor blackColor];
    rootVC.tabBar.tintColor = [UIColor whiteColor];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    LJThemeManager *themeManager = [LJThemeManager sharedManager];
    themeManager.themes = @[@"NormalTheme", @"NightTheme", @"BlueTheme"];
    themeManager.currentTheme = NormalTheme;
    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://116.196.100.188:3000/search?keywords=%E6%B5%B7%E9%98%94%E5%A4%A9%E7%A9%BA"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", str);
//        }
//        
//    }];
//    [task resume];
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
