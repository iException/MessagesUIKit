//
//  MUKViewController.m
//  MessagesUIKit
//
//  Created by hyice on 06/12/2015.
//  Copyright (c) 2014 hyice. All rights reserved.
//

#import "MUKViewController.h"

@interface MUKViewController ()

@end

@implementation MUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.selfId = [NSString stringWithFormat:@"testId%u", arc4random()%1000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bxSendTextMessage:(NSString *)text
{
    BXQuickMessage *message = [[BXQuickMessage alloc] init];
    message.text = text;
    message.date = [NSDate date];
    message.senderId = self.selfId;
    message.sendStatus = BXQuickMessageSendStatus_Sended;
    message.messageType = BXQuickMessageType_Text;
    
    [self.dataSource addObject:message];
    
    [self.collectionView reloadData];
}

@end
