WebApp framework for Papyros
===============================

**Warning: this is very much an initial working concept. There is a lot to implement, and the project is not structured at all yet. Stay tuned for further progress!**

To use this in QML:

`import Material.WebApps 0.1` *or*

if just want to create the most basic webapp, you can create a JSON with the following fields:

 - **title** - the name of the WebApp/Site ex. Inbox, Soundcloud, Yahoo, Outlook
 - **url** (self-explanatory)
 - **loadingImage** - a banner, this is shown at startup until the web site loads, should be relative to the current directory ex. `images/banner.png`
 - **color** - the dark color (700 of 500 if the website's main color matches one of the material design ones)

and then just copy the `JSON2WebApp.py` script into your project's directory and run it, passing the name of the JSON file as an argument.