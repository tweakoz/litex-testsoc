#!/usr/bin/env python3

from ork.command import run
import ork.deco 
import os

deco = ork.deco.Deco()

ipaddr = os.environ["SOCIPADDR"]
password = os.environ["SOCPASSWORD"]

print( "the password is <%s>" % deco.val(password) )
run(["ssh","-o","StrictHostKeyChecking=no","root@%s"%ipaddr])
