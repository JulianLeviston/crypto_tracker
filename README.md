# README for CryptoTracker

CryptoTracker is my (Julian Leviston) submission for a code challenge by CoinJar.

## Where to start

As I'm a firm believer that documentation should be small, maintained and clear, this readme will show you how to start the application, and explain the thoughts behind the decisions in its development.

The repo was initially created with the [rails-new](https://github.com/rails/rails-new) tool as it seemed a nice way to get a reproducible build of Rails 8 and dependencies in place. It lets us use docker & docker compose to download all dependencies and start up the app for you.

## Installation and Setup

To start the application, ensure you have installed [docker](https://www.docker.com), [vscode](https://code.visualstudio.com) and that the [dev containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension is installed, which you can get via the marketplace.

Once these things are in place, you can open this repo in vscode and it will ask you if you want to "reopen in container"; you should proceed with this as it will start the container. The first time you do this on a machine may take some time as it will download and build the image required and its dependencies to run the container and server. Any terminal you open within vscode in this project will then be within the running container, and changes will be sandboxed. Closing the window will stop the container and subsequent starts should be substantially faster.

## Starting the application

Once the container has been started as above, you can open a terminal in VS Code and run the command `bin/rails s` to start the server. By default, as always, this will be on port 3000 which is opened from within the container, so you should be able to visit http://localhost:3000 in your browser on your local machine and the app will be working and served to you from there.

## Future Considerations while developing

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
