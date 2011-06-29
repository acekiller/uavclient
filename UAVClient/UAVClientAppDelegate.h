//
//  UAVClientAppDelegate.h
//  UAVClient
//
//  Created by visu4l on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UAVClientViewController;

@interface UAVClientAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UAVClientViewController *viewController;

@end
