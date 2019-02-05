#!/usr/bin/python3

import usb
import sys

VENDOR_ID = 0x1532  # Razer
PRODUCT_ID = 0x0221  # BlackWidow / BlackWidow Ultimate

USB_REQUEST_TYPE = 0x21  # Host To Device | Class | Interface
USB_REQUEST = 0x09  # SET_REPORT

USB_VALUE = 0x0300
USB_INDEX = 0x2
USB_INTERFACE = 2

LOG = sys.stderr.write

class blackwidow(object):
  kernel_driver_detached = False

  def __init__(self):
    self.device = usb.core.find(idVendor=VENDOR_ID, 
idProduct=PRODUCT_ID)

    if self.device is None:
      raise ValueError("Device {}:{} not found\n".format(VENDOR_ID, 
PRODUCT_ID))
    else:
      LOG("Found device {}:{}\n".format(VENDOR_ID, PRODUCT_ID))

    if self.device.is_kernel_driver_active(USB_INTERFACE):
      LOG("Kernel driver active. Detaching it.\n")
      self.device.detach_kernel_driver(USB_INTERFACE)
      self.kernel_driver_detached = True

    LOG("Claiming interface\n")
    usb.util.claim_interface(self.device, USB_INTERFACE)

  def __del__(self):
    LOG("Releasing claimed interface\n")
    usb.util.release_interface(self.device, USB_INTERFACE)

    if self.kernel_driver_detached:
      LOG("Reattaching the kernel driver\n")
      self.device.attach_kernel_driver(USB_INTERFACE)

    LOG("Done.\n")

  def bwcmd(self, c):
    from functools import reduce
    c1 = bytes.fromhex(c)
    c2 = [ reduce(int.__xor__, c1) ]
    b = [0] * 90
    b[5: 5+len(c1)] = c1
    b[-2: -1] = c2
    return bytes(b)

  def send(self, c):
    def _send(msg):
      USB_BUFFER = self.bwcmd(msg)
      result = 0
      try:
        result = self.device.ctrl_transfer(USB_REQUEST_TYPE, 
USB_REQUEST, wValue=USB_VALUE, wIndex=USB_INDEX, 
data_or_wLength=USB_BUFFER)
      except:
        sys.stderr.write("Could not send data.\n")

      if result == len(USB_BUFFER):
        LOG("Data sent successfully.\n")

      return result

    if isinstance(c, list):
      #import time
      for i in c:
        print(' >> {}\n'.format(i))
        _send(i)
        #time.sleep(.05)
    elif isinstance(c, str):
        _send(c)

###############################################################################

def main():
    init_new  = '0200 0403'
    init_old  = '0200 0402'
    pulsate = '0303 0201 0402'
    bright  = '0303 0301 04ff'
    normal  = '0303 0301 04a8'
    dim     = '0303 0301 0454'
    off     = '0303 0301 0400'

    bw = blackwidow()
    bw.send(init_old)

if __name__ == '__main__':
    main()
