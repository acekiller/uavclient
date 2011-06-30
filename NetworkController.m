//
//  NetworkController.m
//  Socket
//
//  Created by visu4l on 11. 6. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkController.h"


@implementation NetworkController

@synthesize ip;
@synthesize port;
@synthesize sockfd;

-(id) init{
//    char* remoteIp = "203.253.20.196";
    //char* localIp = "192.168.150.202";
//    char* localIp = "127.0.0.1";
    
//    Boolean isLocal = true;
//    char* connectIP = isLocal ? localIp : remoteIp;
        
    self = [super init];
    if (self) {
        ip = (char*) malloc(sizeof("203.253.20.196"));
        memcpy(ip, "203.253.20.196", sizeof("203.253.20.196"));
        port = 8080;
    }
    return self;
}

-(void) closeSock{
    close(sockfd);
    NSLog(@"system close socket");
}

-(Boolean) createSock{
 
    if ( (sockfd = socket( AF_INET, SOCK_STREAM, 0 )) < 0 ) { //udp = SOCK_DGRAM
        NSLog(@"Error creating socket");
    }
    
    struct sockaddr_in serverAddress;
    bzero( &serverAddress, sizeof(serverAddress) );
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons( port );
    serverAddress.sin_addr.s_addr = inet_addr(ip);
    
    
    if ( connect( sockfd, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) < 0 )
    { 
        NSLog(@"connect error");
        return false;
    } 
    NSLog(@"socket connected");
    
    NSThread *responseThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvRoutine) object:nil];
    
    [responseThread start];
    
//    char buffer[100];
//    sprintf(buffer,"hello server... ~");
//    write(sockfd, buffer, strlen(buffer));

    return true;
}

-(void) recvRoutine{

    char buffer[100] = {};
    int recv_len = 0;
    
    while(1){
        
        recv_len = read(sockfd, buffer, 100);
        if(recv_len > 0){
            NSLog(@"server : %s", buffer);
        }
        
    }
}

-(void) sendPacket{
    
    
}

@end
