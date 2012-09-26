/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooAlliancePendingVC.h"
#import "Beintoo.h"

@implementation BeintooAlliancePendingVC

@synthesize elementsTable, elementsArrayList, selectedElement, elementsImages, startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title			= NSLocalizedStringFromTable(@"allianceviewpending", @"BeintooLocalizable", nil);
	titleLabel.text		= NSLocalizedStringFromTable(@"friendReqTitle", @"BeintooLocalizable", nil);
	noResultLabel.text	= NSLocalizedStringFromTable(@"allianceNoResult", @"BeintooLocalizable", nil);
	
	[friendsActionView setTopHeight:40];
	[friendsActionView setBodyHeight:387];
	
	_player					= [[BeintooPlayer alloc] init];
	_alliance				= [[BeintooAlliance	alloc] init];
	
	self.elementsArrayList  = [[NSMutableArray alloc] init];
	self.elementsImages	    = [[NSMutableArray alloc] init];
	
	friendsVC		= [BeintooFriendsListVC alloc];
	findFriendsVC	= [BeintooFindFriendsVC alloc];
			
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
		
	self.elementsTable.delegate		= self;
	self.elementsTable.dataSource   = self;
	self.elementsTable.rowHeight	= 60.0;	
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 436)];
    }
    _alliance.delegate		= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[self.elementsArrayList removeAllObjects];
		[self.elementsTable reloadData];
		
		[BLoadingView startActivity:self.view];
        [_alliance getPendingRequestsForAlliance:[self.startingOptions objectForKey:@"allianceID"] withAdmin:[self.startingOptions objectForKey:@"allianceAdminID"]];
	}
}

#pragma mark -
#pragma mark AllianceDelegate

- (void)didGetPendingRequests:(NSArray *)result{
    
    [self.elementsArrayList removeAllObjects];
    [self.elementsImages removeAllObjects];
    
    [noResultLabel setHidden:YES];
	
	if ([result count]<=0) {
		[noResultLabel setHidden:NO];
	}
    
    if ([result isKindOfClass:[NSArray class]]) {
		for (int i=0; i<[result count]; i++) {
			@try {
				NSMutableDictionary *elementEntry = [[NSMutableDictionary alloc]init];
				NSString *nickname	 = [[result objectAtIndex:i] objectForKey:@"nickname"];
				NSString *userExt	 = [[result objectAtIndex:i] objectForKey:@"id"];
				NSString *userImgUrl = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
				BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
				download.delegate = self;
				download.urlString = userImgUrl;
				
				[elementEntry setObject:nickname forKey:@"nickname"];
				[elementEntry setObject:userExt forKey:@"userExt"];
				[elementEntry setObject:userImgUrl forKey:@"userImgUrl"];
				[self.elementsArrayList addObject:elementEntry];
				[self.elementsImages addObject:download];
				[elementEntry release];
			}
			@catch (NSException * e) {
				BeintooLOG(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
			}
		}
	} 
	
	[BLoadingView stopActivity];
	[self.elementsTable reloadData];	
}

- (void)didAllianceAdminPerformedRequest:(NSDictionary *)result{
	[BLoadingView stopActivity];
		
	NSString *successAlertMessage;
	if (friendResponseKind == USER_ACCEPT_FRIENDSHIP) 
		successAlertMessage = NSLocalizedStringFromTable(@"requestAccepted",@"BeintooLocalizable",@"");
	else 
		successAlertMessage = NSLocalizedStringFromTable(@"requestRefused",@"BeintooLocalizable",@"");
	
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = successAlertMessage;
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
	[av release];
	
	[BLoadingView startActivity:self.view];
    [_alliance getPendingRequestsForAlliance:[self.startingOptions objectForKey:@"allianceID"] withAdmin:[self.startingOptions objectForKey:@"allianceAdminID"]];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.elementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
	cell.textLabel.text = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font	= [UIFont systemFontOfSize:16];
	
	BImageDownload *download = [self.elementsImages objectAtIndex:indexPath.row];
	UIImage *cellImage  = download.image;
	cell.imageView.image = cellImage;	
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedElement = [self.elementsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"alliancependindialog",@"BeintooLocalizable",@""),[self.selectedElement objectForKey:@"nickname"]]

													delegate:self 
										   cancelButtonTitle:NSLocalizedStringFromTable(@"cancel",@"BeintooLocalizable",@"")
									  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"acceptBtn",@"BeintooLocalizable",@""),
																				NSLocalizedStringFromTable(@"refuseBtn",@"BeintooLocalizable",@""),nil];
	as.actionSheetStyle = UIActionSheetStyleDefault;
	[as showInView:self.view];
	[as release];
}

#pragma mark -
#pragma mark actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	NSString *selectedUserID = [self.selectedElement objectForKey:@"userExt"];
    
	if(buttonIndex == 0){ // Accept friend
        friendResponseKind = USER_ACCEPT_FRIENDSHIP;
		[BLoadingView startActivity:self.view];
        [_alliance allianceAdmin:[self.startingOptions objectForKey:@"allianceAdminID"] ofAlliance:[self.startingOptions objectForKey:@"allianceID"] performAction:ALLIANCE_ACTION_ACCEPT forUser:selectedUserID];
	}
	if(buttonIndex == 1){ // Refuse friend
        friendResponseKind = USER_REFUSE_FRIENDSHIP;
		[BLoadingView startActivity:self.view];
        [_alliance allianceAdmin:[self.startingOptions objectForKey:@"allianceAdminID"] ofAlliance:[self.startingOptions objectForKey:@"allianceID"] performAction:ALLIANCE_ACTION_REMOVE forUser:selectedUserID];
	}

	[self.elementsTable deselectRowAtIndexPath:[self.elementsTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.elementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.elementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

- (UIView *)closeButton{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo{
    BeintooNavigationController *navController = (BeintooNavigationController *)self.navigationController;
    [Beintoo dismissBeintoo:navController.type];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    _alliance.delegate    = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[_player release];
    [_alliance release];
	[friendsVC release];
	[self.elementsArrayList release];
	[self.elementsImages release];
	[titleLabel release];
    [super dealloc];
}


@end
