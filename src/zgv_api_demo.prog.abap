*&---------------------------------------------------------------------*
*& Report zgv_api_demo
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT zgv_api_demo.

*       Input Parameters: Country and (City-) Name
        PARAMETERS: p_countr TYPE string,
                    p_name TYPE string.

        DATA:

                lv_response TYPE STRING,
                lr_data TYPE REF TO data,
                lo_client TYPE REF TO if_http_client,
                lv_string TYPE string,
                lv_val TYPE string,
                lv_term TYPE string.

*                Pass the URL to get Data
                  lv_string = |http://universities.hipolabs.com/search?country={ p_countr }&name={ p_name }|.

*                Creation of New IF_HTTP_Client Object
                  cl_http_client=>create_by_url(
                  EXPORTING
                    url                = lv_string
                  IMPORTING
                    client             = lo_client
                  EXCEPTIONS
                    argument_not_found = 1
                    plugin_not_active  = 2
                    internal_error     = 3
                    ).

                  IF sy-subrc IS NOT INITIAL.
                    MESSAGE 'SOMETHING WENT WRONG!' TYPE 'I'.
                  ENDIF.

                  lo_client->request->set_method( 'GET' ).

*                Structure of HTTP Connection and Dispatch of Data
                  lo_client->send( ).
                  IF sy-subrc IS NOT INITIAL.
                    MESSAGE 'SOMETHING WENT WRONG!' TYPE 'I'.
                  ENDIF.

*                Receipt of HTTP Response
                  lo_client->receive( ).
                  IF sy-subrc IS NOT INITIAL.
                    MESSAGE 'SOMETHING WENT WRONG!' TYPE 'I'.
                  ENDIF.

                lv_response = lo_client->response->get_cdata( ).

                lr_data = /ui2/cl_json=>generate( json = lv_response ).

                do 10 times.

*               Display Name and web page for each University (limited to 10)
                lv_term = '[' && sy-index && ']-name'.
                /ui2/cl_data_access=>create( ir_data = lr_data iv_component = lv_term )->value( IMPORTING ev_data = lv_val ).

                REPLACE ALL OCCURRENCES OF'u00fc' IN lv_val WITH 'ü'.
                REPLACE 'u00e4' IN lv_val WITH 'ä'.

                WRITE lv_val.
                skip.
                lv_term = '[' && sy-index && ']-web_pages[1]'.
                /ui2/cl_data_access=>create( ir_data = lr_data iv_component = lv_term )->value( IMPORTING ev_data = lv_val ).
                WRITE lv_val.
                skip.
                skip.
                enddo.
