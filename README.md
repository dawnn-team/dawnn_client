<p align="center">
  <img width="270" height="270" src="https://user-images.githubusercontent.com/41195669/111856294-13324900-8900-11eb-99e7-92a71fe0d4c1.png">
</p>

![android build](https://github.com/dawnn-team/dawnn_client/actions/workflows/android_flutter.yml/badge.svg) ![ios build](https://github.com/dawnn-team/dawnn_client/actions/workflows/ios_flutter.yml/badge.svg)

# Table of Contents
* [About](#about)
* [Inspiration](#inspiration)
* [For developers](#for-developers)
* [Contributing](#contributing)

# About 
 The idea behind this app is simple - to provide a tool that can help users avoid potential danger. A user can take a picture of a potential threat, add a caption, upload it, and other Dawnn users nearby will be alerted. Users can see the danger plotted on a map, view the image and see more information about it. This feature set is to be expanded.
 
# Inspiration 
 This project is inspired by the events in Belarus following the August 2020 election. It strives to support the democratic resistance movement by providing an easy-to-use application that can help peaceful protesters stay aware of potential threats.
 
 This repository is for the client, and the server is available at [dawnn-team/dawnn_server](https://github.com/dawnn-team/dawnn_server). All components of this project are open source, and [contributions](#contributing) are encouraged. More information can be found at our [offical website](https://dawnn.org).
 
# For developers
  ### Getting started
   To get started, clone this repository. Make sure you have all the [necessary tools](https://flutter.dev/docs/get-started/install) for Flutter development.
  ### Usage
   To use this project properly, you need a Google Maps API key. Information regarding this can be found [here](https://developers.google.com/maps/documentation/javascript/get-api-key). Depending on the platform being targetted, you will need to add the API key to either ``android/app/main/AndroidManifest.xml`` or ``ios/Runner/AppDelgate.swift``. When without an API key, the map component will not function properly.
   
   When testing the application, requests should be directed at ``dev.dawnn.org``. When the app enters production, requests from non-production clients to ``api.dawnn.org`` will be denied.
   
# Contributing
In order to contribute, check out our [projects](https://github.com/orgs/dawnn-team/projects). Choose a goal, and then an issue/feature/bug to work on. Please follow our [contribution guidelines](https://github.com/dawnn-team/dawnn_client/blob/main/CONTRIBUTING.md).
