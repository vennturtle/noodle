# Noodle - A survey app for casual curiosity

Ever wanted to know what the dude walking past you on the street thought about the new lackluster superhero movie that came out last weekend? Have you ever wanted to know how people felt about your club's recent bake sale, and if they really liked the special brownies you baked all last night?

Noodle is the iOS app for the layman's curiosities, that makes creating and taking surveys so easy you don't even have to think about it.

## Features

* *Create an account* - Sign up and sign in with no hassle! Passwords are securely encrypted by Firebase.
* *Create a survey* - Creating a survey in Noodle is easy and intuitive. You can set true-or-false, multiple-choice, and multiple-answer questions in seconds.
* *Narrow your survey* - You can set how long your survey will be up, and what area you'd like to poll from.
* *Take a survey* - Noodle shows you a map with all the surveys in your area. Answering them is just a tap away!
* *View your results* - You can view statistics for each question and find out which choices were the most popular.
* *Simple to use* - Noodle is dead-simple! Waste less time fussing over survey logistics, and spend more time on getting the answers that matter.

## Getting Started

### Prerequisites

Noodle is an iOS app that lives and breathes on Swift 3. Make sure that you're developing on Xcode 8.3.3 bundled with Swift 3 installed, as code written in Swift 3 is not guaranteed to work on Swift 4 or later versions.

Our project uses the Ruby application CocoaPods in order to manage dependencies. If you haven't yet installed CocoaPods, you can install it on the command line using

```bash
$ sudo gem install cocoapods
```

### Installing

When you first open Xcode, select the option to `Check out an existing project`. In the field where it asks for your repository location, enter `https://github.com/vennturtle/noodle.git`, select the branch you want to work with, and save it to a location on your system.

Once the project has finished downloading, open the project folder in your terminal and install the pods required to run the project by running

```bash
$ pod install
```

Then open the Xcode workspace file to start working on the application.

## Built With
* [Firebase](https://firebase.google.com/) - NoSQL database service used
* [CocoaPods](https://cocoapods.org/) - Dependency Management
* [MapKit](https://developer.apple.com/documentation/mapkit) - Location accessing

## Authors
* Luis Arevalo - *Project Coordination & UI Design* - [luisarevalo21](https://github.com/luisarevalo21)
* Brandon Cecilio - *Project Management & Back-end Dev* - [vennturtle](https://github.com/vennturtle)
* Marcus Norona - *Lead Front-end Dev & Design Consultant* - [mjnorona](https://github.com/mjnorona)
* Salvador Jr. Rodriguez - *Documentation & UI Design* - [Salvador-Jr](https://github.com/Salvador-Jr)

See also the list of [contributors](https://github.com/vennturtle/noodle/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](/LICENSE.md) file for details

## Acknowledgements
* Inspired by the likes of Strawpoll and SurveyMonkey
* Development funded and supported by our professor at SJSU, Mr. Keith Perry
