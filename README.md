# Lottery Jug Swift

![Swift](https://img.shields.io/badge/Swift-4-green.svg?style=flat)
![Vapor](https://img.shields.io/badge/Vapor-2.0-green.svg?style=flat)
[![Build Status](https://travis-ci.org/AurelTyson/lottery-jug-swift.svg?branch=master)](https://travis-ci.org/AurelTyson/lottery-jug-swift)

Lottery application for Jug Montpellier in Swift using [Vapor](https://github.com/vapor/vapor) framework.

## To dev (Mac OS)
To generate a Xcode project :

* Install Xcode
* Install [Vapor](https://github.com/vapor/vapor)
* Execute `vapor xcode`
* Open the generated project

## To build under Linux
```
docker run --rm -ti -v $(pwd):/vapor asensei/vapor:latest vapor build
```

## To run
```
docker run --rm -ti -p 8080:8080 -e ORGA_ID='XXXXX' -e TOKEN='XXXXXXX' -v $(pwd):/vapor asensei/vapor:latest vapor run
```

## To get winners
Go to `http://localhost:8080/winners?nb=X` where `X` is the number of winners you want 😊