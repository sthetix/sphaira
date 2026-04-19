if(NOT DEFINED FILE)
    message(FATAL_ERROR "FILE must be set")
endif()

file(READ "${FILE}" content)

set(old_enum_block [[enum usb_request_recipient {
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

set(local_enum_block [[enum usbdvd_request_recipient {
    USBDVD_USB_RECIPIENT_DEVICE    = 0x00,
    USBDVD_USB_RECIPIENT_INTERFACE = 0x01,
    USBDVD_USB_RECIPIENT_ENDPOINT  = 0x02,
    USBDVD_USB_RECIPIENT_OTHER     = 0x03,
};

enum usbdvd_request_type {
    USBDVD_USB_REQUEST_TYPE_STANDARD = (0x00 << 5),
    USBDVD_USB_REQUEST_TYPE_CLASS    = (0x01 << 5),
    USBDVD_USB_REQUEST_TYPE_VENDOR   = (0x02 << 5),
    USBDVD_USB_REQUEST_TYPE_RESERVED = (0x03 << 5),
};
]])

if(content MATCHES "enum usb_request_recipient")
    string(REPLACE "${old_enum_block}" "" content "${content}")
endif()

set(anchor [[enum usb_request_bot {
    USB_REQUEST_BOT_GET_MAX_LUN = 0xFE,
    USB_REQUEST_BOT_RESET       = 0xFF
};
]])

if(NOT content MATCHES "enum usbdvd_request_recipient")
    string(REPLACE "${anchor}" "${anchor}\n${local_enum_block}" content "${content}")
endif()

set(old_reset [[    rc = usbHsIfCtrlXfer(usb_if_session, USB_ENDPOINT_OUT | USB_REQUEST_TYPE_CLASS | USB_RECIPIENT_INTERFACE, USB_REQUEST_BOT_RESET, 0, if_num, 0, NULL, &xfer_size);]])
set(new_reset [[    rc = usbHsIfCtrlXfer(usb_if_session, USB_ENDPOINT_OUT | USBDVD_USB_REQUEST_TYPE_CLASS | USBDVD_USB_RECIPIENT_INTERFACE, USB_REQUEST_BOT_RESET, 0, if_num, 0, NULL, &xfer_size);]])
string(REPLACE "${old_reset}" "${new_reset}" content "${content}")

set(old_clear [[    rc = usbHsIfCtrlXfer(usb_if_session, USB_ENDPOINT_OUT | USB_REQUEST_TYPE_STANDARD | USB_RECIPIENT_ENDPOINT, USB_REQUEST_CLEAR_FEATURE, 0x00, ep_addr, 0, NULL, &xfer_size);]])
set(new_clear [[    rc = usbHsIfCtrlXfer(usb_if_session, USB_ENDPOINT_OUT | USBDVD_USB_REQUEST_TYPE_STANDARD | USBDVD_USB_RECIPIENT_ENDPOINT, USB_REQUEST_CLEAR_FEATURE, 0x00, ep_addr, 0, NULL, &xfer_size);]])
string(REPLACE "${old_clear}" "${new_clear}" content "${content}")

file(WRITE "${FILE}" "${content}")
