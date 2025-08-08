# README for CryptoTracker

CryptoTracker is my (Julian Leviston) submission for a code challenge by CoinJar.

## Where to start

As I'm a firm believer that documentation should be small, maintained and clear, this readme will show you how to start the application, and explain the thoughts behind the decisions in its development.

The repo was initially created with the [rails-new](https://github.com/rails/rails-new) tool as it seemed a nice way to get a reproducible build of Rails 8 and dependencies in place. It lets us use docker & docker compose to download all dependencies and start up the app for you.

## Installation and Setup

To start the application, ensure you have installed [docker](https://www.docker.com), [vscode](https://code.visualstudio.com) and that the [dev containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension is installed, which you can get via the marketplace.

Once these things are in place, you can open this repo in vscode and it will ask you if you want to "reopen in container"; you should proceed with this as it will start the container. The first time you do this on a machine may take some time as it will download and build the image required and its dependencies to run the container and server. Any terminal you open within vscode in this project will then be within the running container, and changes will be sandboxed. Closing the window will stop the container and subsequent starts should be substantially faster.

## Starting the application

Once the container has been started as above, you can open a terminal in VS Code. There is a standard database already present that is using sqlite (via the storage directory) that has data in it. If you want to start fresh, you can run `bin/rails db:drop && bin/rails db:create` and `bin/rails db:seed` to set up the database initially with currencies and exchange rate types again, but it might be easiest to just proceed with the existing database.

Then, to start the server, run the command `bin/rails s` to start the server as usual. By default, as always, this will be on port 3000 which is opened from within the container, so you should be able to visit http://localhost:3000 in your browser on your local machine and the app will be working and served to you from there.

## AI usage in development

I used AI (ChatGPT) as a study companion as I usually do lately. I mostly used it to look up syntax, suggesting libraries I'm unaware of and to get me started with pieces that I'd otherwise stall on. I didn't use it at all for architecture, and I only ever use it as a study aid, and will almost never use its code verbatim without checking it a lot first.

## Architecture

I started with a docker for dev install of rails (rails new project), then I did some thinking and the domain modelling, then I created a plan (in the docs folder) and gradually proceeded with it.

One thing I wanted to apply while doing this was a bugbear I'd had with Rails for a while. That is, the intertwined nature of the "standard" approach to developing Ruby and Rails apps. It can easily be decoupled if we embrace semantically described services at a granular level for business logic (in a similar vein to the command query separation idea) and then combine them into larger pieces. So, the core of this app is described as a series of small task services that do only one thing as a way to separate them and name them meaningfully, and they are bound together into a larger service that joins and calls these sub-services (process exchange rate request), which forms a kind of little language of services.

Each model in the domain is described inside its source file in a way that hopefully explains how they inter-relate.

The separation of services makes the code a tiny bit cumbersome to read when comparing it to simple dot chaining, but the benefits are that it's easier to understand, and it means the parts are properly separated. This means it's more easy to test, easier to change to being concurrent and/or parallel, and extremely easy to adjust, extend and reuse.

I opted to have each of the sub-services throw when they encounter errors, and use a happy path of service calls in the larger service, which is wrapped with a begin rescue so any failures get marked as an error into the request when trying to fulfil that.

So, to add the button that does concurrent fetch was trivial (a few minutes). To make fetching async wouldn't be too hard either (because fetch requests are separate records). Because of the domain modelling, to add new currencies is trivial, (just add them to the seeds file), and to add new exchange types (currency pairs) is also quite trivial (again, add them to the seeds file). I did think about concurrency and rate limiting in the API, but I figured it would be fine as is for now given there's only two exchange rate types at present.

