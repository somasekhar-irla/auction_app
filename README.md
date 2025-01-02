# AuctionApp
### Stacks

Please install the following stacks

| Name | Version |  Install |  Features |
| ------ | ------ | ------ | ------ |
| Mysql | 16 | [Link](https://dev.mysql.com/downloads/mysql/)  | Main Database |
| Ruby | 3.3.4 | [Link](https://www.ruby-lang.org/en/downloads/)  | API Backend |
| Sidekiq | Gemfile | [Link](https://github.com/sidekiq/sidekiq)  | Sidekiq | Bundle Install 
| Redis | 7.2.6 | [Link](https://github.com/redis/redis-rb)  | Redis | Bundle Install


## 🔧 Installation

1. Edit `.env.development` file
```bash
All required constants defined in env file.
```

2. Install libraries:
```bash
bundle install
```

3. Migrate database:
```bash
rails db:create
rails db:migrate
```

## 🚀 Getting started

```bash
rails s
```

```bash
bundle exec sidekiq
```

## Note: Its Rails API Application. Rspec for API and Frontend App not developed because of time constraint. Manually tested cases using postman.


Curl Commands For testing:
1. Seller or Buyer considered as Same entity User 

	- Signup Curl for Seller
	```bash
	curl --location 'http://localhost:3001/users/sign_up' \
	--header 'Content-Type: application/json' \
	--data-raw '{
	    "name": "seller1",
	    "email": "seller1@test.com",
	    "password": <STRONG PASSWORD>
	 }'
	```
	- Signup Curl for Buyer
	```bash
	curl --location 'http://localhost:3001/users/sign_up' \
	--header 'Content-Type: application/json' \
	--data-raw '{
	    "name": "buyer1",
	    "email": "buyer1@test.com",
	    "password": <STRONG PASSWORD>
	 }'
	```
	- Signin Curl for Seller

	```bash
	curl --location 'http://localhost:3001/users/sign_in' \
	--header 'Content-Type: application/json' \
	--data-raw '{
	    "email": "seller1@test.com",
	    "password": <STRONG PASSWORD>
	}'
	```
	- Signup Curl for Buyer
	```bash
	curl --location 'http://localhost:3001/users/sign_in' \
	--header 'Content-Type: application/json' \
	--data-raw '{
	    "email": "buyer1@test.com",
	    "password": <STRONG PASSWORD>
	}'
	```
	Use the response auth token to list Auction Item or Buy Auction Item or AutoBid Auction Item. Refer Postman Zip and Snapshots.

2. Auction Items Create and Listing

   - Create Auction Item by Seller
   	```bash
	curl --location 'http://localhost:3001/auction_items' \
	--header 'Content-Type: application/json' \
	--header 'Authorization: <SELLER_AUTH_TOKEN>' \
	--data '{
	    "title": "item1",
	    "description": "item1 test",
	    "starting_price": 10,
	    "min_selling_price": 5,
	    "bid_start_time": "2024-12-30T13:36:17+05:30",
	    "bid_end_time": "2024-12-30T14:36:17+05:30"
	}'
	```
	- List Auction Items

    ```bash
	curl --location 'http://localhost:3001/auction_items' \
	--header 'Content-Type: application/json' \
	--header 'Authorization: <SELLER_AUTH_TOKEN>' \
	--data ''
	```
3. Buyer Bid for Auction Item and Set Automatic bids
	
   - Create Bid
    ```bash
	curl --location 'http://localhost:3001/bids' \
	--header 'Content-Type: application/json' \
	--header 'Authorization: <BUYER_AUTH_TOKEN>' \
	--data '{
	"auction_item_uuid": "b88a646c-46ef-42d1-bb32-ca9828db1396",
	"amount": 6
	}'
	```
   - Create Auto Bid
   ```bash
	curl --location 'http://localhost:3001/auto_bids' \
	--header 'Content-Type: application/json' \
	--header 'Authorization: <BUYER_AUTH_TOKEN>' \
	--data '{
	    "auction_item_uuid": "b88a646c-46ef-42d1-bb32-ca9828db1396",
	    "max_amount": 9
	}'
	```
4. Cron Job is scheduled every 5mins to update bid winner and to notify
	```bash
	schedule.yml file - NotifyAuctionResultJob
	```


## Api Flow

- Limited the User module with basic features like API authentication only.

- Signup Seller and Buyer Accounts. Seller cannot buy the Auction Items which belongs to him.

- Signin as Seller or Buyer - Use the auth token for other API's

- Seller can Create the Auction Items. List of Auction Items API available but disabled the MSP in the response list. 

- Buyer can do bid or autobid. Bidding is available between the start and end of auction time.

## Credentials and Constants

- Everything updated in env.development file. Just bundle install and run server and sidekiq.

