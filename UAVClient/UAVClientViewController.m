//
//  UAVClientViewController.m
//  UAVClient
//
//  Created by visu4l on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UAVClientViewController.h"

@implementation UAVClientViewController


@synthesize btnConnect;
@synthesize textStatus;
@synthesize controller;
@synthesize locationManager;
@synthesize compassImg;

@synthesize textLat;
@synthesize textLng;
@synthesize textHeading;



-(void) setup{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    locationManager.headingFilter = kCLHeadingFilterNone;
    [locationManager startUpdatingHeading];
    
}

/**
 * network check
 * run on wifi
 */
-(Boolean) isNetworkReachable 
{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkFlagsReachable){  // connected network. but, don't know network. 3g or wifi
        if(flag & kSCNetworkReachabilityFlagsIsWWAN){ 
            return false; //3g
        }else {
            return true;  //wifi
        }
    }else {
        return false;  // not connected any network
    }
}

/*
 * click Connect button
 * 
 */
-(IBAction) clieckConnect:(id)sender{
    
    controller = [[NetworkController alloc] init];
    
//    [control/ler performSelectorOnMainThread:@selector(createSock) withObject:<#(id)#> waitUntilDone:NO];


    
    if([controller createSock]){
        [btnConnect setEnabled:false];
        [self updateStatus:@"OK. Connect to Server!"]; 
    }else{
        [self updateStatus:@"check network. and Retry connect"]; 
    }
}

//
// locate functions...
//
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    double lat = newLocation.coordinate.latitude;
    double lng = newLocation.coordinate.longitude;
    
    textLat.text = [NSString stringWithFormat:@"%f", lat];
    textLng.text = [NSString stringWithFormat:@"%f", lng];
    //    [self updateStatus:[NSString stringWithFormat:@"lat:%f \tlng:%f", lat, lng]];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    double heading = newHeading.magneticHeading;
    CGFloat angle = (heading*M_PI)/180;
    
    textHeading.text = [NSString stringWithFormat:@"%f", angle];
    
    compassImg.transform = CGAffineTransformMakeRotation(-angle);
    [UIView commitAnimations];
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self updateStatus:[NSString stringWithFormat:@"locationManager error : %@", error.accessibilityValue]];
}


//
// util functions...
//

-(void) updateStatus:(NSString *)msg{
    
    textStatus.text = [NSString stringWithFormat:@"%@ \n%@", textStatus.text, msg];
    
}

-(void) alertNotify:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notify" message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}




- (void)dealloc
{
    [controller release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

//app start
-(void) viewDidLoad{
    
    [self updateStatus:@"Start application"];
    
    [btnConnect setEnabled:false];
    
    if([self isNetworkReachable]){
        [self updateStatus:@"connected WIFI"];
        [btnConnect setEnabled:true];
        [self setup];
        
    }else{
        [self updateStatus:@"Please, connect to WIFI"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return YES;
    // UI fix to Protrait
    return (interfaceOrientation >= UIInterfaceOrientationLandscapeLeft);
}

@end
