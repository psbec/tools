## DropDependence

This programe is used to drop dependence file for an app.

### Usage

Specify you app directory and destination directory, run progame like bellow:
```
hxg@hxg-ubuntu dropDependence $ ./dropDeps.sh 
usage: ./dropDeps.sh appDir copyToDir
```

For example, create java 1.8 environment:
```
hxg@hxg-ubuntu java $ ./dropDeps.sh jre1.8.0_131/bin/ ~/rootfs/dddd
Write to /home/hxg/rootfs/dddd
Start check dir jre1.8.0_131/bin/
process elf file: jre1.8.0_131/bin/policytool
    copy /lib/x86_64-linux-gnu/libpthread.so.0 to /home/hxg/rootfs/dddd/lib/x86_64-linux-gnu
    copy /lib/x86_64-linux-gnu/libpthread-2.23.so to /home/hxg/rootfs/dddd/lib/x86_64-linux-gnu
    copy /usr/lib/x86_64-linux-gnu/libX11.so.6 to /home/hxg/rootfs/dddd/usr/lib/x86_64-linux-gnu
    copy /usr/lib/x86_64-linux-gnu/libX11.so.6.3.0 to /home/hxg/rootfs/dddd/usr/lib/x86_64-linux-gnu
    ...
process elf file: jre1.8.0_131/bin/rmid
...
All Done!
```

After done, check destination directory:
```
hxg@hxg-ubuntu java $ tree ~/rootfs/dddd
/home/hxg/rootfs/dddd
├── lib
│   └── x86_64-linux-gnu
│       ├── ld-2.23.so
│       ├── libc-2.23.so
│       ├── libc.so.6 -> libc-2.23.so
│       ├── libdl-2.23.so
│       ├── libdl.so.2 -> libdl-2.23.so
│       ├── libgcc_s.so.1
│       ├── libm-2.23.so
│       ├── libm.so.6 -> libm-2.23.so
│       ├── libnsl-2.23.so
│       ├── libnsl.so.1 -> libnsl-2.23.so
│       ├── libpthread-2.23.so
│       └── libpthread.so.0 -> libpthread-2.23.so
├── lib64
│   └── ld-linux-x86-64.so.2 -> /lib/x86_64-linux-gnu/ld-2.23.so
└── usr
    └── lib
        └── x86_64-linux-gnu
            ├── libX11.so.6 -> libX11.so.6.3.0
            ├── libX11.so.6.3.0
            ├── libXau.so.6 -> libXau.so.6.0.0
            ├── libXau.so.6.0.0
            ├── libxcb.so.1 -> libxcb.so.1.1.0
            ├── libxcb.so.1.1.0
            ├── libXdmcp.so.6 -> libXdmcp.so.6.0.0
            └── libXdmcp.so.6.0.0
```
