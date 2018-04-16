This is a Rails rebuild of [this Sinatra app](https://github.com/FLWallace105/influencer_order_processing "this influencer order processing app") which processes influencer orders for [ellie.com](https://www.ellie.com/ "ellie.com").

### Testing
- Although the automated test suite covers a lot, there are still some things that need to be manually tested:
	1. The pulling the csv from the FTP Server, creating the InfluencerTracking object and then sending the influencer tracking email workflow.
		1. In InfluencerOrder.name_csv prefix the string that method returns with TEST_
		2. In EllieFTP#pull_order_tracking match against TEST instead of ORDERTRK
		3. If there is not a CSV inside the ftp server at EllieInfluencer/SendOrder with TEST in the file name, then create one.
		4. Make sure there is an InfluencerOrder with the same name inside the fulfillment_line_item_id column of the test csv file inside the FTP server.
		5. The InfluencerOrder will need to match with an influencer in the database. You probably want that influencer to use the dev teams email.
		6. Remember to delete the test Influencer, the test InfluencerOrder, and the test InfluencerTracking when you are done.

### Production
Anytime the front end changes precompile the assets again with:
```sh
rake assets:precompile
```
start the server in production mode:
```sh
rails s -e production
```
To run rails console:
```sh
rails c -e production
```
prefix rake tasks with:
```sh
RAILS_ENV=production
```
start Resque workers with:
```sh
RAILS_ENV=production rake resque:work
```
