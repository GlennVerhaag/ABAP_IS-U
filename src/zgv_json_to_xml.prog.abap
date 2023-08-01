*&---------------------------------------------------------------------*
*& Report zgv_json_to_xml
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgv_json_to_xml.

DATA(json_string) = cl_abap_codepage=>convert_to(
 `{` &&
 ` "order":"4711",` &&
 ` "head":{` &&
 `  "status":"confirmed",` &&
 `  "date":"07-19-2012"` &&
 ` },` &&
 ` "body":{` &&
 `  "item":{` &&
 `   "units":"2", "price":"17.00", "Part No.":"0110"` &&
 `  },` &&
 `  "item":{` &&
 `   "units":"1", "price":"10.50", "Part No.":"1609"` &&
 `  },` &&
 `  "item":{` &&
 `   "units":"5", "price":"12.30", "Part No.":"1710"` &&
 `  }` &&
 ` }` &&
 `}` ).
CALL TRANSFORMATION id SOURCE XML json_string
                       RESULT XML DATA(xml).
cl_demo_output=>display_xml( xml ).
