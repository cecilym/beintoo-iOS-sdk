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

#import "BeintooFriendActionsVC.h"
#import "Beintoo.h"

@implementation BeintooFriendActionsVC

@synthesize elementsTable, elementsArrayList, selectedElement, startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title		= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Select A Friend");
	
	[friendsActionView setTopHeight:20];
	[friendsActionView setBodyHeight:417];
	
	elementsArrayList = [[NSMutableArray alloc] init];
	_player				= [[BeintooPlayer alloc] init];
	friendsVC			= [BeintooFriendsListVC alloc];
	findFriendsVC		= [BeintooFindFriendsVC alloc];
	friendRequestsVC	= [BeintooFriendRequestsVC alloc];
	recommendToAFriendVC = [[BeintooWebViewVC alloc] initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:@"http://sdk-mobile.beintoo.com/rtaf/"];
		
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
		
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 85.0;	
	
	self.elementsArrayList = [NSArray arrayWithObjects:@"yourFriends",@"findFriends",@"friendRequests",@"recommendToAFriend",nil];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];

	//[self.elementsTable reloadData];
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
	
	NSString *choicheCode			= [self.elementsArrayList objectAtIndex:indexPath.row];
	NSString *choicheDesc			= [NSString stringWithFormat:@"%@Desc",choicheCode];
	cell.textLabel.text				= NSLocalizedStringFromTable(choicheCode,@"BeintooLocalizable",@"Select A Friend");;
	cell.textLabel.font				= [UIFont systemFontOfSize:16];
	cell.detailTextLabel.text		= NSLocalizedStringFromTable(choicheDesc,@"BeintooLocalizable",@"");;
	cell.detailTextLabel.font		= [UIFont systemFontOfSize:14];

	cell.imageView.image	= [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_%@.png",choicheCode]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//self.selectedFriend = [self.friendsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
		NSDictionary *friendsListOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"profile",@"caller",nil,@"callerVC",nil];
		[friendsVC initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:friendsListOptions];
		[self.navigationController pushViewController:friendsVC animated:YES];
	}
	else if (indexPath.row == 1) {
		NSDictionary *findFriendsOptions = nil;
		[findFriendsVC initWithNibName:@"BeintooFindFriendsVC" bundle:[NSBundle mainBundle] andOptions:findFriendsOptions];
		[self.navigationController pushViewController:findFriendsVC animated:YES];		
	}
	else if	(indexPath.row == 2){
		NSDictionary *friendRequestsOptions = nil;
		[friendRequestsVC initWithNibName:@"BeintooFriendRequestsVC" bundle:[NSBundle mainBundle] andOptions:friendRequestsOptions];
		[self.navigationController pushViewController:friendRequestsVC animated:YES];		
	}
	else if (indexPath.row == 3){
		[self.navigationController pushViewController:recommendToAFriendVC animated:YES];
	}
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_player release];
	[friendsVC release];
	[findFriendsVC release];
	[friendRequestsVC release];
	[recommendToAFriendVC release];
	[elementsArrayList release];
    [super dealloc];
}


@end
