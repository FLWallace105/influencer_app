This is a Rails rebuild of [this Sinatra app](https://github.com/FLWallace105/influencer_order_processing "this influencer order processing app") which processes influencer orders for [ellie.com](https://www.ellie.com/ "ellie.com").

### Testing
- Although the automated test suite covers a lot, there are still some things that need to be manually tested:
	1. The pulling the csv from the FTP Server, creating the InfluencerTracking object and then sending the influencer tracking email workflow.
		1. In EllieFTP#pull_order_tracking match against TEST instead of ORDERTRK
		2. If there is not a CSV inside the ftp server at EllieInfluencer/SendOrder with TEST in the file name, then create one.
		3. Make sure there is an InfluencerOrder with a name attribute that matches the fulfillment_line_item_id column of the test csv file inside the FTP server.
		4. The InfluencerOrder will also need to have an associated Influencer in the database. You probably want that influencer to use the dev teams email.
		5. Update the ellie_ftp credentials for the development environment:
			1. Open up the credentials file with (assuming you want to use atom):
			```sh
				EDITOR="atom --wait" rails credentials:edit
			```
			2. After saving the development credentials and closing the editor the credentials should be updated.
		6. Remember to delete the test Influencer, the test InfluencerOrder, and the test InfluencerTracking when you are done. Also put the ellie_ftp production credentials back.

### Production
Anytime the front end assets change precompile them again with:
```sh
rake assets:precompile
```
To start the server in production mode:
```sh
rails s -e production
```
If you want the server to keep running when the ssh connection closes, start the server this way in production mode as described [here](https://stackoverflow.com/a/16420396):
```sh
screen rails s -e production
```
after that CTRL + A + D

Alternatively you can start the server from systemd:
```
cd /etc/systemd/system
sudo systemctl start rails-influencers-app.service
```

To run rails console:
```sh
rails c -e production
```
Prefix rake tasks with:
```sh
RAILS_ENV=production
```
Start Resque workers with:
```sh
RAILS_ENV=production rake resque:work
```
Alternatively you can start workers from systemd:
```
cd /etc/systemd/system
sudo systemctl start resque-worker-splat.service
```
Kill the server with:
```sh
kill -9 {PID}
```
You find the PID in tmp/pids/server.pid

Alternatively you can kill the server from systemd:
```
sudo systemctl stop start rails-influencers-app.service
```
To check the status of a systemd service:
```
sudo systemctl status [service_name]
```
