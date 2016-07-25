# Ledcontroller
An esp8266 based controller for ws2812 LED strips, written in Lua.

## Development

### Setup
1 These tools should be installed globally.

Install as follows:

    $ npm install -g gulp
    $ npm install -g nodemcu-tool
    $ pip install nodemcu-uploader
    $ pip install esptool


2 Then install other dependencies locally by running:
    
    $ npm install

### Upload the NodeMCU firmware

Just run:

    $ ./flash.sh


### Upload the files for the LED controller

Just run:

    $ gulp
    
This will copy over all Lua files in src to the esp8266. If you run this command again it will only copy files that have been changed.

### Run a Lua script from the bash prompt

There are two kinds of script that are invocable from the the bash prompt: *commands* and *patterns*. Both are stored in there respective folders.
To run a script inside the 'command' folder, you can run:
    
    $ ./run.sh <command>
    

To run a script inside the 'pattern' folder, you can run:
    
    $ ./pattern.sh <command>

### More
Here a few more things you can do:

__Remove *.lc files from the esp8266__ 

      $ ./remove_lc.sh 
      
__Copy over all Lua files in src, changed or not__

      $ gulp all
      
__Reset the synchroniztion cache__
 
Deletes all files in 'dist'.

      $ gulp clean # 

     
__Fast dev cycle__

Does the following 3 things in order:

  1. copy modified files to esp8266
  2. reboot esp3266
  3. open serial connection to esp8266

    $ ./cycle.sh
 
__Lint your code__
Runs luacheck on your Lua files

    $ gulp lint
