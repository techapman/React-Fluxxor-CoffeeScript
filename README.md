#Todo MVC
##Getting Started
1. Run ```npm install``` the dependencies from ```package.json```.
2. Run ```coffee -c -o build/js src/coffee``` to compile CoffeeScript files into JavaScript. JavaScript files compile into the ```build/js``` directory.
3. Run ```browserify build/js/app.js -o dist/js/app-bundle.js``` to bundle UR JavaScripts into one file. This is what ```index.html``` needs to run.
4. Open ```index.html``` in your browser and enjoy!
