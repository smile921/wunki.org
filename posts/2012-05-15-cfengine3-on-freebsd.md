---
title: CFengine3 on FreeBSD
summary: Short guide how to install CFengine 3 on FreeBSD
tags: freebsd, cfengine
keywords: freebsd, cfengine, installation
---

The joy of successfully getting a website to run on a bare install server was
gone when I had to do it for the twentieth time. This is when I decided to get
a [Puppetmaster] running for [Twoppy]. Took me a week to automate the process
of getting a [Django] server and adding it to the loadbalancer, not a bad
experience, but since I'm an FreeBSD evangelist I heard that [CFengine] is a
faster, leaner tool to get servers running, especially FreeBSD.

When a new overhaul called CFengine3 came out, along with the book
"[Learning CFengine 3]" there was nothing to stop me from trying it. So I
decided to setup CFengine so I can use it for our new project [Invy]. Except
that installing it on the Mac (with [Homebrew]) proofed to be a pain in the
buttocks. So, here is how to ignore the Mac and set it up on FreeBSD and start
playing with CFengine3.

## Installation from Ports

We are going to install CFengine3 from the ports, so make sure you have the
latest ports available on your system. You can check with:

    portsnap fetch update
    
CFengine is located in the `sysutils/cfengine3` directory. Install it as root:

    cd /usr/ports/sysutils/cfengine3
    make install clean
    
I choose the default setup with [Tokyo Cabinet]. First we will need to create
a private and public key pair:

    /usr/local/sbin/cf-key
    
We have to copy the binaries to the CFengine directory, so CFEngine can find
them. Not sure why this is needed, probably because CFengine wants to be able
to verify them.

    cp /usr/local/sbin/cf-* /var/cfengine/bin/
    
Our server expects the "master files", meaning the main configuration files
under the `/var/cfengine/masterfiles/` directory. We need to copy the default
files there:

    cp -Rp /usr/local/share/cfengine/CoreBase/ /var/cfengine/masterfiles
    
The last step is bootstrapping CFengine, which copies the configuration files
to their final working location and starts the daemon. For this you need to
know the ip address, you can find this with `ifconfig`. With the ip address,
run the following command:

    cf-agent --bootstrap --policy-server <your-ip-address>
    
If everything went fine, you should be presented with `Bootstrap to
<your-ip-address> completed successfully`. Final step is adding CFengine to
your `/etc/rc.conf`, so that it starts on every boot.

    # Enable Cfengine 3
    cf_execd_enable="YES"
    cf_serverd_enable="YES"
    
I completed the above installation on a FreeBSD virtual machine (with
Parallels) and am now following along with the "[Learning CFengine 3]"
book. Hopefully I can present you with a [Github] repository that will setup a
FreeBSD server for your web application anytime soon!

[Puppetmaster]: http://puppetlabs.com/ "Puppet labs homepage"
[Twoppy]: http://www.twoppy.com/ "Twoppy homepage"
[Django]: https://www.djangoproject.com/ "Django homepage"
[CFengine]: http://cfengine.com/ "CFengine homepage"
[Learning CFengine 3]: http://www.amazon.com/dp/1449312209/?tag=wunki-20 "Amazon Affiliated link to Learning CFengine 3"
[Invy]: https://www.invyapp.com/ "Invy homepage"
[Homebrew]: https://github.com/mxcl/homebrew "Homebrew on Github"
[Tokyo Cabinet]: http://fallabs.com/tokyocabinet/ "Tokyo Cabinet homepage"
[Github]: https://github.com/wunki "Wunki on Github"
