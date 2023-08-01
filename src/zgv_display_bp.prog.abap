*&---------------------------------------------------------------------*
*& Report zgv_display_bp
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgv_display_bp.

Parameters: lv_id TYPE zgv_de_id.
DATA lr_columns TYPE REF TO cl_salv_columns_table.
DATA: business_partners TYPE TABLE OF ZGV_T_BP,
      adresses TYPE TABLE OF ZGV_T_ADRESS,
      lo_alv TYPE REF TO cl_salv_table.

select * from ZGV_T_BP appending table business_partners where id = lv_id.
select * from ZGV_T_ADRESS appending table adresses where id_business_partner = lv_id.

IF business_partners is INITIAL.
WRITE 'Business Partner not found!'.
ELSE.


    TRY.
        cl_salv_table=>factory(
        IMPORTING
        r_salv_table = lo_alv
        CHANGING
        t_table =  business_partners ).
    CATCH cx_salv_msg into data(lx_msg).
    cl_demo_output=>display( lx_msg ).
    ENDTRY.


    lr_columns = lo_alv->get_columns( ).
    lr_columns->set_optimize( 'X' ).
    lr_columns->get_column( 'ID' )->set_long_text( 'Business Partner ID' ).
*    lr_columns->get_column( 'NAME' )->set_long_text( 'Name' ).
*    lr_columns->get_column( 'LASTNAME' )->set_long_text( 'Last Name' ).
*    lr_columns->get_column( 'ID_ADRESS' )->set_long_text( 'Adress ID' ).
*    lr_columns->get_column( 'CLIENT' )->set_long_text( 'Mandant' ).
    lo_alv->display( ).

ENDIF.
AT USER-COMMAND.
    lo_alv->set_data( CHANGING t_table = adresses ).
    lo_alv->refresh( ).
