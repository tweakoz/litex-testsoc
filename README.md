# TestSoc:
  Yet another *Litex/Linux/VexRiscV* SOC test (With integrated build environment). This SOC does not do much, it runs linux, blinks leds and talks over a network. It can mount a nfs folder from your devhost. It's primary purpose is as a toy project for use in communicating with other FPGA toolchain developers about the toolchains. It currently only runs on a Digilent Arty, but we can add other targets when needed. The enviroment is currently only 'certified' on Ubuntu 18.04 LTS. We can certify other OS's as data from other brave souls trickles in.

## Launching the environment:

To initialize the environment (after cloning):
 ```
cd <repository-root>
./bin/env.py
```

This should download any required dependencies into ```<repository-root>/.stage``` known as the ***staging folder***, then initialize and launch the dev environment. All build products should go into the *staging folder*, so you can start afresh by just exiting all *env shells* bound to that staging folder and deleting it, and relaunching your env. This would come with the expense of time spent rebuilding and downloading *everything*.

Some SOC configuration settings will be defaulted and persisted in *.stage/soc-config.json* - feel free to edit these to match your settings, after editing you will need to exit your env (just type ```exit``` at the shell prompt), and restart the env ( ```./bin/env``` ).


## Using the environment:

Assuming all went well:

* Build the SOC: type the following from any directory, its in your path.

  ```build.soc.py```


* While the SOC is annealing, you might as well start the *Linux buildroot* build so at least something is going in parallel. Make sure your soc-config.json and config env vars are set how you like them. Then start another *env shell* via ```./bin/env.py``` and type:

  ```build.linux.py```


* Whilst Linux and the SOC are cooking, in yet another *env shell*, lets build some other needed wares:

  * Build the chainloader:

    ```build.chainloader.py```

  * VexRiscV Machine Mode Emulator:

    ```build.emulator.py```

  * SOC's Linux Device Tree:

    ```build.devicetree.py```


* Once all those tasks have completed successfully (*Linux buildroot* will probably still be going for a while), Launch the SOC (using your tty):

  * Start the TFTP server (from one of your idle *env shells*):

    ```cd ${PROJECT_ROOT}/tftp_root```

    ```./tftp_server.py``` <- leave running in background

  * From another of your idle *env shells*, Find your board's tty

    ```lsttys.py | grep Digilent```

  * Launch it:

    ```launch.soc.py --tty /dev/ttyUSBx```

  * Connect to it:
  
     ```connect.soc.py```


* When you are finished playing, just exit your *env shells*, you can always re-enter them later by running ```testsoc/bin/env.py```

* If you want to add stuff on to the environment, best practice would be to use the environment variables for placing files. Some of the environment variables include:
  * ***${PROJECT_ROOT}*** : the directory of the git repo you checked out. Contains the staging folder, and a few submodules.
  * ***${BUILDROOT_DIR}*** : where Linux Buildroot Lives
  * ***${SOC_BUILD_DIR}*** : where the Litex build products go - gateware and software
  * ***${SOC_DIR}*** : SOC source directory
  * ***${SOCIPADDR}*** : the SOC's IP address 
  * ***${SOCPASSWORD}*** : the SOC's root password
  * ***${DEVTTY}*** : the SOC's programming port tty device name
  * ***${DEVHOSTIP}*** : the development host's IP address (for the TFTP server)
  * ***${NFSHOSTIP}*** : an optional NFS server IP address
  * ***${VIRTUAL_ENV}*** : python virtual environment
  
