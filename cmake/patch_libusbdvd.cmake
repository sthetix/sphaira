# Keep libusbdvd compatible with newer libnx releases that already define
# usb_request_type and usb_request_recipient.

if(NOT DEFINED FILE)
    message(FATAL_ERROR "FILE must be set")
endif()

file(READ "${FILE}" content)

set(old_block [[enum usb_request_recipient {
    USB_RECIPIENT_DEVICE    = 0x00,
    USB_RECIPIENT_INTERFACE = 0x01,
    USB_RECIPIENT_ENDPOINT  = 0x02,
    USB_RECIPIENT_OTHER     = 0x03,
};

enum usb_request_type {
    USB_REQUEST_TYPE_STANDARD = (0x00 << 5),
    USB_REQUEST_TYPE_CLASS    = (0x01 << 5),
    USB_REQUEST_TYPE_VENDOR   = (0x02 << 5),
    USB_REQUEST_TYPE_RESERVED = (0x03 << 5),
};
]])

if(content MATCHES "enum usb_request_recipient")
    string(REPLACE "${old_block}" "" content "${content}")
    file(WRITE "${FILE}" "${content}")
endif()
